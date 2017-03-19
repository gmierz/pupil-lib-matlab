'''
(*)~----------------------------------------------------------------------------------
 Pupil - eye tracking platform
 Copyright (C) 2012-2016  Pupil Labs
 Distributed under the terms of the GNU Lesser General Public License (LGPL v3.0).
 License details are in the file license.txt, distributed as part of this software.
----------------------------------------------------------------------------------~(*)
'''
import sys
import zmq
import calendar
import time
from plugin import Plugin
from pyglui.cygl.utils import draw_points_norm,RGBA
from pyglui import ui

def timestampChange(ip, port):
    ctx = zmq.Context()
    requester = ctx.socket(zmq.REQ)
    requester.connect('tcp://%s:%s'%(ip,port))

    requester.send('t')
    t = requester.recv()
    print('time:',t)

    tmp = 'T ';
    tmp1 = "{:10.7f}".format(time.time())
    print('Current UTC time:', tmp1)

    requester.send(tmp + "{:10.7f}".format(time.time()))
    resp = requester.recv()
    print('resp:',resp)

    requester.send('t')
    t = requester.recv()
    print('time:',t)

class Synch_Epochs(Plugin):
    """
    Change pupil epoch to UNIX timestamp for the sake of clarity.
    Make the change by loading this through the plugin list.
    """

    def __init__(self, g_pool):
        super(Synch_Epochs, self).__init__(g_pool)
        timestampChange('127.0.1.1', 50020);
