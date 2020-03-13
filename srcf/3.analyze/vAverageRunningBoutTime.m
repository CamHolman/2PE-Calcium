

function result = average_running_bout_time (running_bool)
    %{
        Average Running Bout Time
        Returns the average running bout duration during the given running_bool trial 
    %}

    current_length = 0;
    running_bout_lengths=[];
    for ii = 1:numel(running_bool)
        if running_bool(ii) == 1
            current_length = current_length + 1;
        elseif running_bool(ii) == 0  
            if current_length ~= 0 
                running_bout_lengths(end +1) = current_length;
                current_length = 0;
            
            end
        end
    end
    result = mean (running_bout_lengths)
end