function [PUPIL_EPOCHED] = make_epochmat(PUPIL_EPOCHED, trigger_ind)
%MAKE_EPOCHMAT Produces a matrix of epochs in a given pupil dataset.
%   INPUT
%       PUPIL_EPOCHED       -  The dataset used to produce the matrix.
%       trigger_ind         -  The trigger index of the trigger to process.
%   OUTPUT
%       PUPIL_EPOCHED       -  The new dataset containing the resulting
%                              matrix 'epochmat'.
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

    % Produce a matrix of the epoch data across all epochs. 
    epoch_size = size(PUPIL_EPOCHED.eye0.epochs{1,trigger_ind}.epochs, 1);
    PUPIL_EPOCHED.eye0.epochs{1,trigger_ind}.epochmat = ... 
        zeros(epoch_size, length(PUPIL_EPOCHED.eye0.epochs{1,trigger_ind}.epochs{1,1}.data));

    for l = 1:epoch_size
        PUPIL_EPOCHED.eye0.epochs{1,trigger_ind}.epochmat(l,:) = ...
                                 PUPIL_EPOCHED.eye0.epochs{1,trigger_ind}.epochs{l,1}.data;
        PUPIL_EPOCHED.eye1.epochs{1,trigger_ind}.epochmat(l,:) = ...
                                 PUPIL_EPOCHED.eye1.epochs{1,trigger_ind}.epochs{l,1}.data;
    end
end

