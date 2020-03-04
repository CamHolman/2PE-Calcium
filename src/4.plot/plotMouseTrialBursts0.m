function fig = plotMouseTrialBursts0(mouse, vidix)
    % This is the same as plotMouseTrial including plotNumEvts, plotPercActive, plotVelocity.
    % The difference is that it plots the colored boxes where bursts are detected on all plots
    % easy visualization
    %
    %   Inputs:
    %       exp         |   Output of buildMouse containing data from all
    %                       analyzed videos and ephys/opto data
    %
    %       vidix       |   Index of video to plot from data within burstStats
    %
    %   Outputs:
    %       fig         |   Return plot handle for further manipulation
    
        %% Set up figure
            fig = figure();
            %hold on;

        %% Plot Perc Evts in subplot 2
            %{
                Extracting burst data first in order to plot boxes on all 
                graphs, %FOV will still stay in subplot 2
            %}
            percEvts = subplot(3,1,2)
        
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
    
        %% Plot Num Events in subplot 1
            numEvts = subplot (3,1,1)
            
            % Draw boxes on figure around detected bursts
            for i = 1:size(bursts{jj},1)
                rectangle(...
                    'Position',[bursts{jj}(i,1)*tRes 0 (bursts{jj}(i,2)-bursts{jj}(i,1))*tRes 100], ...
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
            axis([0 length(enumEvts) 0 max(enumEvts)+2])
            set(gca,'fontsize',18)
%            set(gca, 'XTick', [])
            box off
            
            
    
        
    
        %% Plot velocity in subplot 3
            vel = subplot(3,1,3)
            
            % Draw boxes on figure around detected bursts
            for i = 1:size(bursts{jj},1)
                rectangle(...
                    'Position',[bursts{jj}(i,1)*tRes 0 (bursts{jj}(i,2)-bursts{jj}(i,1))*tRes 100], ...
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
            axis([0 length(velocity) 0 max(velocity)+5])
            box off
            
            

        %% Allign the y labels
            %{
                Taken from here https://www.mathworks.com/matlabcentral/fileexchange/41701-y-labels-alignment-in-subplots
                and modified with instructions from comments
            %}
            align_Ylabels(fig)
    end