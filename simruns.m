% ************************************************************************
% MUSIMAN (MUltiple SImulations MAnagement)
% simruns
% v 1.0
% Automatic start of multiple simulation runs
%
% Written with Matlab R2014 64 bits for Windows 
%
% Marcelino Hermida-López - Jan 2017
%
% Usage:
% The multiple simulation runs must be in separate folders. The name of
% the folders must finish with "\runXX", with XX the run number.
% The program simruns must be located in the parent folder that contains
% the folders of the simulations.
% 
% To create executable, type:
%    mcc -m simruns.m
% in the Matlab command window.
% To use the executable in other computer it is necessary that Matlab
% or the Matlab Compiler Runtime (MCR) are installed.
% The MCR must be the one included with the Matlab version used
% to compile the executable to avoid compatibility issues.
% ************************************************************************

clc;
% fileID = fopen('simruns.out','w');
disp(' ')
disp(' simruns v 1.0')
disp(' Automatic start of multiple simulation runs')
disp(' Marcelino Hermida - Jan 2017')
disp(' -------------------------------------------------')
disp(' ')

NumberOfRunsStart = input(' Number of the FIRST run to be started? [1] ');
if isempty(NumberOfRunsStart)
    NumberOfRunsStart = 1;
end
NumberOfRunsEnd = input(' Number of the LAST run to be started? ');

load;       % loads matlab.mat workspace created by creareruns
            % to read the name of the simulation folder
% SimulationFolder = input('Main simulation folder name? ', 's');

MainFolder=cd;

% Loop over the run folders to search steering and input files, and start
% simulations.
for i=NumberOfRunsStart:NumberOfRunsEnd
    if (i<10)
        folder=strcat(MainFolder, '\', SimulationFolder, '_run0', ...
            num2str(i));
    else
        folder=strcat(MainFolder, '\', SimulationFolder, '_run', ...
            num2str(i));
    end
    
    cd (folder)
    FileList=dir;
    NumFiles=length(FileList);       % number of files in the folder
    
    % search for steering program of the simulation
    % executable name should start with "pen" (Penmain)
    for j=1:NumFiles
        if regexp(FileList(j).name,'pen') & regexp(FileList(j).name, ...
                '.exe$') % file name starts with "pen"
            FileExec=FileList(j).name;      % executable file name
        end
        
        % with penmain simulations there is no command.in file
        if any(regexp(FileList(j).name,'.in$'))
            FileIn=FileList(j).name;                % input file
        end
    end
     
    % Opens command window and starts simulation in background
    StartSimulation=strcat(FileExec, ' < ', FileIn, ' &');
    dos (StartSimulation);         
    fprintf('Starting simulation run #%i with %s and %s \n', i, ...
        FileExec, FileIn);
    % fprintf(fileID, 'Starting simulation run #%i \n',i);

end

cd (MainFolder);
delete('matlab.mat');
disp('All simulations started. Back to the main folder.');
disp('END OF PROGRAM');
% fclose(fileID);