function velocity = opto2velocity(opto)
    %{
        Intro:
            The purpose of this function is to take optoswitch data and return a 
            vector of velocity/second


        Inputs:
            opto          |     Optoswitch data (vetor of optoswitch readings / sample rate)

        Outputs:
            velocity      |   Vector of velocity per second

    %}  

    clear velocity 
    
    % Pull Wheel Statistics from paramO
    paramO = paramOpto()

    radius = paramO.radius;                      % Radius in cm      (def = 11.06)
    noftabs = paramO.noftabs;                    % Number of tabs    (def = 30)
    circumference = paramO.circumference;        % Circumference of wheel
    distpertab = paramO.distpertab               % Distance per tab
    samplerate = paramO.samplerate;              % Aquisition rate   (def = 1 KHz)
    twindow = paramO.twindow;                    % Window in miliseconds
    
    % Look at derivative of wheel trace
    diffSC = diff(opto); %derivative of the square pulses

    % Define likely break points and binarize
    triggerframes = find(abs(diffSC)>=mean(diffSC)+std(diffSC)); %find where there was probably a change from blocked to open
    tabtransittimes = zeros(1,length(opto)); %make an empty matrix
    tabtransittimes(triggerframes)= 1; %binarize the transitions
    
    % Sum transitions over the window
    j=1;
    for i=1:twindow:length(opto)-twindow
        numbreaks(j) = sum(tabtransittimes(i:i+twindow));
        j=j+1;
    end
    
    % Caclulate velocity per second
    velocity = numbreaks * distpertab; %gives approximate velocity at ege of wheel

end