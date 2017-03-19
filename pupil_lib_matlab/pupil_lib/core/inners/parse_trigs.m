function [trig_ind] = parse_trigs(PUPIL_EYE, trig)
%PARSE_TRIGS Parses a pupil entry for a trigger index.
%   INPUT:
%       PUPIL - PUPIL data, which has the same epoch triggers in each eye.
%       trig  - The name of the trigger in the form of a string.
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

    trig_ind = 0;
    for i = 1:size(PUPIL_EYE.epochs,2)
        if strcmp(trig, PUPIL_EYE.epochs{1,i}.name)
            trig_ind = i;
        end
    end

end

