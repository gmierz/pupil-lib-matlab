function [test_dataset, test_markers] = build_config(start_pos, interval, dataset_size, varargin)
%BUILD_CONFIG Build up a test dataset with specific conditions.
%   This function can be used to build mock data that can be used for
%   testing the different functions that this library uses.
%   INPUT
%       start_pos       -  This value dictates where the first mock marker/trial
%                          will start at.
%       interval        -  This value will determine the interval at which
%                          trials are created.
%       dataset_size    -  This value will change the size of the resulting
%                          mock dataset.
%
%   OPTIONAL
%      (None for now)
%   
%   OUTPUT
%       test_dataset    -  This variable will contain the resulting mock
%                          data.
%       test_markers    -  This variable will contain the resulting mock
%                          trial markers.
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

    % Test vars
    % Currently, the minimum interval is 201 points.
    if interval < 201
        error(['Tests are not built for this type of dataset as it combines'  ...
              ' the test trial in multiple trials, making the results hard to' + ...
              ' predict.']);
    end
    if start_pos < 0
        error('Cannot have negative indices.');
    end
    if interval > dataset_size
        error('Dataset size cannot be smaller than the interval.');
    end
    if start_pos > dataset_size
        error('Start position must be smaller than the dataset size.');
    end
    
    test_dataset = ones(2, dataset_size);
    % Build a test dataset with a constant trial size
    for i = start_pos:interval:size(test_dataset,2)-(interval+50)
        test_dataset(1, i:(i+201)) = [[1:0.2:21] [21:-0.2:1]];
    end

    % Plot the data for visualization
    figure, plot(test_dataset(1,:))

    % Build a test marker dataset according to the 
    test_markers = start_pos:interval:size(test_dataset,2)-interval+50;
end

