function pupils = readPupil(datDir)
    %{
        This function is similar to readFts, except that it is designed for reading
        in pupil data. The fundamental use case is reading pupil data in order to 
        build correlations between AQuA data and pupil diameter.  
    
        This is designes to seach for files that end with: 
                    
                    'pupilData.mat'

        As is output by the pupilometery repository 
    
        Inputs:
            datDir      |   Directory containing all related pupilData.mat files. There should
                            be one file per trial (there can be both a .csv and a .paq file
                            but there should not be multiple of each type per trial. All trials 
                            should be related to the AQuA files being read in such that their 
                            indicies correlate in the buildMouse function ant others 
    
                            The organization of this directory is important 
                            and should follow the outline below:
                                > Mouse 
                                |   > Trial 1 
                                |   |   > AQuA output folder
                                |   |   |   - _aqua.mat
                                |   |   |   - _aqua_landmark.png
                                |   |   |   - _aqua.tif
                                |   |   |   - _aqua.xlsx
                                |   |   |
                                |   |   - ephys.paq and/or ephys.csv
                                |   |   - other trial data (pupil, etc) 
                                |   |
                                |   > Trial 2
                                |   |   > AQuA output folder
                                ...
    
                            datDir should refer to 'Mouse', i.e.:
                                '/path/to/mouse/'
    
                eType       |   A string that indicates whether you want to read in ephys or opto data from 
                            a .paq or .csv file. You should enter either:
                                'paq'
                                'csv'
        
    %} 
    
        % Set up base struct
        %pupils = struct()
    
        %% Read in pupilData.mat files =
        pp = struct2cell(dir([datDir, '**/*pupilData.mat']));
        A = size(pp,2);

        % Read through each CSV
        for kk = 1:A
            eFile = pp{1,kk};
            fName0 = eFile(1:end-4);
            f0 = [pp{2,kk}, '/', pp{1,kk}];

            if ~exist(f0,'file')
                disp(f0);
                disp('File does not exist');
                continue
            end
            
            fprintf('Currently reading in csv file: %s\n',fName0)
            
            pup0 = load(f0)
            pupils{kk}  = pup0

        end
        
    end