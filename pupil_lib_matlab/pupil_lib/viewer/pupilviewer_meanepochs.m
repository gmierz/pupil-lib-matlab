function [fig] = pupilviewer_meanepochs(PUPIL, trial_range, trial_time, epoch_size)
%PUPILVIEWER_MEANEPOCHS Means all epochs and displays them.
%   This function can be used to display every epoched trigger in one
%   figure.
%   INPUT
%       trial_range      -  The range across which the epochs span.
%       trial_time       -  The time that the trial spans.
%       epoch_size       -  The size of each of the epochs.
%   OUTPUT
%       fig              -  A handle to the resulting figure.
    baseline = trial_range(1);
    total_time = trial_range(2) - trial_range(1);
    trig_size = size(PUPIL.eye0.epochs, 2);
    
    fig = figure; hold on;    
     
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,1}.epochmat_pc(:,:),1)),'b');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,2}.epochmat_pc(:,:),1)),'r');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,3}.epochmat_pc(:,:),1)),'g');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye0.epochs{1,4}.epochmat_pc(:,:),1)),'black');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,1}.epochmat_pc,1)),'b--'); hold on;
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,2}.epochmat_pc,1)),'r--');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,3}.epochmat_pc,1)),'g--');
    plot([(baseline*1000):((total_time*1000)/199):(trial_range(2)*1000)],squeeze(mean(PUPIL.eye1.epochs{1,4}.epochmat_pc,1)),'black--');
    vline(trial_range(1)*1000, 'r');
    vline(trial_time*1000, 'r');
    xlim([trial_range(1)*1000 trial_range(2)*1000]);
    
    mean_trials = 0;
    for i = 1:size(PUPIL.eye0.epochs, 2)
        
    end
    
    title(['Subject #2,' int2str(mean(size(PUPIL.eye0.epochs{1,2}.epochmat_pc(:,:),1))) ' trials, Dashed - right, Solid - left. Total time = 2.5s']);
    xlabel('Time');
    ylabel('Percent Change');
end

