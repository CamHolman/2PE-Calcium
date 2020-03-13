function fig = plotMulti(figure_list)
    %{
        Intro:
            The purpose of this function is to create multiplots using . You 
            pass the function a list of related figure handles to be plotted over
            time. This might include:

                [%FOV_plot, pupil_radius_plot, locomotion_plot]
            
            This would result in a 1 column, 3 row figure containing 3 subplots in
            the order they were passed in:
            
                    [%FOV_plot] 
                    [pupil_radius_plot] 
                    [locomotion_plot]


        Inputs:
            figure_list  |   List of figure handles to polulate the 

        Outputs:
             fig         |   Return plot handle for further manipulation

    %}  

    %% Set up 
        ff =  figure_list;        % easyvars
        nrows = numel(ff);        % Set number of tile rows based on length of ff 
        ncols = 1;                % Always have 1 column here as plots are over time

        fig = tiledlayout(...
                    nrows, ...
                    ncols, ...
                    'TileSpacing', 'compact' ...
                    ); 


    %% Populate tiles
        for i_tile = 1:nrows 
            
            cur_tile = nexttile();                      % move to next tile position
            cur_fig = ff(i_tile);                       % Extract current figure handle

            copyobj(allchild(get(cur_fig,'CurrentAxes')), cur_tile);    % Copy object from figure handle into tile
            
            %%%
            if i_tile ~= nrows
                set(gca, 'XColor', 'none')
            end
            
            set(gca,'FontSize',10)
            %%%

        end
  
    %% Format

    xlabel('time (sec)')
    

end