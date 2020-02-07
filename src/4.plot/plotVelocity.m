function fig = plotVelocity(mouse, vidix)
% Plot velocity per second
%   Inputs:
%       exp         |   Output of buildMouse containing data from all
%                       analyzed videos and ephys/opto data
%
%       vidix       |   Index of video to plot from data within burstStats
%
%   Outputs:
%       fig         |   Return plot handle for further manipulation


    fig = figure(); 
    velocity = mouse.velocity{vidix}


    plot(1:length(velocity),velocity, 'LineWidth',2,'Color','k')
    ylabel('wheel velocity')
    xlabel('time (sec)')
    set(gca,'FontSize',18)
    
    axis([0 length(velocity) 0 max(velocity)+5])
end