# PathstoExtinction
Data and code repository for Paths to extinction: mode of habitat loss structures extinction thresholds and debts

Included in the repository is all code for simulations and figures provided in the manuscript.

For Simulations contains the following functions:
  50 patch test landscape generation (does not work on server).r
          This function creates landscapes of 50 patches to inspect properties of those landscapes such as the distribution of nearest neighbour distances 
          (see info in function for details)
  500 patch test landscape generation (does not work on server).r
          Does the same but for landscapes of 50 patches
  CHECK ALL FUNCTIONS2.r
          Just a script for checking all the functions necesarry for building the simulations are available and run
          (doesn't include the functions for running of the full simulations themselves, obviously because these functions take a long time to run)
  Choose alphas meanmins2.r
          Chooses appropiate values for alpha relative to the mean minimum interpatch distance from a number of test landscapes
          (see info in function for details, necessary since more uniform landscapes have wider interpatch distances whle more clustered landscapes have shorter ones on average)
  Create landscape function.r
          creates a single landscape of patches (see info in function for details)
  Create multiple landscapes function.r
          creates multiple landscapes with desired attributes (see info in function for details)
  Destroy and Degrade a landscape function2 (P and Lm and SimEq)500 saving landscape data.r
          removes patches randomly from one copy of a landscape and decreases the area (equivalent here to carrying capacity) of all patches by the same % reduction in habitat
          in another. Updated to ensure it works well for large numbers of patches eg. 500 by not removing one at a time but by incremental numbers of patches to speed things up.
          Was updated to save all data of the configurations of landscapes used. (see info in function for details)
  Destroy and Degrade a landscape function2 (P and Lm and SimEq)2.r
          removes patches randomly from one copy of a landscape and decreases the area (equivalent here to carrying capacity) of all patches by the same % reduction in habitat
          in another. Was updated to save all data of the configurations of landscapes used. 
          (see info in function for details)
  Lambda.M function.r
          Calculates persistence capacity for a species in a landscape (see info in function for details)
  P and Lm and Sim Eq in parallel 3 (500p).r
          Performs replicate simulations providing all output data then used in analyses, optimized for large patch numbers, used for 500 patch landscape results
  P and Lm and Sim Eq in parallel 3 (50p).r
          Performs replicate simulations providing all output data then used in analyses, used for 50 patch landscape results
  Pstar function.r
          Calculates the expected equilibrium patch occupancy via iterative function derived by Ovaskainen and Hanski 2000 (see info in function for details)
  Vary alpha destroy and degrade function for parallel.r 
          Just breaks up simulations specified in "P and Lm and Sim Eq in parallel 3" functions by their specified alpha parameter values
  Time to Eq3.r
          Calculates all metrics related to the transient dynamics of simulations from simulations of metapopulations within each modified landscape from pristine conditions
          (see info in function for details)
          
Also, included is all code that was used to generate figures, including a number of functions that just bin data and average it across simulations
and calculate 95% CI's via bootstrapping methods (see info in functions and scripts for futher details)
          
  
