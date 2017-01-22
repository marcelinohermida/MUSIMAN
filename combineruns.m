% ************************************************************************
% MUSIMAN (MUltiple SImulations MAnagement)
% combineruns
% v 1.0
% Automated combination of results of multiple independent simulations runs
%
% Written with Matlab R2014 64 bits for Windows 
%
% Marcelino Hermida-López - Jan 2017
%
% Usage:
% It prepares the dumps_file.txt with the paths of the dump files, to 
% be combined using the utility penmain_sum.f included in PENELOPE 2014.
% The combineruns file must be in the parent folder of the
% simulation runs folders.
% 
% To create executable, type:
%    mcc -m combineruns.m
% in the Matlab command window.
% To use the executable in other computer it is necessary that Matlab
% or the Matlab Compiler Runtime (MCR) are installed.
% The MCR must be the one included with the Matlab version used
% to compile the executable to avoid compatibility issues.
% ************************************************************************

clc;

disp(' ')
disp(' combineruns v 1.0')
disp([' Automated combination of results of multiple independent ' ...
    'simulation runs (Marcelino Hermida - Jan 2017)'])
disp([' ------------------------------------------------------------' ...
     '---------------------------------------------'])
disp(' ')

NumberOfRunsStart = input(' Number of the FIRST run to be combined? [1] ');
if isempty(NumberOfRunsStart)
    NumberOfRunsStart = 1;
end
NumberOfRunsEnd = input(' Number of the LAST run to be combined? ');

MainFolder=cd
fileID = fopen('dumps_file.dat','w');
mkdir('RESULTS');
ResultsFolder=[MainFolder, '\RESULTS'];
copyfile('penmain-sum_MH.exe',ResultsFolder);


% Loop over the run folders to search dump files
for i=NumberOfRunsStart:NumberOfRunsEnd
    if (i<10)
        folder=strcat(MainFolder, '\', SimulationFolder, '_run0', ...
            num2str(i));
        cd(folder);
        DumpFile=['dump0', num2str(i), '.dmp'];
        copyfile(DumpFile, ResultsFolder);
        fprintf(fileID,'%s\n', DumpFile);
    else
        folder=strcat(MainFolder, '\', SimulationFolder, '_run', ...
            num2str(i));
        cd(folder);
        DumpFile=['dump', num2str(i), '.dmp'];
        copyfile(DumpFile, ResultsFolder);
        fprintf(fileID,'%s\n', DumpFile);
    end
    
end

cd (MainFolder);
copyfile('dumps_file.dat',ResultsFolder);
cd (ResultsFolder);


% Opens command window and starts combination of dump files
    StartCombination=strcat('penmain-sum_MH.exe < dumps_file.dat');
    dos (StartCombination);         
    delete('*.dmp')
    
fclose(fileID);
cd (MainFolder);
delete('dumps_file.dat');
disp('All dumps combined. Check RESULTS folder. Back to the main folder.');
disp('END OF PROGRAM');
