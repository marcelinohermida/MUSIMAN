% ************************************************************************
% MUSIMAN (MUltiple SImulations MAnagement)
% createruns
% v 1.0
% Automatic creation of file sets for multiple simulation runs
% with the Monte Carlo code for radiation transport PENELOPE.
% Compatible with PENELOPE 2014
%
% Written with Matlab R2014 64 bits for Windows 
%
% Marcelino Hermida-López - Jan 2017
%
% Usage:
% The createruns file must be in the parent folder of the main 
% simulation folder. The multiple simulation runs will be in separate 
% folders. The name of the folders will finish with "\runXX", with XX
% the run number.
%
% To create executable, type:
%    mcc -m createruns.m
% in the Matlab command window.
% To use the executable in other computer it is necessary that Matlab
% or the Matlab Compiler Runtime (MCR) are installed.
% The MCR must be the one included with the Matlab version used
% to compile the executable to avoid compatibility issues.
% ************************************************************************

% *****************************************
% *  INITIALIZATION AND PARAMETERS INPUT  *
% *****************************************
clc;
clear;

% fileID = fopen('createruns.out','w');
disp(' ')
disp(' createruns v 1.0')
disp([' Automatic creation of file sets for multiple independent ' ...
     'simulation runs (Marcelino Hermida - Jan 2017)'])
disp([' ---------------------------------------------------------' ...
     '------------------------------------------------'])
disp(' ')

% Asks the user for the number of independent runs to be created
NumberOfRuns = input(' How many runs to create? [5] ');
if isempty(NumberOfRuns)
    NumberOfRuns = 5;
end

% Asks the user for the number of histories per run
NumHistories = input(' How many histories per run? [100E6] ', 's');
if isempty(NumHistories)
    NumHistories = '100E6';
end

% Asks the user the dump period
DumpPeriod = input(' Dump period (in seconds)? [300] ', 's');
if isempty(DumpPeriod)
    DumpPeriod = '  300';
end


% Load list of seeds
seeds=load('seeds.dat','-mat');        % Matlab workspace file format
Seed1=seeds.seeds(:,1);                % 1001 values for seed1
Seed2=seeds.seeds(:,2);                % 1001 values for seed2


% *********************
% *  FOLDER CREATION  *
% *********************
MainFolder=cd;
Directory=dir;
for i=1:length(Directory)
    if Directory(i).isdir==1
        SimulationFolder=Directory(i).name;
    end
end
save;       % saves the Matlab workspace to file matlab.mat
            % Useful for debug purposes and to save the name of the
            % simulation folder, needed by simruns.

% Create copies of the simulation folder, with names ending in "runXX"
for i=1:NumberOfRuns
    if (i<10)
        folder=strcat(MainFolder, '\', SimulationFolder, '_run0', ...
            num2str(i));
    else
        folder=strcat(MainFolder, '\', SimulationFolder, '_run', ...
            num2str(i));
    end
    
    copyfile(SimulationFolder, folder);
    
end

 

% edit input file for each run (nr. of histories, dump file name, seeds)
SeedIndex=5;
for i=1:NumberOfRuns
    if (i<10)
        folder=strcat(MainFolder, '\', SimulationFolder, '_run0', ...
            num2str(i));
        RunIndex=strcat('0',num2str(i));
    else
        folder=strcat(MainFolder, '\', SimulationFolder, '_run', ...
            num2str(i));
        RunIndex=num2str(i);
    end
    
    cd (folder);
    
    %read input file
    
    FileList=dir;
    NumFiles=length(FileList);       % number of files in the folder
    
    % Search for input file (*.in) of the simulation
    for j=1:NumFiles
        % with penmain simulations there is no command.in file
        % so, the only .in file is the simulation input file
        if any(regexp(FileList(j).name,'.in$'))     
            FileIn=FileList(j).name;                % input file
        end
    end
    
    
    % Read input file into cell A
    fid = fopen(FileIn,'r');
    k = 1;
    tline = fgetl(fid);
    % each line of the file is stored in one position of the cell
    A{k} = tline;           
    while ischar(tline)
        k = k+1;
        tline = fgetl(fid);
        A{k} = tline;
    end
    A=A';
    fclose(fid);
    
    % Changes dump file name, seeds and number of histories for each run
    for k=1:length(A)-1
        if regexp(A{k},'RESUME')==1
            A{k}=strcat(['RESUME dump', RunIndex,'.dmp              ' ...
                '[Resume from this dump file, 20 chars]']);              
        elseif regexp(A{k},'DUMPTO')==1
            A{k}=strcat(['DUMPTO dump', RunIndex,'.dmp              ' ...
                '[Generate this dump file, 20 chars]']);              
        elseif regexp(A{k},'DUMPP')==1
            A{k}=['DUMPP  ', DumpPeriod, '                         ' ...
                '[Dumping period, in sec]'];              
        elseif regexp(A{k},'RSEED')==1
            A{k}=['RSEED  ', num2str(Seed1(SeedIndex)), ',', ...
                num2str(Seed2(SeedIndex)), '     '...
                '[Seeds of the random-number generator]'];              

        elseif regexp(A{k},'NSIMSH')==1
            A{k}=['NSIMSH ', NumHistories, '                   ' ...
                '[Desired number of simulated showers]'];              
        end
    end
    
    % Write modified cell A to input file
    fid = fopen(FileIn, 'w');
    for k = 1:numel(A)
        if A{k+1} == -1             % end of cell
            fprintf(fid,'%s', A{k});
            break
        else
            fprintf(fid,'%s\n', A{k});
        end
    end
   
   % Updates seed index to the next position of the seeds list. 
   % That means the sequences of pseudorandom numbers are separated
   % by 10^14 positions.
   SeedIndex=SeedIndex + 1;
    
end

% End of program
% fclose(fileID);      % closes output file
cd (MainFolder);
disp('All folders created. Back to the main folder.');
disp('END OF PROGRAM');