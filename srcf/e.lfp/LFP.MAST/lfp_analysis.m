% load the data
%LFP = load('C:\Users\Trisha\Desktop\Data\122016 EMG mouse2\VoltageRecording-12172016-1959-005\VoltageRecording-12172016-1959-005_Cycle00001_VoltageRecording_001.csv');

%Data matrix needs to be called LFP

%downsample
data = LFP(1:length(LFP),2);
% data = LFP(6600000:7200000,2);
 
% setting parameters
params.Fs = 1000;
params.fpass = [0 100];
params.pad = 5;
TW = 3; % the time-bandwidth product %02-13-17 changed from 2.5 to 3
K = 4; % the number of tapers - K = 2*TW -– 1 %02-13-17 changed from 3 to 4
params.tapers = [TW K]; 

% frequency spectrum
[S,f] = mtspectrumc(data,params);
figure; plot_vector(S,f); ('Raw data spectrum');
%figure; plot_vector(S,f,'n'); %linear scale

% removing 60 Hz
alpha = 0.999; 
omega = 2*pi*60/params.Fs; 
num = [1 -2*cos(omega) 1];
den = [1 -2*alpha*cos(omega) alpha*alpha];
datano60 = filter(num,den,data);
[S,f] = mtspectrumc(datano60,params);
figure; plot_vector(S,f); title('Spectrum after 60 Hz notch');

% compute spectogram
movingwin = [5 .5]; % Larger window sizes = more frequency bands. Larger step sizes, more blurring > used to use [10 .5], better would be [20 1]
[S1,t,f] = mtspecgramc(data,movingwin,params);
[S2,t,f] = mtspecgramc(datano60,movingwin,params);
   
figure;
subplot(2,1,1);plot_matrix(S1,t,f);
xlabel('seconds'); ylabel('Frequency Hz'); title('before notch');ylim([0 100]);
subplot(2,1,2);plot_matrix(S2,t,f);
xlabel('seconds'); ylabel('Frequency Hz'); colorbar; colormap jet; title('after notch');ylim([0 100]); caxis('auto');

figure;
subplot(2,1,1);plot_matrix(S1,t,f);
xlabel('seconds'); ylabel('Frequency Hz'); title('before notch');ylim([0 10]);
subplot(2,1,2);plot_matrix(S2,t,f);
xlabel('seconds'); ylabel('Frequency Hz'); colorbar; colormap jet; title('after notch');ylim([0 10]); caxis('auto');



figure;
plot_matrix(S2,t,f);
xlabel('seconds'); ylabel('Frequency Hz'); colormap jet; colorbar; title('up to 20 hz');ylim([0 20]);

%{
%1278 to 1288
start = 1 ; %start and end of time to display in seconds
last = 3600;

[~,start] = min(abs(t-start)); %find index of t that contains the time closest to 'start' and 'last'
[~,last] = min(abs(t-last)); 

figure;
ha(1) = subplot(3,1,1); plot(LFP(t(start)*1000:t(last)*1000,1)/1000, data(t(start)*1000:t(last)*1000)); colormap jet; colorbar; title('02-17-17 c2776717');
xlabel('seconds'); ylabel('Volt');
ha(2) = subplot(3,1,2);plot_matrix(S2(start:last,:),t(start:last),f);
xlabel('seconds'); ylabel('Frequency Hz');ylim([0 100]);
ha(3) = subplot(3,1,3);plot_matrix(S2(start:last,:),t(start:last),f);
xlabel('seconds'); ylabel('Frequency Hz'); title('after notch');ylim([0 20]); caxis([-80 0]);
linkaxes(ha, 'x');

%1278 to 1288
start = 1278 ; %start and end of time to display in seconds
last = 1288;

[~,start] = min(abs(t-start)); %find index of t that contains the time closest to 'start' and 'last'
[~,last] = min(abs(t-last)); 

figure;
ha(1) = subplot(2,1,1); plot(LFP(t(start)*1000:t(last)*1000,1)/1000, data(t(start)*1000:t(last)*1000)); colormap jet; colorbar; title('02-17-17 c2776717');
xlabel('seconds'); ylabel('Volt');
ha(2) = subplot(2,1,2);plot_matrix(S2(start:last,:),t(start:last),f);
xlabel('seconds'); ylabel('Frequency Hz');ylim([0 20]);
linkaxes(ha, 'x');




start = 530;
last = 550;
[~,start] = min(abs(t-start));
[~,last] = min(abs(t-last)); 
figure;
ha(1) = subplot(3,1,1); plot(LFP(t(start)*1000:t(last)*1000,1)/1000, data(t(start)*1000:t(last)*1000)); ylim([-.75 -.55]); title('02-16-17 c2776717');
xlabel('ms'); ylabel('Volt');
ha(2) = subplot(3,1,2);plot_matrix(S2(start:last,:),t(start:last),f);
xlabel('seconds'); ylabel('Frequency Hz'); ;ylim([0 100]);
ha(3) = subplot(3,1,3);plot_matrix(S2(start:last,:),t(start:last),f);
xlabel('seconds'); ylabel('Frequency Hz'); colorbar; colormap jet; ylim([0 10]); caxis;
linkaxes(ha, 'x');

%}

% figure;
% subplot(2,1,1);plot_matrix(S2,t,f);
% xlabel('seconds'); ylabel('Frequency Hz'); colorbar; colormap jet; title('after notch');ylim([0 20]); caxis([:]);
% subplot(2,1,2);
% plot(data)
% xlabel('seconds'); ylabel('Frequency Hz'); title('before notch');
% 
% figure;
% subplot(2,1,1);
% plot_matrix(S2,t,f);
% subplot(2,1,2);
% plot(times,data)



%compute coherence
% params.err = [1 0.05];
% data1 = datano60(1:10000);
% data2 = datano60(20000:30000);
% [C,phi,S12,S1,S2,f] = coherencycpt(data1,data2,params);
% C - the magnitude of the coherency
% phi - the phase of the coherency;
% S1 and S2 - the spectra for the two signals
% f, the frequency grid used for the calculations;

% figure;plot(f,C);





