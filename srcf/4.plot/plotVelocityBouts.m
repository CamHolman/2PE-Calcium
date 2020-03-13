function fig = plotVelocityBouts(velocity, min_bout_duration)
    %{
        Introduction    
            Plots velcity with running sections highlighted
            
        Input
            velocity            |   Velocity vector as output from opto2velocity

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

    % Plot velocity trace 
    plot(1:length(velocity),velocity, 'LineWidth',2,'Color','k')
    ylabel('wheel velocity')
    xlabel('time (sec)')
    set(gca,'FontSize',18)
    
    axis([0 length(velocity) 0 max(velocity)+5])
end