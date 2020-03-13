function result = artifact_filter (array, limit)
    %{
        Introduction
            Filter out Artifacts (Array)
            This function will filter out all entries from raw opto/neural_signal 
            data in which the neural signal is above or below +/- the provided 
            limit (mV). Time relations are not conserved. This can be useful for
            generating spectrums, use with caution when correlating with time related
            signal like velocity. 

        Input
            array       |   vector of ephys data

            limit       |   limit in mV to filter out 

        Output 
            array       |   Filtered vector 
    %}
    

    array(abs(array(:,2)) >= limit, :) = [];

    result = array;
end