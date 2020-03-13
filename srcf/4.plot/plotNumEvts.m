function fig = plotNumEvts(vector_numEvents)
% Plot number of events per second
%   Inputs:
%       vector_numEvents        |   vector of number of events per second 
%
%       vidix       |   Index of video to plot from data within burstStats
%
%   Outputs:
%       fig         |   Return plot handle for further manipulation
    
    % Extract Data 
    enumEvts = vector_numEvents;
    
    % Plot Figure
    fig = figure();
    plot(enumEvts,'Color','k','LineWidth',3);
    xlabel('seconds');
    ylabel('number of event onsets');
    axis([0 length(enumEvts) 0 max(enumEvts)+2])
    set(gca,'fontsize',18)
    box off

end

