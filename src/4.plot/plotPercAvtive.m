function fig = plotPercActive(exp, vidix)
% Plot percent field of view active per second
%
%
%
%
%
%
    % Pull basic data
    jj = vidix;
    tRes = exp.res.tRes;
    bursts = exp.burst.bursts;
    epercEvts = exp.burst.burstStats.spercEvts{jj};

    % Set up colors and color spaceing from colorbrewer
    N=9;
    C = linspecer(N,'qualitative');

    % Create figure
    fig = figure();
    
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
    xlabel('time (sec)')
    ylabel('% FOV')
    axis([0 length(epercEvts) 0 100])
    set(gca,'fontsize',18)
    box off

    % Remove line below
    % burstStats.sizes{jj}(i) = out.allSize{jj}(i);

end