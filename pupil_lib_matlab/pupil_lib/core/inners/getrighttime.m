function [pupil_tts_final, zero_errt, ind_trial, trial_ind1, trial_ind2, error_fin_trial] ... 
                = getrighttime(pupil_ts, center_ind, num_trialpoints, curr_length, opt_length)
%PUPIL_GETRIGHTTIME Get a timestamp at 'opt_length' of time to the right of
%'center_ind'.
%   This function is used to get a timestamp that is closest to being at a
%   time 'opt_length' away from the center_ind timestamp, and to the right
%   of it. It calculates an error (if it exists, zero_errt distinguishes
%   between these cases), the optimal timestamp, an optimal index, an the
%   indices surrounding the optimal timestamps location. These can be used
%   to make a linear approximation for the correct values. They are also
%   arranged so that the order or application doesn't have to change
%   between the over and under measured cases.
%   INPUT
%       pupil_ts          -  The timestamps time series associated to the
%                            data.
%       center_ind        -  The index of a marker that is used to
%                            determine the location of a timestamp
%                            approximately 'opt_length' away from it to the
%                            right (in increasing time).
%       num_trialpoints   -  The estimated number of points away that
%                            'opt_length' should be close to.
%       curr_length       -  The current time that 'num_trialpoints' is
%                            away from the timestamp associated to 'center_ind'.
%       opt_length        -  The optimal time that the indices timestamp
%                            must be close to with a global minimum error.
%
%   OUPUT 
%       pupil_tts_final   -  The optimal timestamp, corrected by the final
%                            error. Can be used in a linear approximation
%                            for edge points.
%       zero_errt         -  When set to 1, this flag signifies that there
%                            is no error in the final timestamp and no linear
%                            approximation is needed.
%       ind_trial         -  The near-optimal/optimal index for the best
%                            possible timestamp.
%       trial_ind1        -  This exists, or can be used, when zero_errt is
%                            set to 0. It's meaning depends on whether an
%                            over or under measure occured. It can be
%                            directly used in #linear_approx# as seen in
%                            #pupil_cutout#.
%       trial_ind2        -  This exists, or can be used, when zero_errt is
%                            set to 0. It's meaning depends on whether an
%                            over or under measure occured. It can be
%                            directly used in #linear_approx# as seen in
%                            #pupil_cutout#.
%       error_fin_trial   -  The final error in the timestamp indexed by
%                            'trial_ind'
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

    % Init variables for approximation
    ind_trial = 0;
    error_fin_trial = 0;
    pupil_tts_final = 0;
    trial_ind1 = 0;
    trial_ind2 = 0;
    zero_errt = 0;
    if curr_length > opt_length
        % Get the closest possible point with the lowest error.
        [ind_trial, error_fin_trial] = pupil_getclosestpoint(1, 1, pupil_ts, center_ind, num_trialpoints, opt_length);

        % Get information for linear approximation, check the final
        % error to do this. Keep an optimal timestamp, and the data points
        % surrounding it.
        if error_fin_trial < 0 % Undermeasured
            pupil_tts_final = pupil_ts(center_ind+ind_trial) - error_fin_trial;
            
            % Get the next point to estimate an exact midpoint in time
            trial_ind1 = ind_trial;
            trial_ind2 = ind_trial + 1;
        elseif error_fin_trial > 0 % Overmeasured
            pupil_tts_final = pupil_ts(center_ind+ind_trial) - error_fin_trial;
            
            % Get the previous point to estimate an exact midpoint in time
            trial_ind1 = ind_trial - 1;
            trial_ind2 = ind_trial;
        else
            zero_errt = 1;
        end
    elseif curr_length < opt_length
        % Get the closest possible point with the lowest error.
        [ind_trial, error_fin_trial] = pupil_getclosestpoint(0, 1, pupil_ts, center_ind, num_trialpoints, opt_length);

        % Get information for linear approximation, check the final
        % error to do this.
        if error_fin_trial < 0 % Undermeasured
            pupil_tts_final = pupil_ts(center_ind+ind_trial) - error_fin_trial;
            % Get the next point to estimate an exact midpoint in time
            trial_ind1 = ind_trial;
            trial_ind2 = ind_trial + 1;
        elseif error_fin_trial > 0 % Overmeasured
            pupil_tts_final = pupil_ts(center_ind+ind_trial) - error_fin_trial;
            % Get the previous point to estimate an exact midpoint in time
            trial_ind1 = ind_trial - 1;
            trial_ind2 = ind_trial;
        else
            zero_errt = 1;
        end
    else % We have an exact measurement
        zero_errt = 1;
        ind_trial = num_trialpoints;
    end
end

