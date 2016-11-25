# MUSIMAN
MUltiple SImulations MANagement

The Monte Carlo code for radiation transport \pen 2014 includes an auxiliary program named \texttt{penmain-sum} to combine the results of independent runs of the same simulation problem allowing to use multiple computing cores simultaneously. Thus, the simulation efficiency increases linearly with the available number of cores. Each independent run produces a dump file with the partial results of the simulation with accumulated statistics. The tool \texttt{penmain-sum} combines all dump files to get the final results of the simulation.

The process of manually generating the simulation files needed for multiple independent runs is tedious and error--prone. The MATLAB scripts from the MUSIMAN package automate this process. Briefly, the scripts take care of:

1. Creating the files needed for an arbitrary number of independent runs of the same simulation problem. A different pair of seeds for the random number generator is assigned to each run, taken from the list in the rita.f source file included in PENELOPE 2014, which was obtained with the algorithms from the work of Badal and Sempau~\cite{Badal2006}. Each consecutive pair of seeds in the list is separated from the following pair by 10^14 positions. In this way, we ensure that each simulation run uses independent sequences of pseudo--random numbers.

2. Launching simultaneously a number of parallel independent simulation runs.

3. Preparing the dump files to be combined with \texttt{penmain-sum} to obtain the final results of the simulation.

