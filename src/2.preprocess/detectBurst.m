
function [bursts, burstStats] = detectBurst(out, spRes, tres, outDir)
A = length(out.datNames);
clear bursts burstStats

for jj = 1:A
    frames = out.zSize{jj};
    xSize = out.xSize{jj};
    ySize = out.ySize{jj};
    zSize = frames;
    
    
    clear aLocs aLocsB xLocs yLocs tLocs
    for i = 1:length(out.locAbs{jj})
        absLocsB = out.locAbs{jj};
        aLocs = absLocsB{i}; %single event
        [xLocs{i} yLocs{i} tLocs{i}] = (ind2sub([xSize ySize zSize], aLocs));
        xLocs{i} = xSize-xLocs{i};
    end
    
    curveBW = zeros(length(tLocs),frames);
    sizeT = zeros(length(tLocs),frames);
    
    %number of onsets per frame
    clear growthT
    growthT = zeros(length(tLocs),frames);
    for i = 1:length(tLocs) %#events
        clear uT %uT is always 2 frames shorter than fts.propGrow
        uT = unique(tLocs{i}); %time points of an event
        if ~isempty(uT)
            minuT = min(uT); %just the first frame of an event
            curveBW(i,minuT) = 1;
            
            k=1;
            
            %{
            Note: the for loop below is going past the lenght of uT by 1
            and throwing an error. I.e. uT has 12 elements, the list is
            trying to iterate to j=13 and throwing an error as is is out of
            bounds
            
            Question for Nicole, why `length+1` here? This is common for
            langs that index from 0 but is this common in MATLAB with
            idexing from 1? 
            %}
            
            
            %{            
            for j = 2:length(uT)+1
                
                disp(' ')
                disp('Current things')
                disp('uT is:')
                disp(uT)
                disp(['Length of uT is ', num2str(length(uT)+1)]) 
                disp(' ')
                disp(['jj is ', num2str(jj)])
                disp(['i is ', num2str(i)])
                disp(['j is ', num2str(j)])
            
            
            ### Rewriting this below without the +1 for length
            %}
            for j =2:length(uT)
                if nansum(out.propGrow{jj}{i}(j,:)) == 0
                    growthT(i,uT(k)) = 0;
                else
                    growthT(i,uT(k)) = nansum(out.propGrow{jj}{i}(j,:));
                end
                k=k+1;
            end
        end
    end
    
    numEvts = sum(curveBW,1);
    burstStats.numEvts{jj} = numEvts;
    growthEvts = sum(growthT,1);
    X = growthEvts(growthEvts > 0)';
    
    
    f = figure(jj);
    screen_size = get(0, 'ScreenSize');
    set(f, 'Position', ...
        [screen_size(3)/20 ...
        screen_size(4)/20 ...
        screen_size(3)*9/10 ...
        screen_size(4)*8.5/10]);
    
    
    %area with event activity
    clear allEvtLocs uLocs
    allEvtLocs = cell2mat(out.loc2D{jj}');
    uLocs = unique(allEvtLocs);
    
    numPix = length(uLocs); %number of pixels where an event occupied
    sizeT = zeros(length(tLocs),frames);
    
    for i = 1:length(tLocs)
        clear uT
        uT = unique(tLocs{i});
        
        %%%%%%%%%%
        %disp('uT is:')
        %disp(uT)
        %%%%%%%%%%%
        
        
        if ~isempty(uT)
            
            
            %%%%%%%%
            disp('here4')
            %%%%%%%%
            
            if length((out.pixelSizePerFrame{jj}{i}(2:end-1,1))) == length(uT)
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % THIS IS WHERE THE ISSUE IS --- above does not eval to
                % true so data doesnt move forward, sizeT stays == zeors 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %%%%%%%%
                disp('here5')
                %%%%%%%%
                
                sizeT(i,uT) = ((out.pixelSizePerFrame{jj}{i}(2:end-1,1)) / (spRes^2));
                
            end
        end
    end
    
    %%%%%%%%%%%%%
    disp('sizeT is:')
    disp(size(sizeT))
    % disp(sizeT)
    %%%%%%%%%%%%%
    
    
    sizeEvts = sum(sizeT,1);
    percEvts = (sizeEvts ./ numPix) * 100;
    burstStats.percEvts{jj} = percEvts;
    
    
    %%%%%%%%%%%
    disp('sizeEvts are:')
    disp(sizeEvts)
    
    disp("percEvts are:")
    disp(percEvts)
    
    %%%%%%%%%%%
    
    
    
    
    
    %find burst periods: >1% %FOV, >25 frames apart, >25% max #events 
    thr = 1;
    [xPeaks,maxPkTimes] = findpeaks(percEvts,'MinPeakHeight',thr,'MinPeakDistance',25);
    
    pp = zeros(numel(xPeaks),2);  % 10%, 90% by start/end
    thrVec = [0.1];
    
    %%%%%%%%%%%%%%
    disp ('here1')
    disp('xPeaks is')
    disp(xPeaks)
    
    disp(['Num elements in xPeaks is ' num2str(numel(xPeaks))])
    disp('____________')
    %%%%%%%%%%%%%%%%%
    
    
    for n = 1:numel(xPeaks)
        win = maxPkTimes(n)-20:1:maxPkTimes(n)+5;
        
        disp('here2')
        
        
        if sum(numEvts(win) > (max(numEvts)*0.10)) > 0 %burst needs to have more than 10% of number of events
            
            disp('Burst detected');
            
            
            ix = find(percEvts<xPeaks(n)*thrVec(1));
            ixPre = max(ix(ix<=maxPkTimes(n)));
            ixPost = min(ix(ix>=maxPkTimes(n)));
            
            bursts{jj}(n,1) = ixPre; %frame when burst rose 10%
            bursts{jj}(n,2) = ixPost;
            
            bursts2{jj}(n,1) = ixPre-15; %frame when burst at max
            bursts2{jj}(n,2) = maxPkTimes(n);
        end
    end
   
    lst=0;
    for i = 1:length(bursts{jj})
        if (bursts{jj}(i,2) <= (bursts{jj}(i,1)))
            lst=i;
        end
    end
    if lst > 0
        bursts{jj}(lst,:) = [];
    end
    
    
    twindow = 1/tres;
    
    clear enumEvts
    j=1;
    for i=1:twindow:length(burstStats.numEvts{jj})-twindow
        enumEvts(j) = sum(burstStats.numEvts{jj}(i:i+twindow));
        j=j+1;
    end
    
    burstStats.snumEvts{jj} = enumEvts;
    
    subplot(5,1,1)
    plot(enumEvts,'Color','k','LineWidth',3); hold on;
    xlabel('sec.')
    ylabel('number of event onsets')
    set(gca,'fontsize',18)
    box off
    axis([0 length(enumEvts) 0 max(enumEvts)+25])
    
    
    
    %area with event activity
    clear allEvtLocs uLocs
    allEvtLocs = cell2mat(out.loc2D{jj}');
    uLocs = unique(allEvtLocs);
    
    numPix = length(uLocs); %number of pixels where an event occupied
    
    
    clear epercEvts
    j=1;
    for i=1:twindow:length(burstStats.percEvts{jj})-twindow
        epercEvts(j) = mean(burstStats.percEvts{jj}(i:i+twindow));
        j=j+1;
    end
    
    burstStats.spercEvts{jj} = epercEvts;
    
    N=9;
    C = linspecer(N,'qualitative');
    subplot(5,1,2)
    for i = 1:size(bursts{jj},1)
        rectangle('Position',[bursts{jj}(i,1)*tres 0 (bursts{jj}(i,2)-bursts{jj}(i,1))*tres 100],'FaceColor',[0.9718 0.5553 0.7741],'EdgeColor','none'); hold on;
    end
    %line(1:length(epercEvts), repmat(thr,length(epercEvts)),'LineStyle',':','Color','r','MarkerSize',10,'LineWidth',2); hold on;
    plot(epercEvts,'Color','k','LineWidth',3); hold on;
    xlabel('time (sec)')
    ylabel('% FOV')
    axis([0 length(epercEvts) 0 100])
    set(gca,'fontsize',18)
    box off
    
    
    
    
    burstStats.sizes{jj}(i) = out.allSize{jj}(i);
    
    
    thrS = 50;
    
    sparkleT = zeros(length(tLocs),frames);
    countS=0;
    burstT = zeros(length(tLocs),frames);
    countB=0;
    for i = 1:length(tLocs)
        clear uT
        uT = unique(tLocs{i});
        if ~isempty(uT)
            if length((out.pixelSizePerFrame{jj}{i}(2:end-1,4))) == length(uT)
                if out.allSize{jj}(i) <= thrS %small
                    %sparkleT(i,uT) = ((out.pixelSizePerFrame{jj}{i}(2:end-1,4)));
                    sparkleT(i,uT) = countS+1;
                    sparkleS(i,uT) = out.allSize{jj}(i);
                elseif out.allSize{jj}(i) > thrS %large
                    %burstT(i,uT) = ((out.pixelSizePerFrame{jj}{i}(2:end-1,4)));
                    burstT(i,uT) = countB+1;
                    burstS(i,uT) = out.allSize{jj}(i);
                end
            end
        end
    end
    
    spEvts = sum(sparkleT,1);
    brEvts = sum(burstT,1);
    sparkleS = sum(sparkleS,1);
    burstS = sum(burstS,1);
    %percEvts = (sizeEvts ./ numPix) * 100;
    burstStats.spEvts{jj} = spEvts;
    burstStats.brEvts{jj} = brEvts;
    
    burstStats.spSize{jj} = sparkleS;
    burstStats.brSize{jj} = burstS;
    
    
    
    
  
    %% read in optoswitch data
    clear filename
    cd '/path/to/data/'
    
    filename = ['/path/to/data/' out.datNames{jj} '.csv'];
    dirFile = dir(filename);
   
    if length(dirFile) == 1 % if no filename specified, just take the first .csv
        [opto] = read_mixed_csv_ForPoskanzerData(filename);
    end
    
   
    %% velocity
    % Define Wheel Statistics
    Radius  = 11.06; %radus in cm
    noftabs = 30; %number of tabs
    circumference = 2*pi*Radius;
    distpertab =circumference/(2*noftabs); %distance per tab (tabs are evenly spaced and the wheel is split equally)
    samplerate = 1000; %aquisition rate
    twindow = samplerate; %window in miliseconds
    
    %Look at derivative of wheel trace
    diffSC = diff(opto); %derivative of the square pulses
    figure; plot(1:1:length(opto)-1,diffSC) %plot
    
    %define likely break points and binarize
    triggerframes = find(abs(diffSC)>=mean(diffSC)+std(diffSC)); %find where there was probably a change from blocked to open
    tabtransittimes = zeros(1,length(opto)); %make an empty matrix
    tabtransittimes(triggerframes)= 1; %binarize the transitions
    
    %sum transitions over the window
    j=1;
    for i=1:twindow:length(opto)-twindow
        numbreaks(j) = sum(tabtransittimes(i:i+twindow));
        j=j+1;
    end
    
    velocity = numbreaks * distpertab; %gives approximate velocity at ege of wheel
    burstStats.velocity{jj} = velocity;
    
    figure(jj); hold on;
    subplot(5,1,3); hold on;
    plot(1:length(numbreaks),velocity, 'LineWidth',2,'Color','k')
    ylabel('wheel velocity')
    xlabel('time (sec)')
    set(gca,'FontSize',18)
    axis([0 length(epercEvts) 0 max(velocity)+5])
    

end


end