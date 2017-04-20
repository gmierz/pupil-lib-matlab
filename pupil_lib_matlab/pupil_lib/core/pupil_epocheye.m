function epochs = pupil_epocheye(pupil_data, pupil_times, srate, proc_mtimes, trial_range)
%PUPIL_EPOCHEYE Used to epoch the data from a single eye.
% This function is the beginning of the processing for extracting epochs
% from a given eye's dataset. It uses #pupil_cutout# to extract a dataset
% given a index that this function finds.
%   INPUT:
%       pupil_data   -  Data from an eye that will be epoched
%       pupil_times  -  Timestamps to use for epoching.
%       srate        -  Sampling rate of the data for approximation.
%       proc_mtimes  -  The processed marker times that are used to
%                       find epochs.
%       trial_range  -  The range over which the trial spans, centered at 0
%                       given any trial range.
%   RETURN:
%       epochs       -  The cell array containing all the epochs that were
%                       found.
%
% Author: Gregory Mierzwinski, Sherbrooke, QC, 03/19/2017
%

% Copyright (C) Gregory Mierzwinski, gmierz1@live.ca
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    % Init
    num_marks = 1;
    pupil_count = 1;
    ep_count = 1;
    epochs = cell(length(proc_mtimes),1);
    curr_ts = pupil_times(pupil_count);
    fin_ts = proc_mtimes(length(proc_mtimes));
    
    % These hold debugging information
    inds_bases = [];
    inds_trials = [];
    indst_bases = [];
    indst_trials = [];
    
    % While the current pupil data timestamp is less than the timestamp
    % of the final marker.
    while curr_ts < fin_ts
        % Get a markers timestamp
        ts_mark = proc_mtimes(num_marks);

        % Find the closest timestamps in the pupil data
        while curr_ts < ts_mark && pupil_count <= length(pupil_data)
            pupil_count = pupil_count + 1;
            curr_ts = pupil_times(pupil_count);
        end

        % Get error
        prev_ts = pupil_times(pupil_count-1);
        error_prev = abs(ts_mark-prev_ts);
        error_curr = abs(ts_mark-curr_ts);

        % Get epoch data index
        using_ind = 1;
        if error_prev < error_curr % pick prev over curr
            using_ind = pupil_count-1;
        elseif error_prev > error_curr % curr_ts has less error
            using_ind = pupil_count;
        else % No difference, pick the current error
            using_ind = pupil_count;
        end

        % Get epoch
        [epoch, ind_base, ind_trial] = pupil_cutout(pupil_data, pupil_times, srate, using_ind, trial_range);
        
        % Save some debugging information.
        inds_bases(num_marks) = ind_base;
        inds_trials(num_marks) = ind_trial;
        indst_bases(num_marks) = pupil_times(using_ind) - pupil_times(using_ind-ind_base);
        indst_trials(num_marks) = pupil_times(using_ind+ind_trial) - pupil_times(using_ind);
        
        % Save
        epochs{ep_count} = epoch;
        ep_count = ep_count + 1;

        % Go to next marker
        num_marks = num_marks + 1;
    end % end while
    
    % Display some debugging information.
    display('Inds:');
    display(mean(inds_bases));
    display(mean(inds_trials));
    display(mean(indst_bases));
    display(mean(indst_trials));
end