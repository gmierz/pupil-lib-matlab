function [ test_info ] = test_fakedata(PUPIL)
%TEST_FAKEDATA Summary of this function goes here
%   Detailed explanation goes here
    try
        % Create initial base data and markers
        test_data = zeros(1,50000);
        test_data(:) = 5;
        test_markers = [1:50000];

        % Create fake markers, marker names,
        % and data changes.
        markers = [];
        marker_names = {};
        count = 1;
        for i = 1000:1000:45000
            % Get marker info
            markers(count) = i;
            marker_names{count} = 'S11';
            count = count + 1;

            % Make the fake changes for 500 points.
            test_data(i:(i+499)) = 10;
        end
        
        % Load a real PUPIL data structure with the fake data.
        PUPIL.eye0.data = test_data';
        PUPIL.eye1.data = test_data';
        PUPIL.eye0.timestamps = test_markers';
        PUPIL.eye1.timestamps = test_markers';
        PUPIL.markers.timestamps = markers';
        PUPIL.markers.eventnames = marker_names';

        % Recalculate the sampling rate and perform the segmentation.
        PUPIL.eye0.srate = pupil_srate(PUPIL.eye0.data, PUPIL.eye0.timestamps);
        PUPIL.eye1.srate = pupil_srate(PUPIL.eye1.data, PUPIL.eye1.timestamps);
        PUPIL_NEW = pupil_epoch(PUPIL, {'S11'}, [-100 600], 'baseline', 100, 'epochsize', 200);

        % Display the epoched data that was resized.
        % Note that there will be artifacts left over because of
        % the sharp changes in data that occur. This is just to ensure
        % that we actually have a percent change representation.
        figure;
        plot(squeeze(mean(PUPIL_NEW.eye0.epochs{1,1}.epochmat_pc,1)),'b');
        hold on;

        % Display the raw epochs.
        % This should display as a single line if the segmentation process
        % went correctly. Furthermore, there should be 100 points before
        % the start of the changes, 500 points of change, then 100 points
        % of no change.
        figure; hold on;
        for i = 1:length(markers)
            plot(PUPIL_NEW.eye0.epochs{1,1}.epochs{i,1}.data_orig);
        end
    catch err
        % Display the error
        display(err);
        display(err.message);
        display(err.identifier);
        test_info = 'failed';
    end
end

