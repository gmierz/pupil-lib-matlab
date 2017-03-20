function [outlet] = create_marker_outlet()
%CREATE_MARKER_INLET This function can be used to initiate a marker outlet.
% This function can initiate an outlet that sends data to an inlet running
% elsewhere.
% OUTPUT:
%       outlet  -  The outlet that can be used to push data with the
%                  #push_sample# function. It accepts a cell array of strings.
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

    % Load the library.
    disp('Loading library...');
    lib = lsl_loadlib();

    % Make a new stream outlet.
    disp('Creating a new streaminfo...');
    info = lsl_streaminfo(lib,'Markers','Stimulus',1,100,'cf_string','sdfwerr32432');

    disp('Opening an outlet...');
    outlet = lsl_outlet(info);
end