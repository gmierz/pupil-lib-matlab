'''
     This file is used to process the data after an experiment has been run with the eye tracker and
     the server running simultaneously for marker gathering. It breaks down the pupil_data file into 4
     '.csv' files, 2 for each eye, one for data and one for timestamps. The markers are also broken down
     into three files that separate the timestamps from the names and orders. Once this file is run, the
     data can be used in Pupil-Lib to be further processed.
     
     Requirements:
          * It accepts a single command-line argument for 'pupil_dir' that is the directory containg
            the data to be processed. That directory must contain the files 'pupil_data.p', and
            'markers.py'.

     Author: Gregory Mierzwinski, Sherbrooke, QC, 03/19/2017

     Copyright (C) Gregory Mierzwinski, gmierz1@live.ca

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'''
# coding=utf-8
import pickle
import numpy as np
from matplotlib import pyplot as p
from matplotlib import dates as dt
from datetime import datetime, timedelta
import sys
import time

pupil_dir = sys.argv[1];

def markerFieldCSV(path, field):
	# open the pickled file
	# replace with your path to pupil_data
	if sys.version_info >= (3, 0):
		markers = pickle.load(open(path + "markers.p","rb"),encoding='latin1') 
	else:
		markers = pickle.load(open(path + "markers.p","rb"))

	# to export pupil diameter in millimeters to a .csv file with timestamps frame numbers and timestamps
	# as correlated columns  you can do the following:
	# diameter is only in mm if 3d pupil detector is used,
	# otherwise it is in pixels and not corrected for perspective.
	filtered_markers_ts = []
	for i in range(0, len(markers[field])):
		if field in {'pupil_ts'}:
			filtered_markers_ts.append([float(markers[field][i])])
			#print 'original'
			#print time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(float(markers[field][i])))
		elif field in {'timestamps'}:
			tmp = float(markers[field][i])
			#print tmp
			#print time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(float(tmp)))
			filtered_markers_ts.append(tmp)
		else:
			filtered_markers_ts.append([markers[field][i]])

	if field in {'pupil_ts'}:
		np.savetxt(path + "markers_ts.csv",filtered_markers_ts,delimiter=",",comments="")
	elif field in {'timestamps'}:
		np.savetxt(path + "markers_matlab_ts.csv", filtered_markers_ts, delimiter=",", comments="")
	elif field in {'name'}:
		np.savetxt(path + "markers_evnames.csv",filtered_markers_ts,delimiter=",",comments="",fmt="%s")
	else:
		np.savetxt(path + "markers_ords.csv",filtered_markers_ts,delimiter=",",comments="",fmt="%s")

	return filtered_markers_ts

# Get marker entries
# Fields: timestamps, name, order
markmatlabTS = markerFieldCSV(pupil_dir, 'timestamps')
sq_markmatlabTS = np.squeeze(markmatlabTS)

markTS = markerFieldCSV(pupil_dir, 'pupil_ts')
sq_markTS = np.squeeze(markTS)

namesTS = markerFieldCSV(pupil_dir, 'name')
sq_namesTS = np.squeeze(namesTS)

print(sq_namesTS)

# Open the data stream
pupil_data = pickle.load(open(pupil_dir + "pupil_data","rb"))
pupil_positions = pupil_data['pupil_positions']
print(pupil_positions[0]['timestamp'])

filtered_pupil_positions = []

# Get filtered pupil data with 3d diameter
header = ['timestamp','diameter_3d', 'id']
header_str = ','.join(header)
for i in pupil_positions:
	filtered_pupil_positions.append([i[v] for v in header])



### Eye 1 proc ###################################################

# Filter pupil_positions into 3 data sets for use later
# Only doing eye 1 now.
filtered_pupil_positions0 = [];
filtered_pupil_positions0d = [];
filtered_pupil_positions0ts = []; 
for i in filtered_pupil_positions:
	if i[2] == 1:
		filtered_pupil_positions0d.append({'timestamp': i[0], 'diameter': i[1]});
		filtered_pupil_positions0.append(i[1]);
		filtered_pupil_positions0ts.append(i[0]);

np.savetxt(pupil_dir + "pupil_eye1_diams.csv",filtered_pupil_positions0,delimiter=",",comments="")
np.savetxt(pupil_dir + "pupil_eye1_ts.csv",filtered_pupil_positions0ts,delimiter=",",comments="")



#### Eye 0 proc ###################################################

# Filter pupil_positions into 3 data sets for use later
# Only doing eye 1 now.
filtered_pupil_positions0 = [];
filtered_pupil_positions0d = [];
filtered_pupil_positions0ts = []; 
for i in filtered_pupil_positions:
	if i[2] == 0:
		filtered_pupil_positions0d.append({'timestamp': i[0], 'diameter': i[1]});
		filtered_pupil_positions0.append(i[1]);
		filtered_pupil_positions0ts.append(i[0]);

np.savetxt(pupil_dir + "pupil_eye0_diams.csv",filtered_pupil_positions0,delimiter=",",comments="")
np.savetxt(pupil_dir + "pupil_eye0_ts.csv",filtered_pupil_positions0ts,delimiter=",",comments="")