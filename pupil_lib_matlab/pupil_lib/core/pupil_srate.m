function srate = pupil_srate(pupil_data, pupil_ts)
%PUPIL_SRATE Returns the sampling rate of the given data
%   INPUT:
%       pupil_data   -  The raw pupil data that was recorded.
%       pupil_ts     -  The raw timestamps from the recorded data.
%   RETURN:
%       srate        -  The sampling rate.
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

    srate = length(pupil_data) / (max(pupil_ts) - min(pupil_ts));
end