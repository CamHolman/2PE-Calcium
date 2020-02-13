function mouse = buildPupil(aqDir, datDir, spRes, tRes, eType, outDir)
    %{
    The purpose of this function is to act as a master to build a mouse with pupil
    structure from AQuA output and velocity data. This differes from buildExperiment 
    in that it is designed to include velocity data recorded on a photoswitch. This
    differes from buildMouse in that it adds Pupilometry to the data structure.
    
    This structure will contain all of the the relevant information for the mouse 
    including spatial and temporal resolutions, bursts timings, burstStats, 
    sparkle stats, velocity data, perhaps LFP data...  

    This will allow ploitting functions to work by only passing one argument after 
    setup as well as having general organizational benefits. 

    Futher, this function will be used by higher level functions that build experiments 
    designed to compare velocity and pupil data with AQuA data

    All of the data passed to this funtion should be related. I.e. it should represent one 
    mouse and all of its AQuA videos. If you are working with slices, it should contain all
    AQuA videos that were extracted from related slices (by genotype, etc)

    Inputs:
        aqDir       |   The directory in which your AQuA repository exists
        
        datDir      |   The directory where your data is stored. The data in this directory
                        should be related, i.e. it should all be from one mouse or one set
                        of slice experiments. The organization of this directory is important 
                        and should follow the outline below:
                            > Mouse 
                            |   > Trial 1 
                            |   |   > AQuA output folder
                            |   |   |   - _aqua.mat
                            |   |   |   - _aqua_landmark.png
                            |   |   |   - _aqua.tif
                            |   |   |   - _aqua.xlsx
                            |   |   |
                            |   |   - velocity.csv
                            |   |   - pupil.mat
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
        mouse       |   A structure that contains all the information for the current mouse

%}

    %% Extract AQuA data
        %{
            This will extract all AQuA data from all trials within the mouse folder and 
            pass them to the mouse structure. See buildExperiment for details
        %}
        
        mouseP = buildMouse(aqDir, datDir, spRes, tRes, outDir)

    %% Extract Pupil Data

    %% Add Pupil Data

    %% ADD SAVE OUTPUT TO OUTDIR HERE 

    
end 