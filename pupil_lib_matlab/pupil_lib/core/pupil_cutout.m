function [data_seg, num_basepoints, num_trialpoints] = pupil_cutout(pupil_data, pupil_ts, srate, center_ind, trial_range)
%PUPIL_CUTOUT Cuts out an epoch from a given dataset.
% This function can be used to cut out a section of data - a trial -
% from the raw data. It is used in the function call #pupil_epocheye# and
% also uses a linear approximator to achieve 0 error in epoch length.
%
%   INPUT:
%       pupil_data      -  The raw pupil data for one eye.
%       pupil_ts        -  The timestamps for one eye's raw data.
%       srate           -  Sampling rate of the given data.
%       center_ind      -  Marker index used to center cut.
%       trial_range     -  Trial range to cut out.
%   RETURN:
%       data_seg        -  The epoch that was found at this position. It has
%                          two fields, 'data' which has the data, and 'times'
%                          which contains the timestamps.
%       num_basepoints  -  The number of points to the start of the epoch
%                          from the 'center_ind' mark.
%       num_trialpoints -  The number of points to the end of the epoch
%                          from the 'center_ind' mark.
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
    negative = 0; 
    baseline = 0;
    end_time = 0;

    % Get trial and baseline times and ranges.
    if length(trial_range) == 2
        baseline = trial_range(1);
        % Set a flag if a baseline will be cutout also.
        if baseline < 0
           negative = 1; 
        end

        end_time = trial_range(2);
    else
        end_time = trial_range(1);
    end
    
    % Check trial time
    if end_time < 0
        %{
            TODO: Add negative trial times. To cirvumvent this issue,
            move the event markers by a number of seconds.
        %}
        error('Trial time cannot be negative. (Feature in progress).');
    elseif end_time < baseline
        error('Trial end time must be greater than the baseline time');
    end
    
    % Get a rough estimate of where the base point should be based on the
    % sampling rate.
    abs_baseline = (abs(baseline));
    
    num_basepoints = int32(abs_baseline * srate);
    num_trialpoints = int32(end_time * srate);
    
    if negative == 1 % If we have a baseline
        % Check times
        display('Before:');
        display('Time baseline:');
        tmp1 = pupil_ts(center_ind) - pupil_ts(center_ind-num_basepoints);
        display(tmp1);
        display('Time trial:');
        tmp2 = pupil_ts(center_ind+num_trialpoints) - pupil_ts(center_ind);
        display(pupil_ts(center_ind+num_trialpoints) - pupil_ts(center_ind));
        display('Total time:');
 
        display(tmp1+tmp2);
        
        [pupil_bts_final, zero_errb, ind_base, base_ind1, base_ind2, error_fin_base] = ...
            getlefttime(pupil_ts, center_ind, num_basepoints, tmp1, baseline);
        % Used in approximation
        newtime_base = pupil_ts(center_ind) - pupil_bts_final;
        
        [pupil_tts_final, zero_errt, ind_trial, trial_ind1, trial_ind2, error_fin_trial] = ...
            getrighttime(pupil_ts, center_ind, num_trialpoints, tmp2, end_time);
        % Save variable for approximation
        newtime_trial = pupil_tts_final - pupil_ts(center_ind);
        
        % Display difference between previsou and current lengths.
        display('After:');
        display('Time baseline:');
        
        tmp1 = pupil_ts(center_ind) - pupil_ts(center_ind-ind_base);
        display(pupil_ts(center_ind) - pupil_ts(center_ind-ind_base));
        display('Time trial:');
        tmp2 = pupil_ts(center_ind+ind_trial) - pupil_ts(center_ind);
        display(pupil_ts(center_ind+ind_trial) - pupil_ts(center_ind));
        
        display('Total time:');
        display(tmp1+tmp2);
        
        % Find linear approximation to the exact point. This makes the
        % epoch lengths exact with a simple linear approximation.
        % First, do the baseline side.
        if zero_errb == 0
            [val_out_base, ts_out] = linear_approx(pupil_data(center_ind - base_ind1), ...
                                              pupil_ts(center_ind - base_ind1), ...
                                              pupil_data(center_ind - base_ind2), ...
                                              pupil_ts(center_ind - base_ind2), ...
                                              pupil_bts_final);
        else
            val_out_base = pupil_data(center_ind-ind_base);
        end
        % Now do the trial side.  
        if zero_errt == 0
            [val_out_trial, ts_out] = linear_approx(pupil_data(center_ind + trial_ind1), ...
                                              pupil_ts(center_ind + trial_ind1), ...
                                              pupil_data(center_ind + trial_ind2), ...
                                              pupil_ts(center_ind + trial_ind2), ...
                                              pupil_tts_final);
        else
            val_out_trial = pupil_data(center_ind+ind_trial);
        end

        % Display the approximation and what was changed.
        display('Approximation visualization: ');
        display(['Previous base: ' sprintf('%.10f',pupil_data(center_ind-ind_base))]);
        display(['Next base: ' sprintf('%.10f',val_out_base)]);
        display(['Previous trial: ' sprintf('%.10f',pupil_data(center_ind+ind_trial))]);
        display(['Next trial: ' sprintf('%.10f',val_out_trial)]);
        
        display(['New time base: ' sprintf('%.20f', newtime_base)]);
        display(['New time trial: ' sprintf('%.20f', newtime_trial)]);
        
        % Get the epoch from the data set.
        data_seg.data = pupil_data((center_ind - ind_base): ... 
                              (center_ind + ind_trial));
        data_seg.times = pupil_ts((center_ind - ind_base): ... 
                              (center_ind + ind_trial));
        
        % Swap out or append to the ends the approximated values.
        if zero_errb == 1 && base_ind1 > ind_base
            % Here, we append to the beginning
            data_seg.data = [val_out_base data_seg.data']';
            data_seg.times = [pupil_bts_final data_seg.times']';
        else
            % Here, we replace the beginning
            data_seg.data(1) = val_out_base;
            data_seg.times(1) = pupil_bts_final;
        end
        
        if zero_errt == 1 && trial_ind2 > ind_trial
            % Append to end
            data_seg.data = [data_seg.data' val_out_trial]';
            data_seg.times = [data_seg.times' pupil_tts_final]';
        else
            % Replace last value
            data_seg.data(end) = val_out_trial;
            data_seg.times(end) = pupil_tts_final;
        end
        display(['Final timespan: ' sprintf('%.20f',(data_seg.times(end)-data_seg.times(1)))]);
    else
        %% TODO, reimplement what is in the negative section for this one.
        zero_baseline = 0;
        if baseline == 0
            zero_baseline = 1;
        end
        
        % Check times
        tmp1 = pupil_ts(center_ind+num_basepoints) - pupil_ts(center_ind);
        tmp2 = pupil_ts(center_ind+num_trialpoints) - pupil_ts(center_ind);
        
        display('Before:');
        display('Base time:');
        display(tmp1);
        display('Time trial:');
        display(pupil_ts(center_ind+num_trialpoints) - pupil_ts(center_ind));
        display('Total time:');
        display(tmp2-tmp1);
        
        if zero_baseline == 0
            [pupil_bts_final, zero_errb, ind_base, base_ind1, base_ind2, error_fin_base] = ...
                getrighttime(pupil_ts, center_ind, num_basepoints, tmp1, baseline);
            
            % Used in approximation
            newtime_base = pupil_bts_final - pupil_ts(center_ind);
        else
            newtime_base = 0;
            ind_base = 0;
            pupil_bts_final = pupil_ts(center_ind);
        end
        
        [pupil_tts_final, zero_errt, ind_trial, trial_ind1, trial_ind2, error_fin_trial] = ...
            getrighttime(pupil_ts, center_ind, num_trialpoints, tmp2, end_time);
        % Save variable for approximation
        newtime_trial = pupil_tts_final - pupil_ts(center_ind);
        
        % Display difference between previsou and current lengths.
        display('After:');
        display('Time baseline:');
        
        tmp1 = pupil_ts(center_ind + ind_base) - pupil_ts(center_ind);
        display(pupil_ts(center_ind + ind_base) - pupil_ts(center_ind));
        display('Time trial:');
        tmp2 = pupil_ts(center_ind + ind_trial) - pupil_ts(center_ind);
        display(pupil_ts(center_ind + ind_trial) - pupil_ts(center_ind));
        
        display('Total time:');
        display(tmp2-tmp1);
        
        % Find linear approximation to the exact point. This makes the
        % epoch lengths exact with a simple linear approximation.
        % First, do the baseline side.
        if zero_baseline == 0 && zero_errb == 0
            [val_out_base, ts_out] = linear_approx(pupil_data(center_ind + base_ind1), ...
                                              pupil_ts(center_ind + base_ind1), ...
                                              pupil_data(center_ind + base_ind2), ...
                                              pupil_ts(center_ind + base_ind2), ...
                                              pupil_bts_final);
        elseif zero_baseline == 0
            val_out_base = pupil_data(center_ind + ind_base);
        else
            val_out_base = pupil_data(center_ind);
        end
        % Now do the trial side.  
        if zero_errt == 0
            [val_out_trial, ts_out] = linear_approx(pupil_data(center_ind + trial_ind1), ...
                                              pupil_ts(center_ind + trial_ind1), ...
                                              pupil_data(center_ind + trial_ind2), ...
                                              pupil_ts(center_ind + trial_ind2), ...
                                              pupil_tts_final);
        else
            val_out_trial = pupil_data(center_ind + ind_trial);
        end

        % Display the approximation and what was changed.
        display('Approximation visualization: ');
        if zero_baseline == 0
            display(['Previous base: ' sprintf('%.10f',pupil_data(center_ind + ind_base))]);
            display(['Next base: ' sprintf('%.10f',val_out_base)]); 
            display(['New time base: ' sprintf('%.20f', newtime_base)]);
        end
        display(['Previous trial: ' sprintf('%.10f',pupil_data(center_ind + ind_trial))]);
        display(['Next trial: ' sprintf('%.10f',val_out_trial)]);
        display(['New time trial: ' sprintf('%.20f', newtime_trial)]);
        
        % Get the epoch from the data set.
        data_seg.data = pupil_data((center_ind + ind_base): ... 
                              (center_ind + ind_trial));
        data_seg.times = pupil_ts((center_ind + ind_base): ... 
                              (center_ind + ind_trial));
        
        % Swap out or append to the ends the approximated values.
        if zero_baseline == 0 && zero_errb == 1 && base_ind1 > ind_base
            % Here, we append to the beginning
            data_seg.data = [val_out_base data_seg.data']';
            data_seg.times = [pupil_bts_final data_seg.times']';
        else
            % Here, we replace the beginning
            data_seg.data(1) = val_out_base;
            data_seg.times(1) = pupil_bts_final;
        end
        
        if zero_errt == 1 && trial_ind2 > ind_trial
            % Append to end
            data_seg.data = [data_seg.data' val_out_trial]';
            data_seg.times = [data_seg.times' pupil_tts_final]';
        else
            % Replace last value
            data_seg.data(end) = val_out_trial;
            data_seg.times(end) = pupil_tts_final;
        end
        display(['Final timespan: ' sprintf('%.20f',(data_seg.times(end)-data_seg.times(1)))]);
    end
end