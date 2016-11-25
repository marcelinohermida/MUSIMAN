# MUSIMAN
MUltiple SImulations MANagement

The Monte Carlo code for radiation transport PENELOPE 2014 includes an auxiliary program named penmain-sum to combine the results of independent runs of the same simulation problem allowing to use multiple computing cores simultaneously. Thus, the simulation efficiency increases linearly with the available number of cores. Each independent run produces a dump file with the partial results of the simulation with accumulated statistics. The tool penmain-sum combines all dump files to get the final results of the simulation.

The process of manually generating the simulation files needed for multiple independent runs is tedious and error-prone. The MATLAB scripts from the MUSIMAN package automate this process. Briefly, the scripts take care of:

1. Creating the files needed for an arbitrary number of independent runs of the same simulation problem. A different pair of seeds for the random number generator is assigned to each run, taken from the list in the rita.f source file included in PENELOPE 2014, which was obtained with the algorithms from the work of Badal and Sempau [1]. Each consecutive pair of seeds in the list is separated from the following pair by 10^14 positions. In this way, we ensure that each simulation run uses independent sequences of pseudo--random numbers.

2. Launching simultaneously a number of parallel independent simulation runs.

3. Preparing the dump files to be combined with \texttt{penmain-sum} to obtain the final results of the simulation.

In summary, the MUSIMAN package is a software tool to ease the parallelization of simulations run with the Monte Carlo code PENELOPE 2014 that use penmain as steering main program. 

If you use the MUSIMAN tool, please include a citation to this work:

M. Hermida-López and L. Brualla. Technical Note: Monte Carlo simulation of 106Ru/106Rh ophthalmic plaques including the
106Pd gamma spectrum. Submitted to Med. Phys. 2016.



References:

[1] A. Badal and J. Sempau. A package of Linux scripts for the parallelization of Monte Carlo simulations. Comput. Phys. Commun., 175(6):440–450, 2006.
