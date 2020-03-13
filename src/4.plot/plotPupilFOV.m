function fig = plotPupilFOV(mouse, vidix)
    %{
        The purpose of this function is to plot pupil and FOV supoerimposed 
        on the same plot        

    %}

    %% Plot FOV
        %% Plot Perc Evts in subplot 2
            %{
                Extracting burst data first in order to plot boxes on all 
                graphs, %FOV will still stay in subplot 2
            %}
            fig = figure()
        
            jj = vidix;
            tRes = mouse.res.tRes;
            bursts = mouse.burst.bursts;
            epercEvts = mouse.burst.burstStats.spercEvts{jj};

            % Set up colors and color spaceing from colorbrewer
            N=9;
            C = linspecer(N,'qualitative');

            % Draw boxes on figure around detected bursts
            for i = 1:size(bursts{jj},1)
                rectangle(...
                    'Position',[bursts{jj}(i,1)*tRes 0 (bursts{jj}(i,2)-bursts{jj}(i,1))*tRes 100], ...
                    'FaceColor',[0.9718 0.5553 0.7741], ...
                    'EdgeColor','none' ...
                    ); 
                hold on;
            end

            % Test line below
            %line(1:length(epercEvts), repmat(thr,length(epercEvts)),'LineStyle',':','Color','r','MarkerSize',10,'LineWidth',2); hold on;
            
            % Plot
            plot(epercEvts,'Color','k','LineWidth',3); 
            hold on;
            %xlabel('time (sec)')
            ylabel('% FOV')
            axis([0 length(epercEvts) 0 100])
            set(gca,'fontsize',18)
%            set(gca, 'XTick', [])
            box off



    %% PLOT PUPIL %%%%%%%%%%%%%%%%

    %% Extract interpolate and normalize data 
            %{
                Note: adding cell2mat here as readPupil inserts the data as 
                a cell array, not a vector. This is causing issue with 'max' and 
                plotting. May be better to convert this within readPupil initially
                rather than patching
            %}
        
        % Extract 
        pupilR = mouse.pupils.major_r{vidix}
    
        % Find empty cells and replace with NaN for interpolation
            %Find emptys and replace with NaNs
            emptyIndex = cellfun('isempty', pupilR);
            pupilR(emptyIndex)={NaN};

            % Make vector and interpolate vector at NaNs
            pupilR_vec = cell2mat(pupilR);
            xdata=(1:length(pupilR_vec))';
            pupilR_vec_I = interp1(...
                                    xdata(~isnan(pupilR_vec)), ...
                                    pupilR_vec(~isnan(pupilR_vec)), ...
                                    xdata);

            % Return to orig variable name so this can be transfereed to read pupil or 
            % analyze pupil
            pupilR = pupilR_vec_I;

        % Generate x axis in seconds rather than frames
        numframes = length(pupilR)
        fps = 30
        xax = linspace(1,numframes, numframes)/fps

        % Normalize pipilR to max size (%)
        maxR = max(pupilR) 
        pupilRNorm = 100 * pupilR/maxR;


    %% Generate smoothed trace of pupil size
        % Build kernel based on win
        windowWidth = 101; % Set win width - May change this to argument
        kernel = ones(windowWidth,1) / windowWidth; % Build kernel
        
        % Reflect beginning of trace based on windowWidth to avoid artifact
        ref = fliplr(pupilRNorm(1:windowWidth))
        pupilRNorm_ref = [ref', pupilRNorm']

        % Filter with moving average including ref_win
        filtered = filter(kernel, 1, pupilRNorm_ref) % filter with 'moving average'

        % Chop off ref
        smooth_pupilRNorm = filtered(windowWidth+1:end)

    %% Plot Smooth Figure
        hold on 
        plot(xax, smooth_pupilRNorm, 'Color','k','LineWidth',3);
        xlabel('Seconds');
        ylabel('Pupil Radius (%)');
        axis([0 max(xax) 0 100])
        set(gca,'fontsize',18)
        box off
end