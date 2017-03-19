function PUPIL = pupil_load(test_dir, varargin)
%PUPIL_LOAD Load data from an experiment stored in a given folder.
% This function is used to load a directory of pupil data into MATLAB. It
% needs to be supplied a test directory and that directory must contain the
% following files:
%
%           pupil_eye0_diams.csv,   pupil_eye0_ts.csv
%           pupil_eye1_diams.csv,   pupil_eye1_ts.csv
%           markers_ts.csv,     markers_evnames.csv
%
% They are available after running the script 'marker_proc.py' on the test
% directory.
% 
% INPUT:
%       test_dir    -  The directory that contains the experiment and the
%                      data needed.
% OPTIONAL:
%       (NONE)
% 
% OUTPUT:
%       PUPIL       -  A data structure containing all the raw data and
%                      markers that were found.
%
% TODO:
%   * Allow different datasets to be epoched by using varargin. i.e. gaze
%     direction, and many others.
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

    current_dir = pwd;
    cd(test_dir);
    
    PUPIL.eye0.data = csvread('pupil_eye0_diams.csv');
    PUPIL.eye0.timestamps = csvread('pupil_eye0_ts.csv');
    PUPIL.eye0.srate = pupil_srate(PUPIL.eye0.data, PUPIL.eye0.timestamps);
    
    PUPIL.eye1.data = csvread('pupil_eye1_diams.csv');
    PUPIL.eye1.timestamps = csvread('pupil_eye1_ts.csv');
    PUPIL.eye1.srate = pupil_srate(PUPIL.eye1.data, PUPIL.eye1.timestamps);
    
    PUPIL.markers.timestamps = csvread('markers_ts.csv');
    PUPIL.merged = 0;
    
    fid = fopen('markers_evnames.csv','rt');
    C = textscan(fid, '%s', 'Delimiter',',', 'HeaderLines',0, ...
        'MultipleDelimsAsOne',true, 'CollectOutput',false);
    fclose(fid);

    PUPIL.markers.eventnames = C{1};
    
    cd(current_dir);
end