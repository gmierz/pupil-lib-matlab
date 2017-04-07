function PUPIL_EPOCHED = pupil_epoch(PUPIL, trigs, trial_range, varargin)
% This function is used to epoch the pupil data and this must be done
% before any other processing can be done on the dataset.
% #pupil_epocheye# is called and used to epoch the data in each eye.
%
% REQUIRED INPUT:
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
%  'epochsize'  - This argument can be used to change the size of the
%                 epochs that are output within epochmat* fields.
%                 Essentially, it changes the size that al the epochs
%                 will be be resized to. 200 is used by default so that
%                 the data can be easily compared with the processed
%                 EEG ERSP data obtained from eeglab.
%
%  TODO: 
%   * Accept baseline_range as array to make baseline area more
%     flexible.
%   * Figure out whether or not rest_mean needs to be trial specific or
%     if we can use them from across entire trigger trials.
%
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
    erratics = 0;
    baseline_range = 0;
    tolerance = 0;
    view = 0;
    addto = 0;
    epochsize = 200;

    % Optional argument processing & error checking.
    if nargin > 3
        for i = 1:2:length(varargin)
            if strcmp(varargin{i}, 'baseline')    
                baseline = 1;
                baseline_range = varargin{i+1};
            end
            
            if strcmp(varargin{i}, 'erratic')
                erratics = 1;
                tolerance = varargin{i+1};
            end
            
            if strcmp(varargin{i}, 'view')
                view = 1; 
            end
            
            if strcmp(varargin{i}, 'add')
                addto = 1; 
            end
            
            if strcmp(varargin{i}, 'epochsize')
               epochsize = varargin{i+1}; 
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
    
    % Store epochs
    currepochnum = 0;
    
    % Add to the end of the existing set, and set currepochnum to the
    % spacing. Otherwise, just throw the epochs into the new PUPIL_EPOCHED
    % dataset.
    if addto == 1
        
        % Assuming there are the same number of trials for both eyes,
        % and at this point if there are not, a problem occured.
        currepochnum = size(PUPIL.eye0.epochs,2);
        PUPIL_EPOCHED = PUPIL;

        % Add epochs to existing set
        for k = (currepochnum+1):(currepochnum+trig_count-1)
            PUPIL_EPOCHED.eye0.epochs{1,k} = trig_epochs.eye0{k-currepochnum};
            PUPIL_EPOCHED.eye1.epochs{1,k} = trig_epochs.eye1{k-currepochnum};
        end

        for k = (currepochnum+1):(currepochnum+trig_count-1)
            for l = 1:30
                PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1} = imresize(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}, [epochsize 1]);
                PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1} = imresize(PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}, [epochsize 1]);
            end
        end
    else
        PUPIL_EPOCHED = PUPIL;
        PUPIL_EPOCHED.eye0.epochs = trig_epochs.eye0;
        PUPIL_EPOCHED.eye1.epochs = trig_epochs.eye1;
    end
    
    % Resize all epochs to the same size as EEG epochs for easier
    % comparisons (i.e. to a sampling rate of 33Hz). 
    for k = (1+currepochnum):((trig_count-1)+currepochnum)
        for l = 1:size(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs, 1)
            temp_ts0 = PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.times;
            temp_ts1 = PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.times;
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.times = zeros(1,epochsize);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.times = zeros(1,epochsize);
            
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.times(1) = temp_ts0(1);
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.times(end) = temp_ts0(end);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.times(1) = temp_ts1(1);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.times(end) = temp_ts1(end);
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.data = imresize(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.data, [epochsize 1]);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.data = imresize(PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.data, [epochsize 1]);
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.times(2:end-1) = imresize(temp_ts0(2:end-1), [epochsize-2 1]);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.times(2:end-1) = imresize(temp_ts1(2:end-1), [epochsize-2 1]);
        end
    end

    % Post-processing the datasets.
    for k = (1+currepochnum):((trig_count-1)+currepochnum)
        % Remove erratics before continuing (only if 'erratics' is set). 
        epoch_size = size(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs, 1);
        display(epoch_size);
        if erratics == 1
            PUPIL_EPOCHED = pupil_rmerratic(PUPIL_EPOCHED,k,tolerance);
            PUPIL_EPOCHED = pupil_rmerratic(PUPIL_EPOCHED,k,tolerance);
        end
        display(k)
        % Produce a matrix of the epoch data across all epochs. 
        epoch_size = size(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs, 1);
        
        display(epoch_size)
        PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat = ... 
            zeros(epoch_size, length(PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{1,1}.data));
        
        for l = 1:epoch_size
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat(l,:) = ...
                                     PUPIL_EPOCHED.eye0.epochs{1,k}.epochs{l,1}.data;
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat(l,:) = ...
                                     PUPIL_EPOCHED.eye1.epochs{1,k}.epochs{l,1}.data;
        end
        
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
        
        % Processing for baseline removal, & percent change, set 'baseline' to use.
        if baseline == 1
            PUPIL_EPOCHED.eye0.epochs{1,k}.baseline_time = baseline_range;            
            
            % Determine index that corresponds to trial center (or baseline
            % beginning).
            baseline_end = floor((size(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat,2)/total_time))*baseline_range;
            display('baseline_end:');
            display(baseline_end);
            
            % Store the baseline index
            PUPIL_EPOCHED.eye0.epochs{1,k}.baseline_ind = baseline_end;
            PUPIL_EPOCHED.eye1.epochs{1,k}.baseline_ind = baseline_end;
            
            % Remove the baseline and get the rest mean for each set of
            % trigger.
            [PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_rmb(:,:), ...
             PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, 1, baseline_end);
            
            [PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_rmb(:,:), ... 
             PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean] = pupil_rmbaselineeye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, 1, baseline_end);
            
            % Calculate the percent change graph.
            PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat_pc(:,:) = ...
                pupil_datapercenteye(PUPIL_EPOCHED.eye0.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye0.epochs{1,k}.rest_mean);
            PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat_pc(:,:) = ...
                pupil_datapercenteye(PUPIL_EPOCHED.eye1.epochs{1,k}.epochmat, PUPIL_EPOCHED.eye1.epochs{1,k}.rest_mean);
        end
    end
    
    % If 'view' is set, display the epochs per trigger.
    if view == 1
        pupil_viewepochs(PUPIL_EPOCHED);
    end
end