"""
    This file is used to run the server on the computer that is running a pupil capture instance.
    It needs to be provided two command line arguments, (1) the IP to run the server on (the IP of the computer you are
    running, and (2) the folder where the next recording session will be stored.

    It does a strong degree of error-checking but is still prone to unexpected problems.

    Given the folder from (2), it will save a new file called 'markers.p' which will contain information about the
    markers and also a file 'pupil_data_marked.p' that are to be used with 'marker_proc.py' for further pre-processing.

    Requirements:
        * Internet Connection (or an assigned IP). (Command line argument #1)
        * Folder that pupil data is saved in. (Command line argument #2)
        * Running instance of Pupil-Capture.
        * Pupil-Capture should be running at a 120Hz sampling, and have the following plugins running:
            - Pupil Remote: Gives access to the ZeroMQ instance.
            - Synch Epochs: Calibrates the timestamps to seconds from UNIX epoch, rather than time since PC startup
                            (as that time has no epoch that is defined, or saved, anywhere).
        * Run everything with |sudo|.
        * IMPORTANT: Be careful for read/write permissions, this program will modify them so that the data can be
          stored and also doesn't handle them extremely well.

    TODO:
        * Matlab timestamps are currently useless as they have an unknown offset for pupil timestamps. However,
          pupil timestamps are still precise within ~10 milliseconds and very good.
            * Implement a version of the prescision time protocol (PTP). Use this to set the clock in pupil labs to the
              clients time within microsecond accuracy also learning the offset and network latency.

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
"""

import socket
import sys
import os
import pickle
import numpy
import time
import stat

# Recording on linux
import zmq

ctx = zmq.Context()
requester = ctx.socket(zmq.REQ)
ip = '127.0.0.1'
port = 50020
requester.connect('tcp://%s:%s' % (ip, port))


def getGoodDir():
    ndirectory = raw_input('Path to pupil_data file: ')
    while (not os.path.isdir(directory)) or (not test_readAndWrite(directory)):
        print >> sys.stderr, 'Invalid directory, please enter a new one.'
        ndirectory = raw_input('Path to pupil_data file: ')
    return ndirectory


def strip_directory(dir):
    if dir.endswith('/'):
        print 'Stripping directory input of / at end.'
        dir = dir[:-1]


def test_readAndWrite(dir):
    print 'Testing read and write permissions...'
    print 'Writing to dummy file tmp_testrw.p...'
    tmp_testrw = {'timestamps' : ["TEST PASS"]}

    try:
        pickle.dump(tmp_testrw, open(dir + '/tmp_testrw.p', "wb"))
        print 'Wrote to directory.\n'

        try:
            print 'Reading from dummy file...'
            tmp_testrw2 = numpy.load(dir + '/tmp_testrw.p')
            print 'Read from dummy file.'
            print tmp_testrw2
            print ''
        except Exception as e:
            print 'ERROR: Cannot read from directory.'
            print str(e)
            return False

        print 'Permissions are clear for testing.\n'
        return True
    except Exception as e:
        print 'ERROR: Cannot write to directory.'
        print str(e)
        return False



# Directory to store the data in.
directory = sys.argv[2]
strip_directory(directory)

# IP or hostname of the computer running the server.
# The client must use this IP to connect.
# Using an ethernet connection between two computers (or locally),
# make sure that a local connection is established by changing IPv4
# settings to something like:
#     IP: 192.168.1.222
#     Netmask: 255.255.255.0
#     Gateway: 0.0.0.0
# Leave DNS settings alone, but turn off IPv6.
# The client will need to be configured with the same settings,
# except that it will use an IP like: 192.168.221
# The 222, and 221 endings can be changed to any other digit up to
# 255.
server_name = sys.argv[1]

# Dictionary that will contain the markers.
markers = []

# Create a TCP/IP socket.
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the address given on the command line.
server_address = (server_name, 10001)
print >> sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)
sock.listen(1)

if os.name != 'nt':
    sock.settimeout(60)

# Initialize some variables.
event = ''
timestamp = ''
order = ''
total = ''
totalChars = 24
timstamS = 18
evF = 21
orF = 24
pupil_ts = []
timeout_flag = 0

# Run the server
while 1:
    requester.send('R')
    requester.recv()
    time.sleep(5)

    print ' '
    print 'Checking if directory exists...'
    # Make sure that the directory is good.
    while not os.path.isdir(directory):
        print 'Invalid directory, please enter a new one.'
        directory = raw_input('New path to recording directory: ')
    print 'Directory exists.\n'

    while not test_readAndWrite(directory):
        print 'Cannot read or write to the directory.'
        directory = raw_input('New path to recording directory: ')

    # Get a connection
    print >> sys.stderr, 'Waiting for a connection'
    connection, client_address = sock.accept()

    # Get the marker data
    try:
        print >> sys.stderr, 'Client connected:', client_address

        while 1:
            tmp = connection.recv(totalChars)
            if len(tmp) == 0:
                timeout_flag = 1
                break
            print >> sys.stderr, tmp
            if tmp[timstamS:evF] == 'end':
                total = tmp

                requester.send('t')
                pts = requester.recv()
                markers.append(total)
                pupil_ts.append(pts)
                break
            else:
                total = tmp

                requester.send('t')
                pts = requester.recv()
                markers.append(total)
                pupil_ts.append(pts)

                # Useful for testing
                # if data:
                #     connection.sendall(data)
                # else:
                #     break
    finally:
        if timeout_flag:
            print 'Timeout on the client end, saving what data we have.'
            time.sleep(10)
            requester.send('r')
            time.sleep(30)
            break
        else:
            connection.close()

    if tmp[timstamS:evF] == 'end':
        time.sleep(10)
        requester.send('r')
        time.sleep(30)
    elif timeout_flag:
        break

    if total[timstamS:evF] == 'end':
        break

print >> sys.stderr, '\nAll markers: '
print >> sys.stderr, markers

# Post-run processing
processed = {'timestamps': [], 'name': [], 'order': [], 'pupil_ts': []}
for val in markers:
    processed['timestamps'].append(float(val[:timstamS]))
    processed['name'].append(val[timstamS:evF])
    processed['order'].append(val[evF:orF])
processed['pupil_ts'] = pupil_ts

print >> sys.stderr, '\nProcessed markers: '
print >> sys.stderr, processed

print >> sys.stderr, ' '
print >> sys.stderr, 'Saving markers in <PATH>\markers.p ...'

# Save the marker data.
new_directory = directory + '/markers.p'
bad_flag = 1
while bad_flag == 1:
    try:
        pickle.dump(processed, open(new_directory, "wb"))
        bad_flag = 0
    except IOError:
        print 'Invalid directory, no read or write permissions.'
        directory = getGoodDir()