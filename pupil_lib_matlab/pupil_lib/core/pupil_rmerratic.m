function PUPIL_RMERRATIC = pupil_rmerratic(PUPIL, trig, tolerance)
%PUPIL_RMERRATIC Removes erratic epochs from a given dataset.
% This function removes erratic samples from each trigger set in a pupil
% dataset. It rejects based on the distance of consecutive points within a
% given tolerance, and a trigger.
%   INPUT:
%       PUPIL            -  The pupil dataset that will have it's epochs
%                           removed.
%       trig             -  The trigger index to remove epochs from.
%       tolerance        -  The tolerance to base rejection on.
%   RETURN:
%       PUPIL_RMERRATIC  -  The new data set with erratic epochs meeting
%                           the tolerance removed.
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

    % Init filtered epoch containers.
    good_epochs0 = {};
    good_epochs1 = {};
    new_epoch_count = 0;
    
    % For each epoch
    for i = 1:size(PUPIL.eye0.epochs{1,trig}.epochs, 1)
        % Cheack eye 0 data 
        tmp_ev1 = PUPIL.eye0.epochs{1,trig}.epochs{i,1}.times(2:2:end);
        tmp_od1 = PUPIL.eye0.epochs{1,trig}.epochs{i,1}.times(1:2:end);
        tmp_min = min([length(tmp_ev1) length(tmp_od1)]);
        tmp_ev = tmp_ev1(1:tmp_min);
        tmp_od = tmp_od1(1:tmp_min);
        tmp_sub = tmp_ev-tmp_od;
        max_erratic = max(tmp_sub);
        
        % If the maximum distance is greater than the tolerance, reject.
        if max_erratic > tolerance
            continue;
        end
        
        % Check eye 1 data.
        tmp_ev1 = PUPIL.eye1.epochs{1,trig}.epochs{i,1}.times(2:2:end);
        tmp_od1 = PUPIL.eye1.epochs{1,trig}.epochs{i,1}.times(1:2:end);
        tmp_min = min([length(tmp_ev1) length(tmp_od1)]);
        tmp_ev = tmp_ev1(1:tmp_min);
        tmp_od = tmp_od1(1:tmp_min);
        tmp_sub = tmp_ev-tmp_od;
        max_erratic = max(tmp_sub);

        % If the maximum distance is greater than the tolerance, reject.
        if max_erratic > tolerance
            continue;
        end
        
        % If we make if here, this epoch is good so save it.
        new_epoch_count = new_epoch_count + 1;
        good_epochs0{new_epoch_count,1} = PUPIL.eye0.epochs{1,trig}.epochs{i,1};
        good_epochs1{new_epoch_count,1} = PUPIL.eye1.epochs{1,trig}.epochs{i,1};
    end
    
    % Save the new epochs into the new dataset
    PUPIL_RMERRATIC = PUPIL;
    PUPIL_RMERRATIC.eye0.epochs{1,trig}.epochs = good_epochs0;
    PUPIL_RMERRATIC.eye1.epochs{1,trig}.epochs = good_epochs1;
    display('Old length:');
    display(size(PUPIL.eye0.epochs{1,trig}.epochs, 1));
    display('New Length:');
    display(new_epoch_count);
end