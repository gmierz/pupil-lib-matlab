function [ data_struct ] = parse_xdf(xdf_file, name_field)
%PARSE_XDF Parse xdf for structure of a given field.
%   Go through the data of a given XDF file to find a structure with the
%   given name.
%   INPUT:
%       xdf_file        -  The XDF file to parse.
%       name_field      -  The name of the filed to look for.
%   OUTPUT:
%       data_struct     -  The data structure that was found with the given
%                          name.
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

    chan_size = size(xdf_file, 2);
    for i = 1:chan_size
        if strcmp(xdf_file{i}.info.name, name_field)
            data_struct = xdf_file{i};
            return;
        end
    end
    error(['Coult not find the field,' name_field ' in the given XDF file.']);
end

