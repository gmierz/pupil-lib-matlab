% Use with CAUTION, a feature was added to #pupil_epochs# through the 'add'
% flag to add epochs into a given set instead of erasing them during the
% epoching phase. Soon, this file will be removed.
%
function PUPIL_EPOCHED = pupil_addepochs(PUPIL, trigs, trial_range, varargin)
% This function is used to epoch the pupil data and this must be done
% before any other processing can be done on the dataset. It does the
% same thing as #pupil_epoch#, except that it adds new epochs to an
% existing dataset from the same raw data.
% #pupil_epocheye# is called and used to epoch the data in each eye.
%
% INPUT:
%   PUPIL       - The raw pupil data.
%   trigs       - Cell array containing strings with names of the triggers.
%                 The epochs will be returned in the same order as these
%                 triggers.
%   trial_range - The time range over which each epoch lives. It
%                 expects at least one number and at most 2. The first number is the
%                 start of the trial (negative numbers signify a baseline) and the
%                 second number is the end of the trial. If you use only one number
%                 it assumes there is no baseline time.
%
% OPTIONAL:
%  'baseline'   - Removes the baseline (rest mean) from all
%                 measurements. Second argument is needed to determine 
%                 how many of the first seconds is needed as a baseline.
%                 Please note that a percent change field will not be
%                 given if there is no baseline (as that is the only
%                 way to calculate percent change).
%  'erratic'    - Removes all epochs which have timesamples that are
%                 spaced at a distance greater than the argument
%                 provided (in seconds).
%  'view'       - This argument takes anything as it's second argument
%                 (0 or 1) and if set/used will display figures that
%                 show the epochs for each of the triggers.
% OUTPUT:
%  PUPIL_EPOCHED- This is the resulting dataset. 
%
%  TODO: 
%   * Accept baseline_range as array to make baseline area more
%     flexible.
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
    
    baseline = 0;
    baseline_range = 0;
    erratics = 0;
    view = 0;
    
    if nargin > 3
        for i = 1:2:length(varargin)
            if strcmp(varargin{i}, 'baseline')    
                baseline = 1;
                baseline_range = varargin{i+1};
            end
            
            if strcmp(varargin{i}, 'erratic')
                erratics = 1; 
            end
            
            if strcmp(varargin{i}, 'view')
                view = 1; 
            end
        end
    end

    if isempty(trigs) 
        error('More than one trigger name needs to be entered for the "trigs" parameter.'); 
    end
    
    if isempty(trial_range) || length(trial_range) > 2
        error('Trial range must contain one or two values.');
    end
    
    % For simplicity
    markers_names = PUPIL.markers.eventnames;
    markers_times = PUPIL.markers.timestamps;

    % Initialize containers
    trig_count = 1;
    trig_epochs = struct;
    trig_epochs.eye0 = {};
    trig_epochs.eye1 = {};
    
        % For each given trigger
    for i = 1:length(trigs)
        display(['Processing epochs for ' trigs{i} '...']);
        % Get trigger marker timestamps
        inds = strcmp([markers_names(:)], trigs{i});
        proc_mtimes = markers_times(inds);
        
        display(['Found ' int2str(length(proc_mtimes)) ' trials.']);
        
        if isempty(proc_mtimes)
            error(['Could not find any trials for the event named: ' trigs{i}]);
        end
        
        % Initialize
        trig_epochs.eye0{trig_count} = struct;
        trig_epochs.eye1{trig_count} = struct;
        
        % Epoch each eye's data
        display([trigs{i} ': Getting epochs for eye0...']);
        trig_epochs.eye0{trig_count}.epochs = pupil_epocheye(PUPIL.eye0.data, ...
                                                PUPIL.eye0.timestamps, ...
                                                PUPIL.eye0.srate, proc_mtimes, ...
                                                trial_range);

        display([trigs{i} ': Getting epochs for eye1...']);
        trig_epochs.eye1{trig_count}.epochs = pupil_epocheye(PUPIL.eye1.data, ...
                                                PUPIL.eye1.timestamps, ...
                                                PUPIL.eye1.srate, proc_mtimes, ...
                                                trial_range);
        
        % Keep the trigger name
        trig_epochs.eye0{trig_count}.name = trigs(i);
        trig_epochs.eye1{trig_count}.name = trigs(i);

        trig_count = trig_count + 1;
        display(' ');
    end % end for
    
    currepochnum = size(PUPIL.eye0.epochs,2);
    PUPIL_EPOCHED = PUPIL;
    % Add epochs to existing set
    for k = (currepochnum+1):(currepochnum+trig_count-1)
        PUPIL_EPOCHED.eye0.epochs{1,k} = trig_epochs.eye0{k-currepochnum};
        PUPIL_EPOCHED.eye1.epochs{1,k} = trig_epochs.eye1{k-currepochnum};
    end
    
    for k = (currepochnum+1):(currepochnum+trig_count-1)
        for l = 1:30
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1} = imresize(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}, [200 1]);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1} = imresize(PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}, [200 1]);
        end
    end
    
    for k = (currepochnum+1):(currepochnum+trig_count-1)
        if erratics == 1
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs = pupil_rmerraticeye(PUPIL,eye0.epochs{1,k}.epochs);
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs = pupil_rmerraticeye(PUPIL,eye0.epochs{1,k}.epochs);
        end
        
        PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat(:,:) = ...
                                 [PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{:,1}];
        PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat(:,:) = ...
                                 [PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{:,1}];
        
        % Get the total "ideal" time of the trials
        total_time = 0;
        if length(trial_range) == 2
            total_time = trial_range(2) - trial_range(1); 
            PUPIL_EPOCHED.eye0.epochs{1,k}.trial_time = trial_range(2);
        else
            total_time = trial_range(1);
            PUPIL_EPOCHED.eye0.epochs{1,k}.trial_time = total_time;
        end
        PUPIL_EPOCHED.eye0.epochs{1,k}.time = total_time;
        
        if baseline == 1
            PUPIL_EPOCHED.eye0.epochs{1,k}.baseline_time = baseline_range;
            
            baseline_end = floor((size(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat,1)/total_time))*baseline_range;
            display('baseline_end:');
            display(baseline_end);
            [PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_rmb(:,:), ...
             PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, 1, baseline_end);
            
            [PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_rmb(:,:), ... 
             PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, 1, baseline_end);
            
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_pc(:,:) = ...
                pupil_datapercenteye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_pc(:,:) = ...
                pupil_datapercenteye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean);
        end
    end
    
    if view == 1
        pupil_viewepochs(PUPIL_EPOCHED); 
    end
end