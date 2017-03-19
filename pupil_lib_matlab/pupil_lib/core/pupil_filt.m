function [PUPIL_FILTEYE] = pupil_filt(PUPIL_EYE, smoothkey, trigs, varargin)
%PUPIL_FILT This function can be used to filter the epoched data from a
%given eye.
%   INPUT:
%       PUPIL_EYE       -    PUPIL.eye0/1 to be filtered.
%       smoothkey       -    For a given filtering technique, this variable
%                            holds a user-defined variable that tweaks the
%                            algorithm's effect.
%       trigs           -    A cell array containing names of all the
%                            triggers.
%   ONE OF THESE REQUIRED:
%       'average'       -    Use this flag to use a moving average to
%                            filter the dataset. In this case, smoothkey is
%                            used to deisgnate the number of values to
%                            average. It must be an even number as it takes
%                            (smoothkey/2) elements on either side of
%                            each point to average. Keep in mind that this
%                            causes an edge effect.
%       'median'        -    Use this flag to use a median to
%                            filter the dataset. In this case, smoothkey is
%                            used to deisgnate the number of values to
%                            take into account. It must be an even number as it takes
%                            (smoothkey/2) elements on either side of
%                            each point to find the middle. Keep in mind that this
%                            causes an edge effect.
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

    median_key = 0;
    average_key = 0;
    none = 0;
    if nargin > 3
        for i = 1:2:length(varargin)
            if strcmp(varargin{i}, 'median')    
                median_key = 1;
                none = 1;
            end
            
            if strcmp(varargin{i}, 'average')
                average_key = 1;
                none = 1;
            end
        end
        if none == 0
            error('Must supply atleast one acceptable argument.'); 
        end
    end
    
    trig_inds = [];
    for i = 1:length(trigs)
        trig_inds(i) = parse_trigs(PUPIL_EYE, trigs(i));
    end

    if average_key == 1
        PUPIL_FILTEYE = PUPIL_EYE;
        smoothnum = smoothkey;
        for k = 1:length(trig_inds)
            [tr, ~] = size(PUPIL_EYE.epochs{1,trig_inds(k)}.epochmat_pc(:,:));

            for i = 1:tr
                data = PUPIL_EYE.epochs{1,trig_inds(k)}.epochmat_pc(i,:);
                data_sm = data;
                for j = ((smoothnum/2)+1):(length(data_sm)-(smoothnum/2))
                    data_sm(j) = mean(data(j-(smoothnum/2):j+(smoothnum/2)));
                end
                PUPIL_FILTEYE.epochs{1,trig_inds(k)}.epochmat_pc(i,:) = data_sm;
            end
        end
    elseif median_key == 1
        PUPIL_FILTEYE = PUPIL_EYE;
        smoothnum = smoothkey; % only even numbers
        display(['Smoothing with median and ' sprintf('%.5f', smoothnum/2) ' as the key.']);
        for k = 1:length(trig_inds)
            [tr, ~] = size(PUPIL_EYE.epochs{1,trig_inds(k)}.epochmat_pc(:,:));
            
            for i = 1:tr
                data = PUPIL_EYE.epochs{1,trig_inds(k)}.epochmat_pc(i,:);
                data_sm = data;
                for j =((smoothnum/2)+1):(length(data_sm)-(smoothnum/2))
                    ind1 = (j-int32(smoothnum/2));
                    ind2 = (j+int32(smoothnum/2));
                    data_sm(1,int32(j)) = median(data(ind1:ind2));
                end
                PUPIL_FILTEYE.epochs{1,trig_inds(k)}.epochmat_pc(i,:) = data_sm;
            end
        end
    end
end

