function fig = plotVelocityBouts(plot_handle, velocity, min_bout_duration)
    %{
        Introduction    
            Adds boxes showing running bouts to other plot
            
        Input
            plot_handle         |   plot on which you want to add velocity bouts

            velocity            |   vector with velocity per second data as output by opto2velocity

            min_bout_duration   |   Minimum Bout duration in seconds

        Output
            fig                 |   Return plot handle for further manipulation

    %}

    % Plot velocity and set up figure 

    fig = figure()


    % Detect running bouts
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
        if when_run(ff,2) - when_run(ff,1) < min_bout_duration
            when_run(ff,1) = 0;
            when_run(ff,2) = 0;
        end 
    end

    % Plot running bout boxes
    for i = 1:size(when_run,1)
        rectangle(...
            'Position',[when_run(i,1) 0 when_run(i,2)-when_run(i,1) 100], ...
            'FaceColor',[0.9718 0.5553 0.7741], ...
            'EdgeColor','none' ...
            ); 
        hold on;
    end

    % Copy other plot on top
    copyobj(allchild(get(plot_handle,'CurrentAxes')), gca)
    
    % Set ylim to depend on original figure
    
    cur_ydata = plot_handle.Children.Children.YData
    ymax = max(cur_ydata)
    
    ylim([0, ymax+5])

end