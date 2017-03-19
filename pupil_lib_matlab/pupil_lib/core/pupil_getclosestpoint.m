function [ind, error_final] = pupil_getclosestpoint(orientation, side, pupil_ts, center_ind, end_ind, time)
% Gets a timestamp that is as close as possible to the goal time.
% Give it an orientation to move a marker in, and a side -trial or base-, and
% it will find the timestamp that most closely approximates it, with the
% smallest error.
%
%   INPUT:
%       orientation  -  Orientation to move a marker. (1 - left, 0 -
%                       right).
%       side         -  Which marker to move. (1 - trial end marker, 0 -
%                       baseline start marker).
%       pupil_ts     -  List of timestamps to use.
%       center_ind   -  Index that the marker is centered on.
%       end_ind      -  Index correspinding to either the trial end mark if
%                       side is 1, and to the baseline start marker if side
%                       is 0.
%       time         -  Time range that must be optimized towards.
%
%   RETURN:
%       ind          -  Closest index to the time given.
%       error_final  -  Final erroor between time given and time obtained.
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

    if orientation == 1 % Close by moving to the left
        if side == 1 % From the trial side ending marker
            display('Shortening trial time...');
            % Init and get current error as a baseline.
            nextend = end_ind - 1;
            currerror = pupil_ts(center_ind+end_ind)-pupil_ts(center_ind) - time;
            nexterror = 0;
            
            % Overshot, get a timestamp that reduces the trial time.
            display(pupil_ts(center_ind+nextend)-pupil_ts(center_ind));
            while pupil_ts(center_ind+nextend)-pupil_ts(center_ind) > time
                nextend = nextend - 1;display(pupil_ts(center_ind+nextend)-pupil_ts(center_ind));
                display(time);
            end
            
            % Check errors, and return the best index and error.
            % Negative error means we are under.
            finalerror = pupil_ts(center_ind+nextend)-pupil_ts(center_ind) - time;
            finalerror2 = pupil_ts(center_ind+nextend+1)-pupil_ts(center_ind) - time;
            if abs(finalerror) < abs(currerror) && abs(finalerror) < abs(finalerror2)
                error_final = finalerror;
                ind = nextend;
            elseif abs(finalerror2) < abs(currerror)
                error_final = finalerror2;
                ind = nextend+1;
            else
                error_final = currerror;
                ind = end_ind;
            end
            
            return;
        else% From the baseline side ending marker
            display('Lengthening baseline time...');
            % Init and get current error as a baseline.
            nextend = end_ind + 1;
            currerror = pupil_ts(center_ind)-pupil_ts(center_ind-end_ind) - time;
            nexterror = 0;
            
            % Undershot, get a timestamp that increases the baseline time.
            display(pupil_ts(center_ind)-pupil_ts(center_ind-end_ind));
            while pupil_ts(center_ind)-pupil_ts(center_ind-nextend) < time
                nextend = nextend + 1;display(pupil_ts(center_ind)-pupil_ts(center_ind-nextend));
                display(time);
            end
            
            % Check errors, and return the best index and error.
            % Negative error means we are under.
            finalerror = pupil_ts(center_ind)-pupil_ts(center_ind-nextend) - time;
            finalerror2 = pupil_ts(center_ind)-pupil_ts(center_ind-nextend-1) - time;
            if abs(finalerror) < abs(currerror) && abs(finalerror) < abs(finalerror2)
                error_final = finalerror;
                ind = nextend;
            elseif abs(finalerror2) < abs(currerror)
                error_final = finalerror2;
                ind = nextend-1;
            else
                error_final = currerror;
                ind = end_ind;
            end
            return;
        end
    else % Close time gap by moving to the right
        if side == 1 % From the trial side ending marker
            display('Lengthening trial time...');
            % Init and get current error as a baseline.
            nextend = end_ind + 1;
            currerror = pupil_ts(center_ind+end_ind)-pupil_ts(center_ind) - time;
            nexterror = 0;
            
            % Undershot, get a timestamp that increases the trial time.
            display(pupil_ts(center_ind+nextend)-pupil_ts(center_ind));
            while pupil_ts(center_ind+nextend)-pupil_ts(center_ind) < time
                nextend = nextend + 1; display(pupil_ts(center_ind+nextend)-pupil_ts(center_ind));
                display(time);
            end
            
            % Check errors, and return the best index and error.
            % Negative error means we are under.
            finalerror = pupil_ts(center_ind+nextend)-pupil_ts(center_ind) - time;
            finalerror2 = pupil_ts(center_ind+nextend-1)-pupil_ts(center_ind) - time;
            if abs(finalerror) < abs(currerror) && abs(finalerror) < abs(finalerror2)
                error_final = finalerror;
                ind = nextend;
            elseif abs(finalerror2) < abs(currerror)
                error_final = finalerror2;
                ind = nextend-1;
            else
                error_final = currerror;
                ind = end_ind;
            end
            
            return;
        else % From the baseline side ending marker
            display('Shortening baseline time...');
            
            % Init and get current error as a baseline.
            nextend = end_ind - 1;
            currerror = pupil_ts(center_ind)-pupil_ts(center_ind-end_ind) - time;
            nexterror = 0;
            
            % Overshot, get a timestamp that reduces the baseline time.
            display(pupil_ts(center_ind)-pupil_ts(center_ind-end_ind));
            while pupil_ts(center_ind)-pupil_ts(center_ind-nextend) > time
                nextend = nextend - 1;
                display(pupil_ts(center_ind)-pupil_ts(center_ind-nextend));
                display(time);
            end
            
            % Check errors, and return the best index and error.
            % Negative error means we are under.
            finalerror = pupil_ts(center_ind)-pupil_ts(center_ind-nextend) - time;
            finalerror2 = pupil_ts(center_ind)-pupil_ts(center_ind-(nextend+1)) - time;
            if abs(finalerror) < abs(currerror) && abs(finalerror) < abs(finalerror2)
                error_final = finalerror;
                ind = nextend;
            elseif abs(finalerror2) < abs(currerror)
                error_final = finalerror2;
                ind = nextend+1;
            else
                error_final = currerror;
                ind = end_ind;
            end
            
            return;
        end
    end
end