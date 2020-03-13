function fig = plotVelocity(velocity)
    %{
        Introduction
            Plot velocity per second

        Inputs
            velocity    |   Vector of velocity per second (as output by opto2velocity)

        Outputs
            fig         |   Return plot handle for further manipulation
    %}
     
    fig = figure(); 

    plot(1:length(velocity),velocity, 'LineWidth',2,'Color','k')
    ylabel('wheel velocity')
    xlabel('time (sec)')
    set(gca,'FontSize',18)
    
    axis([0 length(velocity) 0 max(velocity)+5])
end 