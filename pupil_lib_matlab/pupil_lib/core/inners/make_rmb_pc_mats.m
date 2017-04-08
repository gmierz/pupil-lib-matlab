function [ PUPIL_EPOCHED ] = make_rmb_pc_mats(PUPIL_EPOCHED, trig_ind)
%MAKE_RMB_PC_MATS Used to produce the percent change graph and remove the
%baseline from a measurement.
%   INPUT
%       PUPIL_EPOCHED       -  The dataset used to produce the matrices.
%       trig_ind            -  The trigger index of the trigger to process.
%   OUTPUT
%       PUPIL_EPOCHED       -  The new dataset containing the resulting
%                              matrices 'epochmat_rmb', and 'epochmat_pc'.
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

    % Remove the baseline and get the rest mean for each set of
    % trigger.
    k = trig_ind;
    
    % Check if this set previously had matrix epochs.
    if isfield(PUPIL_EPOCHED.eye0.epochs{1,k}, 'epochmat_rmb')
        PUPIL_EPOCHED.eye0.epochs{1,k} = rmfield(PUPIL_EPOCHED.eye0.epochs{1,k}, {'epochmat_rmb', 'rest_mean', 'epochmat_pc'});
    end
    
    if isfield(PUPIL_EPOCHED.eye0.epochs{1,k}, 'epochmat_rmb')
        PUPIL_EPOCHED.eye1.epochs{1,k} = rmfield(PUPIL_EPOCHED.eye1.epochs{1,k}, {'epochmat_rmb', 'rest_mean', 'epochmat_pc'});
    end
    
    % Remove the baseline and get the resulting matrix with their
    % associated baseline means.
    [PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_rmb, ... 
     PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, ...
                                                            1, PUPIL_EPOCHED.eye1.epochs{1,k}.baseline_ind);
    [PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_rmb, ...
     PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, ...
                                                            1, PUPIL_EPOCHED.eye0.epochs{1,k}.baseline_ind);

    % Calculate the percent change graph using the means found above.
    PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_pc = ...
        pupil_datapercenteye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean);
    PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_pc = ...
        pupil_datapercenteye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean);
    
end

