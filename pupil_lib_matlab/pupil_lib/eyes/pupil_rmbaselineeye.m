function [pupil_rmb, baseline_mean] = pupil_rmbaselineeye(pupil_epdata, base_ind, start_ind)
% Used to remove a baseline mean from each epoch and create a new matrix.
%   INPUT:
%       pupil_epdata  -  A martix containing all the epoched data.
%                        Row - Data, Column - Epochs
%       base_ind      -  Baseline start index.
%       start_ind     -  Center marker or baseline end marker.
%   RETURN:
%       pupil_rmb     -  The new epoched data in the form of a matrix that
%                        is the same size as pupil_epdata. It has the
%                        baseline mean removed from all values.
%       baseline_mean -  An array containing the baseline means for each
%                        epoch.
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
    baseline_mean = zeros(1, size(pupil_epdata, 1));
    pupil_rmb = pupil_epdata;
    
    % For each epoch
    for i = 1:size(pupil_epdata, 1)
        % Get the mean and then remove it from all the data points.
        baseline_mean(i) = mean(mean(pupil_epdata(i,base_ind:start_ind),2),1);
        pupil_rmb(i,:) = pupil_epdata(i,:)-baseline_mean(i); 
    end
end