function t = getEyeTrackerConnect(hostname, portnum)
% This function uses a host name and a port number to establish a TCP
% connection to a server running with a pupil capture session that is
% recording an experiment. Using this function reduces the overhead call to
% sending a trigger dramatically.
%   INPUT:
%       hostname  -  The host to connect to. It can either be an IPv4
%                    address or a host name.
%       portnum   -  The port that the server is connected to.
%   RETURN:
%       t         -  Returns the connection to the server for use in the
%                    #eyeTrigger# function.
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

    t = tcpip(hostname, portnum, 'NetworkRole', 'client');
    fopen(t);
end