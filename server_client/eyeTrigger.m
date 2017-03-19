function eyeTrigger(eventName, order, recorder)
% This function sends a trigger to a server running on a port.
% It creates a timestamp for you also and it has a guaranteed 64-bit
% floating point precision of ~10 microseconds.
%
% IMPORTANT: * For an easier time synchronizing data, send a marker that
%              designates when the experiment starts. 
%
% eventName: Name of the event to send.
%
% order: Order across all messages for this event.
%
% recorder: The name of the server's host machine. Type 'hostname' on linux
%           to find out.
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

    arg = [num2str(((datenum(clock)*24*60*60)), '%10.6f') eventName order];
    fwrite(recorder, arg)
end