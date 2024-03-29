
function out = readFts(datDir)

    
    % Removing the line below to keep wd consistent
    %#### cd(datDir);
    
    % Instead, I am having pp search through the datdir and all
    % subfolders to extract the data. The call to `dir([datDir,
    % '**/*.mat'])` should search through all subfolders and find all
    % .mat files. Make sure that the only .mat files in the provided
    % directroy (and subdirectories) are aqua.mat files that you want 
    % to be added to the same struct (they should be analyzed together)
    
    % Note: experimenting with retaining stucture rather than converting to
    % cell array.... -- nevermind 
    

    %% Find all _aqua.mat filesp
        pp = struct2cell(dir([datDir, '**/*_aqua.mat']));
        A = size(pp,2);
    
    %% Read features from all _aqua.mat files
        for kk=1:A
            imgFile = pp{1,kk};
            fName0 = imgFile(1:end-4);
            
            % Changing this pull data from structure rather than from dir as we
            % are no longer chaning directory to folder containing all files,
            % but instead are looking through organized subdirectories to find
            % the files. 
            %#### f0 = [datDir,imgFile];
            f0 = [pp{2,kk}, '/', pp{1,kk}];
            
            % This is checking if the aqua.mat file exits. It
            % doesn't work if you are not changing the cd (removed 
            % above). Also, seems redundant.. file was found by the
            % initial dir search so must exist. Changing f0 (above) 
            % such that this works
    
        
            if ~exist(f0,'file')
                disp(f0);
                disp('File does not exist');
                continue
            end
            
            
            % Print currnt file being read to console
            fprintf('Currently reading in file: %s\n',fName0)

            tmp = load(f0);
            out.dffMat{kk} = tmp.res.dffMat(:,:,1);
            fts = tmp.res.fts;
            out.xSize{kk} = size(tmp.res.datOrg,1);
            out.ySize{kk} = size(tmp.res.datOrg,2);
            out.zSize{kk} = size(tmp.res.datOrg,3);

            out.datNames{kk} = fName0;

            out.propGrow{kk} = fts.propagation.propGrow;
            out.propGrowOverall{kk} = fts.propagation.propGrowOverall;
            out.propSpeedPerFrameDArea{kk} = fts.propagation.areaChangeRate;
            out.propSpeedPerFrame{kk} = fts.propagation.areaChange;

            out.dff{kk} = fts.curve.dffMax;
            out.dffMaxFrame{kk} = fts.curve.dffMaxFrame;
            out.dffRise{kk} = fts.curve.rise19;
            out.dffFall{kk} = fts.curve.fall91;

            out.pixelSizePerFrame{kk} = fts.propagation.areaFrame;
            out.t0{kk} = fts.loc.t0;
            out.t1{kk} = fts.loc.t1;

            out.tBegin{kk} = fts.curve.tBegin;
            out.tEng{kk} = fts.curve.tEnd;

            out.allSize{kk} = fts.basic.area;
            out.duration55{kk} = fts.curve.width55;
            out.duration11{kk} = fts.curve.width11;

            out.loc2D{kk} = fts.loc.x2D;
            out.locAbs{kk} = fts.loc.x3D;
            out.network{kk} = fts.networkAll.occurSameLocList;
            out.networkNumEvts{kk} = fts.networkAll.nOccurSameLoc;

            
        end

end

