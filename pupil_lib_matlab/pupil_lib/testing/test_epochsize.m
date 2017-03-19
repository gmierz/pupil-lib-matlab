function [test_flag, epoch_inds0, epoch_ind1] = test_epochsize(PUPIL)
%TEST_EPOCHSIZE Test the epoch timespans.
%   This function can be used to test whether or not the epochs that are
%   given from a #pupil_epoch# run are exact.
%   INPUT:
%       PUPIL       -  This is the dataset to test.
%   OUTPUT:
%       test_flag   -  Tells whether or not the test passed or failed. 1
%                      for pass, 0 for failure.
%       epoch_inds0 -  Epochs in eye1 which did not pass the test.
%       epoch_inds1 -  Epochs in eye0 which did not pass the test.
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

    test_flag = 0;
    epoch_inds0 = struct;
    epoch_inds1 = struct;
    
    % Test eye 0 epoch lengths.
    count_err0 = 0;
    for trig = 1:size(PUPIL.eye0.epochs, 2)
        [epoch_size, ~] =  size(PUPIL.eye0.epochs{1,trig}.epochs);
        epoch_inds0{trig} = zeros(epoch_size, 1);
        
        for i = 1:epoch_size
            timestamps = PUPIL.eye0.epochs{1,trig}.epochs{i,1}.times;
            time = PUPIL.eye0.epochs{1,trig}.time;
            
            % Check that the difference in time is exact
            if timestamps(end)-timestamps(1) ~= time
                count_err0 = count_err0 + 1;
                epoch_inds0{trig}(i) = 1;
            end
        end
    end
    display(count_err0);
    
    % Test eye 1 epoch lengths
    count_err1 = 0;
    for trig = 1:size(PUPIL.eye0.epochs, 2)
        [epoch_size, ~] =  size(PUPIL.eye0.epochs{1,trig}.epochs);
        epoch_inds1{trig} = zeros(epoch_size, 1);
        
        for i = 1:epoch_size
            timestamps = PUPIL.eye0.epochs{1,trig}.epochs{i,1}.times;
            time = PUPIL.eye0.epochs{1,trig}.time;
            
            % Check that the difference is exact
            if timestamps(end)-timestamps(1) ~= time
                count_err1 = count_err1 + 1;
                epoch_inds1{trig}(i) = 1;
            end
        end
    end
    
    display(count_err1);
    
    % Error if we find at least one dataset with an incorrect time length.
    if count_err1 > 0 || count_err0 > 0
        error(['Error: Failed epoch length test. Expecting 0, received: \n Eye1 - ' ...
                int2str(count_err1) ', Eye 0 - ' int2str(count_err0)]);
    else
        test_flag = 1;
        display('TEST PASS.');
    end
end

