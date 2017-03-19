Core
-----

This folder is where the core functions are core functionality of the
library lies and where all the processing begins. After data is loaded into
a pupil data set using #pupil_load#, the function #pupil_epoch# can be used
to break the data down into trials of a specified length. The processs 
generally proceeds as follows and it is done exactly the same for each eye. 

First, we find all the indices defined by a given marker and use those to
obtain the timestamps. Then, we use those timestamps to epoch each eye with
#pupil_epocheye#. This function will find the timestamp in the pupil data 
that is closest to the each markers timestamp, or with a minimized error, 
and use these to center the trial cut in the function #pupil_cutout#. 

In there, we determine the index which corresponds to the baseline time and
trial time by walking the data to the left or right of the
time series depending on the signs of the times that were given. This uses
the functions #getlefttime#, and #getrighttime# - found in the 'inners' 
folder - that also use #pupil_getclosestpoint# to find the points that are 
closest to the optimal time given. 

Once those are found, using #linear_approx# from the 'inners' folder, a 
linear approximation is performed to turn the epochs length into 
an exact length by either appending an extra point or replacing
a point - depending on whether we under-estimate or over-estimate 
respectively, with the function #pupil_getclosestpoint#.

These steps are repeated for each trigger name that is given and for each
eye and once it is complete, the data is epoched into trial sets that have
differing lengths because the data is unevenly-spaced. That being said,
there is an option that allows epochs with spacings that are too large to be
excluded. The spacing is relatively constant in most of the datasets if a good
tolerance for removing highly erraticly spaced data is chosen - I tend to use
0.045 seconds but going down lower if there is a high sampling rate is
definitely possible.

Once the datasets have been produced, there is an optional step which can
append new triggers to an existing dataset that can be activated by using
the 'addto' argument in #pupil_epoch#. If it is not specified it will 
overwrite the 'epochs' field in the given PUPIL dataset.

At this point, if the 'view' flag is set, the program will display each
set of epochs for each trigger for each trial. The #pupil_view# function is
used for this. 

After this, each epoch for each trigger for each eye is interpolated to a new
size so that they are all equal in length for easier comparison. This size
can be set by using the 'epochsize' parameter in #pupil_epoch#. By default,
it is set to interpolate all the epochs to a size of 200 data points - mainly
for an easier time comparing the pupil data with EEG ERSP data from EEGLAB.
For this interpolation, the function #imresize# is used.

Once the trials have all been resized, they can be concatenated into a M X N
matrix, where M is the number of epochs, and N is the number of data points
in each epoch. This is done with the function #make_epochmat#. If the
'baseline' argument is set to an integer, that integer will next be used to
determine the amount of time that will be used as a baseline and this is
calculated using the function #make_rmb_pc_mats# which will also produce
matrices that have data with the baseline removed and another which has each
point represent a pupil diameter percent change relative to the baseline
mean. Both of the function can be found in the 'inners' folder.

Once the matrices are produced, this is the end of the epoching and also the
end of the #pupil_epoch# function run. The trial lengths can now be tested using
the function #test_epochsize# in the tests folder.

The function #pupil_mergesets# can be used for group-based analysis and it
can merge two pupil-lib datasets together, and builds up new epoch matrices
for analysis. Please note that the data from each original dataset is held
in the merged dataset so it may be that this dataset becomes RAM-hungry. If
that is the case, let me know and this can be changed very quickly. I do not
know what would be more useful more users in this case. So far, I have found
that the program continues to perform very well when I have 6 datasets with
720 trials in total merged together.

The final function is #pupil_filt# which can filter the epochs with either
an averaging or median filter. The arguments must be even integers for the 
filter function to work as this function hasn't been fully optimized yet.

The folder 'viewer' currently contains nothing but will have functions for
making it easier to view the data and trials.

Currently, the library is in the final phase of testing.
