function fig = plotMouseTrialSae(mouse, vidix)
    %{
        The purpose of this function is to plot figures for sae that include:
            [%FOV]
            [Pupil]
            [Locomotion]
    
    %}


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DETECT VELOCITY BOXES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    velocity = mouse.velocity{vidix}
    tRes = mouse.res.tRes;
    jj = vidix;

    runi = 0
    running_bool = 0
    for vv = 1:length(velocity)
        if velocity(vv) == 0 && running_bool == 0 
            continue
        end
        
        if velocity(vv) > 0 && running_bool == 0
            running_bool = 1;
            runi = runi + 1;
            when_run(runi,1) = vv-1;
            
        end
        
        if velocity(vv) == 0 && running_bool == 1
            running_bool = 0;
            when_run(runi,2) = vv-1;
        end

    end

    % remove very short running periods
    for ff = 1: size(when_run, 1)
        if when_run(ff,2) - when_run(ff,1) < 2
            when_run(ff,1) = 0;
            when_run(ff,2) = 0;
        end 
    end


    % Set up figure
    fig = figure()
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Num Events in subplot 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numEvts = subplot (4,1,1)
        

        for i = 1:size(when_run,1)
            rectangle(...
                'Position',[when_run(i,1) 0 when_run(i,2)-when_run(i,1) 100], ...
                'FaceColor',[0.9718 0.5553 0.7741], ...
                'EdgeColor','none' ...
                ); 
            hold on;
        end
        
        
        % Plot trace
        enumEvts = mouse.burst.burstStats.snumEvts{vidix};
        plot(enumEvts,'Color','k','LineWidth',3);
        %xlabel('seconds');
        ylabel('NumEvts');
        
        xlim([0,200])
        ylim([0,max(enumEvts)+2])
        %xis([0 length(enumEvts) 0 max(enumEvts)+2])
        set(gca,'fontsize',18)
        set(gca, 'XColor', 'none')
        box off

        

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Perc Evts in subplot 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %{
                Extracting burst data first in order to plot boxes on all 
                graphs, %FOV will still stay in subplot 2
            %}
            percEvts = subplot(4,1,2)
            
            for i = 1:size(when_run,1)
                rectangle(...
                    'Position',[when_run(i,1) 0 when_run(i,2)-when_run(i,1) 100], ...
                    'FaceColor',[0.9718 0.5553 0.7741], ...
                    'EdgeColor','none' ...
                    ); 
                hold on;
            end


            jj = vidix;
            tRes = mouse.res.tRes;
            bursts = mouse.burst.bursts;
            epercEvts = mouse.burst.burstStats.spercEvts{jj};

            % Set up colors and color spaceing from colorbrewer
            N=9;
            C = linspecer(N,'qualitative');

        

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
            ylim([0,100])
            xlim([0,200])
            set(gca, 'XColor', 'none')
            box off
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT PUPIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Extract interpolate and normalize data 
                %{
                    Note: adding cell2mat here as readPupil inserts the data as 
                    a cell array, not a vector. This is causing issue with 'max' and 
                    plotting. May be better to convert this within readPupil initially
                    rather than patching
                %}
            
            % Extract 
            pupilR = mouse.pupils.major_r{vidix} (1:7000)
        
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
                                        xdata...
                                        );

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

            pupil = subplot(4,1,3)

            for i = 1:size(when_run,1)
                rectangle(...
                    'Position',[when_run(i,1) 0 when_run(i,2)-when_run(i,1) 100], ...
                    'FaceColor',[0.9718 0.5553 0.7741], ...
                    'EdgeColor','none' ...
                    ); 
                hold on;
            end




            
            plot(xax, smooth_pupilRNorm, 'Color','k','LineWidth',3);
            %xlabel('Seconds');
            ylabel('Pupil Radius (%)');
            axis([0 max(xax) 0 100])
            set(gca,'fontsize',18)
            ylim([25, 100])
            xlim([0,200])
            set(gca, 'XColor', 'none')
            box off


        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot velocity in subplot 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            vel = subplot(4,1,4)

            for i = 1:size(when_run,1)
                rectangle(...
                    'Position',[when_run(i,1) 0 when_run(i,2)-when_run(i,1) 100], ...
                    'FaceColor',[0.9718 0.5553 0.7741], ...
                    'EdgeColor','none' ...
                    ); 
                hold on;
            end
           
            
            % Plot trace
            velocity = mouse.velocity{vidix}

            plot(1:length(velocity),velocity, 'LineWidth',2,'Color','k')
            ylabel('Velocity')
            xlabel('time (sec)')
            set(gca,'FontSize',18)
            xlim([0,200])
            %axis([0 length(enumEvts) 0 max(velocity)+5])
            box off
             
             
 
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Allign the y labels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %{
                 Taken from here https://www.mathworks.com/matlabcentral/fileexchange/41701-y-labels-alignment-in-subplots
                 and modified with instructions from comments
             %}
             align_Ylabels(fig)
        end