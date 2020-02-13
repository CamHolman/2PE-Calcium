function fig = plotPupil(mouseP, vidix)
% Plot mousePupil radius per second
%   Inputs:
%       mouse       |   Output of buildMousePupil containing data from all
%                       analyzed videos
%
%       vidix       |   Index of video to plot from data within burstStats
%
%   Outputs:
%       fig         |   Return plot handle for further manipulation

%{
    Some notes: may want to add parameter to specify FPS in the video. For
    now all videos are 30 FPS so will treat as such. Could add varargin and 
    set default to 30 
%}

    %% Extract data 
        %{
            Note: adding cell2mat here as readPupil inserts the data as 
            a cell array, not a vector. This is causing issue with 'max' and 
            plotting. May be better to convert this within readPupil initially
            rather than patching
        %}

    %% mouseP.pupils.major_r{vidix}


    pupilR = mouseP.pupils.major_r{vidix}
    
    % Find empty cells and replace with NaN for interpolation
        %Find emptys and replace with NaNs
        emptyIndex = cellfun('isempty', pupilR)
        pupilR(emptyIndex)={NaN}

        % Make vector and interpolate vector at NaNs
        pupilR_vec = cell2mat(pupilR)
        xdata=(1:length(pupilR_vec))'
        pupilR_vec_I = interp1(...
                                xdata(~isnan(pupilR_vec)), ...
                                pupilR_vec(~isnan(pupilR_vec)), ...
                                xdata)

    % Return to orig variable name so this can be transfereed to read pupil or analyze pupil
    pupilR = pupilR_vec_I

    %% Generate x axis in seconds rather than frames
    numframes = length(pupilR)
    fps = 30
    xax = linspace(1,numframes, numframes)/fps 

    %% Normalize pipilR to max size (%)
    maxR = max(pupilR)
    pupilRnorm = pupilR/maxR

    %% Plot Figure
    fig = figure()
    plot(xax, pupilR, 'Color','k','LineWidth',3);
    xlabel('Seconds');
    ylabel('Pupil Radius (%)');
    axis([0 max(xax) 0 100])
    set(gca,'fontsize',18)
    box off
