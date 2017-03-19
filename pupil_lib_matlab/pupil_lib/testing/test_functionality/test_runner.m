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

%{
  Use this function to run through the tests defined the the 'tests'
  folder. Change the folder variable as needed. This is a very simple
  implementation of a test runner as this library requires minimal testing
  due to it's size.
%}


% Change the folder variable to the local folder
folder  = 'C:\Users\Gregory\Documents\Honors_Thesis\scripts\pupil_lib\tests\test_functionality\tests';
list    = dir(fullfile(folder, '*.m'));
nFile   = length(list);
success = false(1, nFile);
failed = false;

% Iterate through each scripted test
for k = 1:nFile
  file = list(k).name;
  try
    run(fullfile(folder, file));
    success(k) = true;
  catch lasterror
    fprintf('TEST-FAILED: %s\n', file);
    fprintf('TEST-FAIL-LOG: %s\n', lasterror);
    failed = true;
  end
end

% Display pass or fail
if ~failed
    display('All tests passed!');
else
    display('TESTS-FAILED: Errors found while testing. See log above for details.');
end