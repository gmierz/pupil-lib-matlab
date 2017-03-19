function PUPIL_MERGED = pupil_mergesets(PUPIL0, PUPIL1)
%PUPIL_MERGESETS USed to merge to pupil datasets and their epochs.
% This function expects that the two sets to merge will have the same
% triggers in each of the datasets. It also DOES NOT check to see if the
% epochs are of the same length. pupil_epoch(...) must be run on both
% datasets to be able to correctly use this function.
%   INPUT:
%       PUPIL0 - First dataset which will be used as the base set.
%       PUPIL1 - Dataset that will be merged in.
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

    % Initialize and hold some old data.
    PUPIL_MERGED = PUPIL0;
    PUPIL_MERGED.merged = PUPIL_MERGED.merged + 1;
    PUPIL_MERGED.eye0.(['data' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye0.data;
    PUPIL_MERGED.eye0.(['timestamps' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye0.timestamps;
    PUPIL_MERGED.eye0.(['srate' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye0.srate;
    
    PUPIL_MERGED.eye1.(['data' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye1.data;
    PUPIL_MERGED.eye1.(['timestamps' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye1.timestamps;
    PUPIL_MERGED.eye1.(['srate' int2str(PUPIL_MERGED.merged)]) = PUPIL1.eye1.srate;
    
    % For each trigger
    for i = 1:size(PUPIL0.eye1.epochs,2)
        
        % Get a trigger index
        name = PUPIL_MERGED.eye0.epochs{1,i}.name;
        ind = 0;
        for j = 1:size(PUPIL1.eye0.epochs,2)
            if strcmp(name, PUPIL1.eye0.epochs{1,j}.name)
                ind = j;
                break;
            end
        end
        if ind == 0
            error(['Cannot find trigger ' name ' in PUPIL1 dataset...aborting merge.']);
        end
        
        % Merge eye 0
        tmp_epochs = PUPIL_MERGED.eye0.epochs{1,i}.epochs;
        [x1, ~] = size(tmp_epochs);
        display(['Eye 0: Dataset 0 for trigger ' name ' has ' int2str(x1) ' epochs.']);
        tmp_epochs = PUPIL1.eye0.epochs{1,i}.epochs;
        [x1, ~] = size(tmp_epochs);
        display(['Eye 0: Dataset 1 for trigger ' name ' has ' int2str(x1) ' epochs.']);
        
        PUPIL_MERGED.eye0.epochs{1,i}.epochs = vertcat(PUPIL_MERGED.eye0.epochs{1,i}.epochs, ...
                                                       PUPIL1.eye0.epochs{1,ind}.epochs);
        
        % Merge eye 1
        tmp_epochs = PUPIL_MERGED.eye1.epochs{1,i}.epochs;
        [x1, ~] = size(tmp_epochs);
        display(['Eye 1: Dataset 0 for trigger ' name ' has ' int2str(x1) ' epochs.']);
        tmp_epochs = PUPIL1.eye1.epochs{1,i}.epochs;
        [x1, ~] = size(tmp_epochs);
        display(['Eye 1: Dataset 1 for trigger ' name ' has ' int2str(x1) ' epochs.']);
        
        PUPIL_MERGED.eye1.epochs{1,i}.epochs = vertcat(PUPIL_MERGED.eye1.epochs{1,i}.epochs, ...
                                                       PUPIL1.eye1.epochs{1,ind}.epochs);
        
        % Display new trial counts.
        tmp_epochs = PUPIL_MERGED.eye0.epochs{1,i}.epochs;
        size(tmp_epochs);
        display(['Eye 0: Merged dataset for trigger ' name ' has ' int2str(x1) ' epochs.']);
        tmp_epochs = PUPIL_MERGED.eye1.epochs{1,i}.epochs;
        size(tmp_epochs);
        display(['Eye 1: Merged dataset for trigger ' name ' has ' int2str(x1) ' epochs.']);
        
        % Remake the matrices that hold the epoched data.
        PUPIL_MERGED = make_epochmat(PUPIL_MERGED, i);
        PUPIL_MERGED = make_rmb_pc_mats(PUPIL_MERGED, i);
    end
end