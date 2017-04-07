function PUPIL_RMEPOCH = pupil_rmepochs(PUPIL, trig, epochs2rm)
%PUPIL_RMEPOCH Removes epochs from a given pupil dataset.
% This function can be used to remove a given set of epochs from a given
% trigger.
%   INPUT:
%       PUPIL          -  The dataset to remove epochs from.
%       trig           -  The trigger to remove epochs from.
%       epochs2rm      -  The epochs to remove from the given dataset.
%   RETURN:
%       PUPIL_RMEPOCH  -  The new pupil dataset with the given epochs
%                         removed from a trigger set.
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

    % Get trigger index
    trig_ind = 0;
    for i = 1:size(PUPIL.eye0.epochs,2)
        if strcmp(trig, PUPIL.eye0.epochs{1,i}.name)
            trig_ind = i;
        end
    end
    if trig_ind == 0
        error(['Cannot find trigger ' trig ' in PUPIL dataset...aborting epoch removal.']);
    end
    
    % Get a new list of indexes, with the given epoch indices removed.
    full_ind = 1:size(PUPIL.eye0.epochs{1,trig_ind}.epochs,1);
    inds = setdiff(full_ind,epochs2rm);
    PUPIL_RMEPOCH = PUPIL;
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs = cell(length(inds),1);
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochs = cell(length(inds),1);

    % Redo the epochs cell array with the given indices.
    for i = 1:length(inds)
        PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs{i,1} = PUPIL.eye0.epochs{1,trig_ind}.epochs{inds(i),1};
        PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochs{i,1} = PUPIL.eye1.epochs{1,trig_ind}.epochs{inds(i),1};
    end
    

    %% Redo epochmat, epochmat_rmb, epochmat_pc.
    % make_epochmat
    % make_epocpmatrmb
    epoch_size = size(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs, 1);
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat = ... 
        zeros(epoch_size, length(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs{1,1}.data));
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat = ... 
        zeros(epoch_size, length(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs{1,1}.data));
    for l = 1:epoch_size
        PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat(l,:) = ...
                                 PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochs{l,1}.data;
        PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat(l,:) = ...
                                 PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochs{l,1}.data;
    end
    
    % Reset matrices.
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat_rmb = zeros(epoch_size, size(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat,2));
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat_rmb = zeros(epoch_size, size(PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat,2));
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat_pc = zeros(epoch_size, size(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat,2));
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat_pc = zeros(epoch_size, size(PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat,2));
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.rest_mean = zeros(1,epoch_size);
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.rest_mean = zeros(1,epoch_size);
    
    % Recalculate baseline removal plot.
    [PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat_rmb, ...
     PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.rest_mean] = pupil_rmbaselineeye(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat, 1, PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.baseline_ind);

    [PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat_rmb, ... 
     PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.rest_mean] = pupil_rmbaselineeye(PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat, 1, PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.baseline_ind);

 
    % Calculate the percent change graph.
    PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat_pc = ...
        pupil_datapercenteye(PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.epochmat, PUPIL_RMEPOCH.eye0.epochs{1,trig_ind}.rest_mean);
    PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat_pc = ...
        pupil_datapercenteye(PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.epochmat, PUPIL_RMEPOCH.eye1.epochs{1,trig_ind}.rest_mean);
end