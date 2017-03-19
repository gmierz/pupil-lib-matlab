function pupil_datapercent = pupil_datapercenteye(pupil_data, rest_mean)
%PUPIL_DATAPERCENTEYE Calculates a percent change for each epoch.
% This function takes in a matrix epoch with their baseline means and finds
% a percent change series for each epoch.
%   INPUT:
%       pupil_data         -  The epoched data matrix to determine percent change
%                             for.
%                             Row - Data, Column - Epochs
%       rest_mean          -  The list of baseline - or rest - means for
%                             each epoch. This list can be obtained from
%                             #pupil_rmbaselineeye#.
%   RETURN:
%       pupil_datapercent  -  The epoched matrix with the percent changes.
%                             It has the same size as the input dataset
%                             pupil_data.
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

    pupil_datapercent = pupil_data;
    for i = 1:size(pupil_data,2)
        for j = 1:size(pupil_data,1)
            pupil_datapercent(j,i) = (pupil_data(j,i)-rest_mean(j))/rest_mean(j);
        end
    end
end