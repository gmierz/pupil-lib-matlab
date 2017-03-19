Pupil-Lib Data Segmentation Library

Currently, this library can be used by running a Pupil Labs binocular eye tracker alongside the server and client implemented in the 'server_client' folder. At the same time, you can run a visual stimulus using Matlab and send event markers to the server from there using the client. These can later be used to segment the data obtained from the eye trackers into trials with the Pupil-Lib library.

There is only a Matlab version of the library so far but a Python version is nearly complete and should be done before fall 2017. The server is implemented in Python and works very well with Pupil Capture. To make it work properly, 'synch_epochs.py' will need to be added to the 'pupil_capture_settings/plugins' directory and loaded in Pupil Capture during start up. This gives us access to timestamps that have a known epoch.

The client that is used does not necessarily need to be the one defined in 'server_client' but can be easily implemented in other languages for use in other stimulation modes. It just needs to send data which has the exact same size, 17 characters for the timestamps (including the '.'), 3 for the name, and 3 for the order for a total of 23 digits. 

TODO:
	* Use other forms of data other than just 3D pupil diameter.
	* Finish Python version of the library.
	* Decrease server-client synchronization error (currently ~10 milliseconds which is more than enough).
	* Complete testing implementation.
	* Complete viewer implementation.
