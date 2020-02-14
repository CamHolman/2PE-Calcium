function vel = optoToVelocity(ephys)
%{
    This function will take opto data as read by readEphys and return
    another structure that contains velocity / movement data

    This is based on the current Poskanzer Lab wheel radius, num tabs etc

%}


    A = length(ephys.opto)
    for kk = 1:A % For each opto trace
    %% velocity
        clear opto velocity 
        opto = ephys.opto{kk}
        % Define Wheel Statistics
        Radius  = 11.06; %radus in cm
        noftabs = 30; %number of tabs
        circumference = 2*pi*Radius;
        distpertab =circumference/(2*noftabs); %distance per tab (tabs are evenly spaced and the wheel is split equally)
        samplerate = 1000; %aquisition rate
        twindow = samplerate; %window in miliseconds
        
        %Look at derivative of wheel trace
        diffSC = diff(opto); %derivative of the square pulses
%        figure; plot(1:1:length(opto)-1,diffSC) %plot
        
        %define likely break points and binarize
        triggerframes = find(abs(diffSC)>=mean(diffSC)+std(diffSC)); %find where there was probably a change from blocked to open
        tabtransittimes = zeros(1,length(opto)); %make an empty matrix
        tabtransittimes(triggerframes)= 1; %binarize the transitions
        
        %sum transitions over the window
        j=1;
        for i=1:twindow:length(opto)-twindow
            numbreaks(j) = sum(tabtransittimes(i:i+twindow));
            j=j+1;
        end
        
        velocity = numbreaks * distpertab; %gives approximate velocity at ege of wheel
        vel{kk} = velocity;
    
    %% Plot velocity for testing
    %{    
        figure(jj); hold on;
        subplot(5,1,3); hold on;
        plot(1:length(numbreaks),velocity, 'LineWidth',2,'Color','k')
        ylabel('wheel velocity')
        xlabel('time (sec)')
        set(gca,'FontSize',18)
        axis([0 length(epercEvts) 0 max(velocity)+5])
    %}
end