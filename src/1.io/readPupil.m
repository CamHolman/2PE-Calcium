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

    %% Read through each CSV and extract data
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
        
        tmp = load(f0);
        pd = tmp.Pupildata;
        %pupils{kk}  = pup0
        

        %% Pull data from each frame
            % Iterate through each frame and add that frames
            % data to the correct org structure, nested in one
            % cell of a cell array within strucure
            % The fist order cell referes to a trial
            % each contained cell referrs to a frame within that 
            % trial
        
        B = length (pd);

        for zz = 1:B
            cframe = pd{zz};
            if isfield(cframe, 'rotated_rect')
                pupils.rotated_rect{kk}{zz} = cframe.rotated_rect;
            end
            
            if isfield(cframe, 'center')
                pupils.center{kk}{zz} = cframe.center;
            end
            
            if isfield(cframe, 'major_r')
                pupils.major_r{kk}{zz} = cframe.major_r;
            end

            if isfield(cframe, 'frame_id')
                pupils.frame_id{kk}{zz} = cframe.frame_id;
            end

            if isfield(cframe, 'frame_intensity')
                pupils.frame_intensity{kk}{zz} = cframe.frame_intensity;
            end

            if isfield(cframe, 'contour')
                pupils.contour{kk}{zz} = cframe.contour;
            end

        end

        %{
                cmh 200213.2
                Note: Will convert major_r within analyze pupil as it needs to be vectorized for 
                interpolation and low pass filter. The others do not need to be and are likely 
                not to be used anyway. Removing this section from readPupil and adding necessary 
                to analyzePupil, i.e just vectorization, interpolation, and low pass of 
                major_r
        
        %% Convert all cell arrays into vectors
            %{
                cmh 200213.1
                With all of the data transferred, it will be in the form of 
                a cell array. This is inconsistent with other data and should be
                converyed to a vector. All empty cells will be replaces with NaNs

                Interpolation and low pass filtering will be within another function
                analyzePupil
            %}
        
        % by iteration
        fn = fieldnames(pupils)
        for jj = 1:numel(fn)
            cur = pupils.(fn{jj}){kk}

            %%%%%%%%%%%%%%%%%%%
            disp('________________tst___________')
            disp(fn)
            disp(jj)

            disp(cur)



            %%%%%%%%%%%%%%%%%%%

            curEmptyIndex = cellfun('isempty', cur)
            cur(curEmptyIndex)={NaN}
            curVec = cell2mat(cur)        
            pupils.(fn{jj}){kk} = curVec
        end
        %}
    end
    
end