% ----------------------------------------------------------------------
% combineruns
% v 0.1
% Automated combination of results of multiple independent simulations runs
% Marcelino Hermida - March 2016
%
% Usage:
% It prepares the dumps_file.txt with the paths of the dump files, to 
% be combined usind the utility penmain_sum.f included in PENELOPE 2014
% The combineruns.exe file must be in the parent folder of the
% simulation runs folders.
% -----------------------------------------------------------------------

clc;

disp(' ')
disp(' Automated combination of results of multiple independent simulation runs (Marcelino Hermida - March 2016)')
disp(' ---------------------------------------------------------------------------------------------------------')
disp(' ')

NumberOfRunsStart = input(' Number of the FIRST run to be combined? [1] ');
if isempty(NumberOfRunsStart)
    NumberOfRunsStart = 1;
end
NumberOfRunsEnd = input(' Number of the LAST run to be combined? ');

load;           % loads matlab.mat
MainFolder=cd
fileID = fopen('dumps_file.dat','w');
mkdir('RESULTS');
ResultsFolder=[MainFolder, '\RESULTS'];
copyfile('penmain-sum_MH.exe',ResultsFolder);


% Loop over the run folders to search dump files
for i=NumberOfRunsStart:NumberOfRunsEnd
    if (i<10)
        folder=strcat(MainFolder, '\', SimulationFolder, '_run0', num2str(i));
        cd(folder);
        DumpFile=['dump0', num2str(i), '.dmp'];
        copyfile(DumpFile, ResultsFolder);
        fprintf(fileID,'%s\n', DumpFile);
    else
        folder=strcat(MainFolder, '\', SimulationFolder, '_run', num2str(i));
        cd(folder);
        DumpFile=['dump', num2str(i), '.dmp'];
        copyfile(DumpFile, ResultsFolder);
        fprintf(fileID,'%s\n', DumpFile);
    end
    
end

cd (MainFolder);
copyfile('dumps_file.dat',ResultsFolder);
cd (ResultsFolder);


% Opens command window and starts simulation in background
    StartCombination=strcat('penmain-sum_MH.exe < dumps_file.dat');
    dos (StartCombination);         
    delete('*.dmp')
    
fclose(fileID);
cd (MainFolder);
disp('All dumps combined. Check RESULTS folder. Back to the main folder.');
disp('END OF PROGRAM');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    