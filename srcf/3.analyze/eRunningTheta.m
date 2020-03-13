function result  = running_theta (data, params, Gparams)

    spec = plot_spectrogram(data, params, [20 1])
    mean_power_per_time = band_extract (spec, Gparams.extract_lower_bound, Gparams.extract_upper_bound)
    
    
    running_times = process_running_data(data)
    
    % Remove first and last seconds from running times to match spec data, remove window/2 from each side
    running_times = running_times(10:length(running_times)-10)
    
    running_power_mean = mean(mean_power_per_time(running_times == 1))
    resting_power_mean = mean(mean_power_per_time(running_times == 0))
    
    result = {running_power_mean, resting_power_mean}
end