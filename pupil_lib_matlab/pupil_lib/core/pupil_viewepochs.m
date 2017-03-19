function [figArr0, figArr1] = pupil_viewepochs(PUPIL)
%PUPIL_VIEWEPOCHS Function to view all the individual epochs of a given
%dataset.
%    INPUT:
%        PUPIL     - The pupil data set in look at.
%    OUTPUT:
%        figArr0   - The array of figures for eye 0.
%        figArr1   - The array of figures for eye 1.
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

    % Containers for the figures so they can be modified.
    figArr0 = [];
    figArr1 = [];
    
    % Go through all triggers.
    for i = 1:size(PUPIL.eye0.epochs,2)
        
        % Eye 0
        % Create, store, & title, a figure, then plot it
        figArr0(i) = figure; suptitle(['Eye 0 - Trigger ' PUPIL.eye0.epochs{1,i}.name]); 
        num_epochs = size(PUPIL.eye0.epochs{1,i}.epochs,1);
        num_epochsdiv = ceil(num_epochs/4);
        for j = 1:num_epochs
            subplot(4,num_epochsdiv,j); plot(PUPIL.eye0.epochs{1,i}.epochs{j,1}.data);
        end
        
        % Eye 1
        % Create, store, & title, a figure, then plot it
        figArr1(i) = figure; suptitle(['Eye 1 - Trigger ' PUPIL.eye0.epochs{1,i}.name]); 
        num_epochs = size(PUPIL.eye1.epochs{1,i}.epochs,1);
        num_epochsdiv = ceil(num_epochs/4);
        for j = 1:num_epochs
            subplot(4,num_epochsdiv,j); plot(PUPIL.eye1.epochs{1,i}.epochs{j,1}.data);
            title(int2str(j));
        end
    end
end