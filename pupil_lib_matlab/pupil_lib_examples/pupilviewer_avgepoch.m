% Get an epoched dataset from a directory and display each averaged
% epoched.
PUPIL = pupil_load('C:\Users\Gregory\Documents\Honors_Thesis\2017_03_07\002');
PUPIL = pupil_epoch(PUPIL, {'S11', 'S12', 'S13', 'S14'}, [0.1 5]);

figure; plot(squeeze(mean(PUPIL.eye0.epochs{1,1}.epochmat,1)),'b');
hold on;
plot(squeeze(mean(PUPIL.eye0.epochs{1,2}.epochmat,1)),'r');
plot(squeeze(mean(PUPIL.eye0.epochs{1,3}.epochmat,1)),'g');
plot(squeeze(mean(PUPIL.eye0.epochs{1,4}.epochmat,1)),'black');
plot(squeeze(mean(PUPIL.eye1.epochs{1,1}.epochmat,1)),'b--');
plot(squeeze(mean(PUPIL.eye1.epochs{1,2}.epochmat,1)),'r--');
plot(squeeze(mean(PUPIL.eye1.epochs{1,3}.epochmat,1)),'g--');
plot(squeeze(mean(PUPIL.eye1.epochs{1,4}.epochmat,1)),'black--');
title('Percent change, baseline corrected - (TaskVal - RestMean)/RestMean');
xlabel('Time');
ylabel('Percent Change');
legend('Stim. 1', 'Stim. 2', 'Stim. 3', 'Stim. 4');

% Check pupil timestamp distances
tmp_ev = PUPIL003.eye1.timestamps(2:2:end);
tmp_od = PUPIL003.eye1.timestamps(1:2:end);
tmp_sub = tmp_ev-tmp_od(1:(length(tmp_od)-1),1);
figure, plot(tmp_sub,'g'); title('Erratic sampling - eye 0, eye 1 overlay');

tmp_ev = PUPIL003.eye0.timestamps(2:2:end);
tmp_od = PUPIL003.eye0.timestamps(1:2:end);
tmp_sub = tmp_ev-tmp_od(1:(length(tmp_od-1)),1);
hold on; plot(tmp_sub, 'b');
legend('Eye 0', 'Eye 1');