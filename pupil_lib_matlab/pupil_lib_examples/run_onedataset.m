% Directories
dirs = {'G:\greg\recordings\2017_03_17\003', ...
        'G:\greg\recordings\2017_03_17\004', ...
        'G:\greg\recordings\2017_03_17\005', ...
        'G:\greg\recordings\2017_03_17\007'};

% Time of trials
trial_range = [-1 18.5];
trial_time = 18;
baseline = trial_range(1);
total_time = trial_range(2) - trial_range(1);
baseline_ind = (abs(baseline)/total_time)*200;
trial_ind = (trial_time/total_time)*200;

% Merge datasets
merge_pupil = pupil_load(dirs{1});
merge_pupil = pupil_epoch(merge_pupil, {'S10', 'S20', 'S30', 'S40'}, trial_range, 'baseline', 1, 'erratic', 0.15, 'epochsize', 200);
for i = 2:length(dirs)
    tmp = pupil_load(dirs{i});
    tmp = pupil_epoch(tmp, {'S10', 'S20', 'S30', 'S40'}, trial_range, 'baseline', 1, 'erratic', 0.5);
    
    % Smooth
    if i == 2
        tmp.eye0 = pupil_filt(tmp.eye0, 4, {'S11','S12','S13','S14'}, 'median');
        tmp.eye0 = pupil_filt(tmp.eye0, 4, {'S11','S12','S13','S14'}, 'average');
    end
    
    merge_pupil = pupil_mergesets(merge_pupil, tmp);
end

PUPIL = merge_pupil;

% Plot
PUPIL.eye0 = pupil_filt(PUPIL.eye0, 4, {'S10','S20','S30','S40'}, 'average');
PUPIL.eye1 = pupil_filt(PUPIL.eye1, 4, {'S10','S20','S30','S40'}, 'average');
figure; plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,1}.epochmat_pc(:,:),1)),'b');
hold on;
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,2}.epochmat_pc(:,:),1)),'r');
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,3}.epochmat_pc(:,:),1)),'g');
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,4}.epochmat_pc(:,:),1)),'black');
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,1}.epochmat_pc,1)),'b--'); hold on;
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,2}.epochmat_pc,1)),'r--');
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,3}.epochmat_pc,1)),'g--');
plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,4}.epochmat_pc,1)),'black--');

xlim([-1000 18500]);
title(['Subject,' int2str(size(PUPIL.eye0.epochs{1,2}.epochmat_pc(:,:),1)) ' trials, Dashed - right, Solid - left.']);
xlabel('Time');
ylabel('Percent Change');