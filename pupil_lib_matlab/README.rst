Pupil-Lib
----------

Look in the docs folder for more information about this libraray and 
how to use it. The code is also commented with more information about how
something works in more detail.

This library processes data that was obtained from a Pupil Labs eye tracker
alongside the data obtained from the server-client pairing that produces
the markers. It's purpose is to break the pupil data down into trials that
are centered around the markers. For example, given a marker, we can take 
-1 seconds of data before the marker and 5 seconds after the marker and 
then call that a trial. Furthermore, if we supply an argument that tells us
how much of a baseline we have, then we can produce two extra datasets that
have the baseline average removed, and another where is point becomes a
percent change in diameter relative to a baseline mean.

Right now, this library can only be used for data that is from a binocular
eye tracker. This feature is in progress. Another couple features in progress
are having the server-client pair synchronize to within a microsecond 
accuracy using the Precision Time Protocol, and allowing the use of negative
trial start (baseline), and negative trial end times concurrently.