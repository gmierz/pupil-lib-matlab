# Pupil-Lib Data Segmentation Library

Currently, this library can be used by running a Pupil Labs binocular eye tracker alongside the server and client implemented in the 'server_client' folder. At the same time, you can run a visual stimulus using Matlab and send event markers to the server from there using the client. These can later be used to segment the data obtained from the eye trackers into trials with the Pupil-Lib library.

There is only a Matlab version of the library so far but a Python version is nearly complete and should be done before fall 2017. The server is implemented in Python and works very well with Pupil Capture. To make it work properly, 'synch_epochs.py' will need to be added to the 'pupil_capture_settings/plugins' directory and loaded in Pupil Capture during start up. This gives us access to timestamps that have a known epoch.

The client that is used does not necessarily need to be the one defined in 'server_client' but can be easily implemented in other languages for use in other stimulation modes. It just needs to send data which has the exact same size, 17 characters for the timestamps (including the '.'), 3 for the name, and 3 for the order for a total of 23 digits. 

This library is now compatible with XDF data obtained from the use of the Pupil Labs LSL plugin and a marker outlet (from the 'server_client' folder) running in matlab (or others as needed). The XDF data can be loaded with the 'load_xdf' argument in the 'pupil_load' function.

## Dependencies:
	* Pupil Labs binocular eye tracker: https://pupil-labs.com/ .
	* Lab Streaming Library (LSL): https://code.google.com/archive/p/labstreaminglayer/ . The version contained in 'liblsl-1.04.zip' in the downloads page is known to work with the Matlab marker inlet function.
	* LabRecorder: ftp://sccn.ucsd.edu/pub/software/LSL/Apps/ . This version contained in 'LabRecorder-1.12c.zip' is known to work with the Pupil Labs eye tracker and produces compatible XDF files.
	* Pupil Labs LSL Plugin: https://pupil-labs.com/blog/2016-11/pupil-plugin-for-lab-streaming-layer/ . Follow their instructions to get it working. I had to use the source code in the Lab Streaming Library repo to be able to properly produce the 'pylsl' folder. What helped the most here was running the script 'get_deps.py' which will fill the 'pylsl' folder with needed files. This can be done before or after the 'build' phase. 

TODO:
	* Use other forms of data other than just 3D pupil diameter.
	* Finish Python version of the library.
	* Complete testing implementation.
	* Complete viewer implementation.
	
Feel free to mention any other features that should be added or are needed and let me know if you find any bugs by using the Github issues page. You can also mention that you are using it in that page or by e-mailing me.

Also, feel free to contact me if there are any questions about the library.
