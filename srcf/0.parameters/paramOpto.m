function params = paramOpto()

    % Define Wheel Statistics
    radius  = 11.06;                            % Radius in cm      (def = 11.06)     
    noftabs = 30;                               % Number of tabs    (def = 30)
    circumference = 2*pi*radius;                % Circumference of wheel
    distpertab =circumference/(2*noftabs);      % Distance per tab
    samplerate = 1000;                          % Aquisition rate   (def = 1 KHz)
    twindow = samplerate;                       % Window in miliseconds

    % Pass to struct
    params.radius = radius;           
    params.noftabs = noftabs;         
    params.circumference = circumference;
    params.distpertab = distpertab;
    params.samplerate = samplerate;
    params.twindow = twindow;

end