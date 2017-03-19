function [val_out, ts_out] = linear_approx(val1, ts1, val2, ts2, ts_final)
%LINEAR_APPROX Used to approximate a diameter at an intermediate point.
%   This will take two diameters and two timestamps, along with a time and
%   it will output a linear approximation for that time
%
%   diameter
%       ^
%       |       x
%       |      / (ts2, val2)
%val_out|____ / 
%       |    /|       
%       |   / |
%       |  x  | 
%       |   (ts1, val1)
%       |-----|------------------> timestamps
%             |
%       ts_final/ts_out
%
%   INPUT: Described through the graph.
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

    line_slope = (val2-val1)/(ts2-ts1);
    line_const = (val1-(ts1*line_slope));
    val_out = ((ts_final*line_slope)+line_const);
    ts_out = ts_final;
end

