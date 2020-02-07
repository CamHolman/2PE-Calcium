function exp = buildExperiment(aqDir, datDir, spRes, tRes, outDir)
%{
    The purpose of this function is to act as a master to build an experiment 
    structure from AQuA output. This structure will contain all of the the relevant 
    information for the experiment including spatial and temporal resolutions, bursts 
    timings, burstStats, sparkle stats etc. 

    This will allow ploitting functions to work by only passing one argument after 
    setup as well as having general organizational benefits. 

    Futher, this function will be used by higher level functions that build experiments 
    designed to compare velocity and pupil data with AQuA data

    As velocity, pupil data, _______, are not used by everyone, those will not be included 
    here. Instead, this will simply be to pull out bursts and sparkles from AQuA feature
    output and to allow for easy visualization of the data

    All of the data passed to this funtion should be related. I.e. it should represent one 
    mouse and all of its AQuA videos. If you are working with slices, it should contain all
    AQuA videos that were extracted from related slices (by genotype, etc)

    Inputs:
        aqDir       |   The directory in which your AQuA repository exists
        
        datDir      |   The directory where your data is stored. The data in this directory
                        should be related, i.e. it should all be from one mouse or one set
                        of slice experiments. The organization of this directory is important 
                        and should follow the outline below:
                            > Mouse /or/ Related Set of Slices
                            |   > Trial 1 
                            |   |   > AQuA output folder
                            |   |   |   - _aqua.mat
                            |   |   |   - _aqua_landmark.png
                            |   |   |   - _aqua.tif
                            |   |   |   - _aqua.xlsx
                            |   |   |
                            |   |   - other trial data (pupil, velocity, etc) 
                            |   |
                            |   > Trial 2
                            |   |   > AQuA output folder
                            ...

                        datDir should refer to 'Mouse', i.e.:
                            '/path/to/mouse/'

        spRes       |   Spatial resolution of the video, i.e. microns/pixel. This data 
                        can be pulled from the xml files of the videos that were analyzed.

        tRes        |   Temporal resolution of the video, i.e. seconds/frame. As with spRes,
                        this data can be pulled from the xml files of the videos that were 
                        analyzed.

        outDir      |   TBD if this is needed, Directory for output of data 

        velDir      |   Directory where velocity data is stored

    Outputs:
        exp         |   A structure that contains all the information for the current experiment

%}
    
    %% Setup basics
        % Add AQuA to path
        addpath(genpath(aqDir))

    %% Add resolutions to exp struct
        exp.res.tRes = tRes
        exp.res.spRes = spRes
    

    %% Read and add features from AQuA data in all aqua output videos in directory
            %{
                All files that end with _aqua.mat in the directory and subdirectorties 
                will be read in. This is why the organization of data before passing is 
                important. The directory should contain related files.
            %}
        
    
        fts = readFts(datDir)
        exp.fts = fts
    
    %% Add burst data to exp struct
        [bursts, burstStats] = detectBurst(fts, spRes, tRes)
        exp.burst.bursts = bursts
        exp.burst.burstStats = burstStats
    
    %% Add sparkle data to exp struct
    
    %% Save exp to file in outDir
        saveFile = strcat(outDir, 'experimentData.mat')
        save(saveFile, 'exp')

end