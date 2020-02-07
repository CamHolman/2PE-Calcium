function fig = plotNumEvts(exp, vidix)
% Plot number of events per second
%   Inputs:
%       exp         |   Output of buildExperiment containing data from all
%                       analyzed videos
%
%       vidix       |   Index of video to plot from data within burstStats
%
%   Outputs:
%       fig         |   Return plot handle for further manipulation
    
    % Extract Data 
    enumEvts = exp.burst.burstStats.snumEvts{vidix};
    
    % Plot Figure
    fig = figure();
    plot(enumEvts,'Color','k','LineWidth',3);
    xlabel('seconds');
    ylabel('number of event onsets');
    axis([0 length(enumEvts) 0 max(enumEvts)+25])
    set(gca,'fontsize',18)
    box off

end

