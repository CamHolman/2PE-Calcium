%% MATLAB dependencies

% There are several things you'll first need to do before running any of the analysis below.
% 1) Have a 2016b MATLAB or more recent versions installed
% 2) Detected events -- i.e. run your imaging data through the AQuA pipeline.
% 3) Have the following files on your path: dirPlus, detectBurst, readFts2,read_mixed_csv_ForPoskanzerData
% 4) (Optional) I use the colorbrewer color schemes. They can be downloaded here:
% https://www.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab
% otherwise you can change the color arguments to any RGB you want.

%% Defining directories
% You need to add AQuA to your path in order to use its functions
softwareDir = '/path/to/aqua/'; %AQuA path
addpath(genpath(softwareDir));

%  read features from movies and put all the information in one structure called out
datDir = '/path/to/data/'; %input directory where all of your processed movies are (aqua's .mat)
outDir = '/path/to/output/';

spRes = 0.8072; %um/pix
tres = 0.5509; %sec/frame

%% Read features from all movies, store in a structure called out

% you might need to rewrite parts of this function or use your own function
% for reading in the data. When I was doing this analysis, we had AQuA
% writing the output in a strucutre called res. One layer deep was a
% substructure called fts and a layer deeper into fts was substructures like
% propagation, network, etc. The output format has changed a bit
% over time, so this function might be a little outdated. 

out = readFts2(datDir);

%% Detect burst periods 

%this function does a lot, so take from it what you need! most likely the
%mouse running data won't be useful so feel free to comment all those parts
%out (starting with the section 'read in optoswitch data' all the way to
%the end). 
features = out;
[bursts, burstStats] = detectBurst(features, spRes, tres, outDir);

%now that you can index movies based on the burst period, you can do a lot
%of analysis! I'll show an example of just one thing you can do below. 

%% PROPAGATION DIRECTION OVER TIME, single event example
%similar to figure 4c, top right. plot the event and its propagation
%direction over time

clear xLoc3D yLoc3D zLoc3D
for ii = 1:length(out.dff)
    for i = 1:length(out.locAbs{ii})
        aLocs = out.locAbs{ii}{i}; %single event
        [xLoc2D{ii}{i} yLoc2D{ii}{i} zLoc2D{ii}{i}] = (ind2sub([out.xSize{ii} out.ySize{ii} out.zSize{ii}], aLocs));
        xLoc2D{ii}{i} = out.xSize{ii}-xLoc2D{ii}{i};
    end
end

%index a single example event
ii=6; %movie index
j=3;  %burst index
i=44; %event index


plot(yLoc2D{ii}{i},xLoc2D{ii}{i},'s','Color',[0 174/255 239/255]); hold on;
axis([0 out.xSize{ii} 0 out.ySize{ii}])

pIdxG = cell(1,length(bursts));
offsetFr = bursts{ii}(j,2);
pIdxG{ii}{j} = zeros(round(1000),2);
propG = cell2mat(out.propGrow{ii}(i));
propG(isnan(propG))=0;
uTime = unique(zLoc2D{ii}{i});

clear sizeP turnaround taIdx on off timeOn
on = uTime(1);
off = uTime(end);
timeOn = on:1:off;

for jj = 1:size(timeOn,2) %time points of event
    %first column, N/S; second column E/W
    jIdx = timeOn(jj);
    
    northTime = propG(jj,1)-propG(jj,2);
    eastTime = propG(jj,4)-propG(jj,3);
    
    pIdxG{ii}{j}(jIdx,1) = pIdxG{ii}{j}(jIdx,1) + northTime; % (-): south, (+): north
    pIdxG{ii}{j}(jIdx,2) = pIdxG{ii}{j}(jIdx,2) + eastTime; % (-): west, (+): east
end


on = find(pIdxG{ii}{j},1);
off = find(pIdxG{ii}{j}(:,1),1,'last');
N = length(on:off);
C = linspecer(N,'sequential');

colormap(C);colorbar


%location at first frame
ii=6; %movie index
j=3;  %burst index
i=44; %event index

uTimeValues = unique(zLoc2D{ii}{i});
zLocIdx = find(zLoc2D{ii}{i} == uTimeValues(1)); %first frame
k(1) = nanmean(xLoc2D{ii}{i}(zLocIdx));
k(2) = nanmean(yLoc2D{ii}{i}(zLocIdx));

count=0; 
%index variable naming and renaming a bit dumb
kk=6; %movie index
jj=3;  %burst index

for ii = 1:length(timeOn)

    j = timeOn(ii);
    if  nansum(pIdxG{kk}{jj}(j,:)) ~= 0
        iii=ii-count;
        cInd = round(timeOn - bursts{kk}(jj,1));
        color = C(iii,:);
        plot([k(2) k(2)+pIdxG{kk}{jj}(j,2)],[k(1) k(1)+pIdxG{kk}{jj}(j,1)],'-','LineWidth',2,'Color',color);
        hold on;
        k = [k(1)+pIdxG{kk}{jj}(j,1) k(2)+pIdxG{kk}{jj}(j,2)];
        
        if pIdxG{kk}{jj}(j,2) > 0
            marker = '>';
        elseif pIdxG{kk}{jj}(j,2) < 0
            marker = '<';
        else
            marker = 'o';
        end
        
        if pIdxG{kk}{jj}(j,1) > 0 && pIdxG{kk}{jj}(j,1) > pIdxG{kk}{jj}(j,2)
            marker = '^';
        elseif pIdxG{kk}{jj}(j,1) < 0
            marker = 'v';
        else
            marker = 'o';
        end
        
        axis([0 out.xSize{kk} 0 out.ySize{kk}]); hold on;
        plot(k(2), k(1), 'Marker',marker,'Color',color,'MarkerSize',5,'LineWidth',jj);
    else
        count=count+1;
    end
end


title('posterior')
xlabel('anterior')
ylabel('lateral')
colormap(C);
c=colorbar;
c.Ticks = [1/length(timeOn):1/length(timeOn):1];
for i = 1:length(timeOn)
    j = timeOn(i);
    ar(i) = {num2str(j)};
end
c.TickLabels = ar;
ylabel(c,'medial')
set(gca,'fontsize',18)