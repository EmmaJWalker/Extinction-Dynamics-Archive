# PathstoExtinction
Data and code repository for Paths to extinction: mode of habitat loss 
structures extinction thresholds and debts (R Version R.3.5.3 or later)

Included in the repository is all code for simulations and figures provided 
in the manuscript.

For Simulations contains the following scripts run to generate the simulated 
data:

  50 patch test landscape generation (does not work on server).r:

	This script was run as is to create 100 test landscapes of 50 patches 
	to inspect properties of those landscapes such as the distribution of 
	nearest neighbour distances to ensure an appropiately wide range of 
	alpha (1/(avg. dispersal distance) values were chosen for the 
	simulutions using landscapes of the same degrees of clustering.
	In this script, n.patches specifies the number of patches in each 
	landscape, landscape.limit specifies the extent of x and y coordinates
 	within each landscape, no.replicates specifies how many landscapes,
	directory specifies where to save the output, landscape.types 
	specifies a list of landscape types to be generated (eg. clustered 
	generating more clustered patch distributions in the landscape, 
	regular more uniform patch distributions and random giving random 
	patch distributions. 

	To do so it uses the "Create Multiple Landscapes Function" which 
	simply iterates and tabulates data from running the 
	"Create Landscape Function" into a single dataframe, the 
	"NNDist Distribution Summary Function" which calculates summary 
	statistics of the nearest neighbour interpatch distances within
	generated landscapes, and the "Choose Alphas Function meanmins2"
	which calculates the appropiate values of for the model parameter
	alpha equivalent to 1/16, 1/8, 1/4, 1, 2, 4, and 8 times the mean
	minimum interpatch distance observed across the test landscapes 
	generated and for global dispersal over the landscape.
	Details are commented throughout the code.

  500 patch test landscape generation (does not work on server).r

        The same script but run with n.patches set to 500 patches.

  P and Lm and Sim Eq in parallel 3 (50p).r:

        This script was run as is to perform replicate (in this case 50) 
	simulations of the destruction and degradation scenarios or iterative 
	levels of habitat loss across replicate landscapes of each type 
	(more clustered, random and more uniform) where these simulations were
	run in parallel (in this case over a 40 core cluster) to generate and 
	tabulate all output data analyzed in the paper for the 50 patch 
	landscape results (thus, with n.patches=50 and appropiate alpha values
	chosen from 500 patch test landscapes).
	To do so it uses the "Vary Alpha Destroy and Degrade Function for 
	parallel" which simply selects the appropiate value of alpha for 
	the simulation assigned to an individual core at a given time to
	that specific core's simulation and the "Destroy and Degrade a 
	Landscape Function2 (P and LM and SimEq)2" function to perform each 
	simulation for each replicate of each landscape type.

	In this script, the parameters k and its.of._ must be set 
	as optimal for the desired number of replicates and the number of 
	cores available to you (eg. 4 if your personal computer has a 
	quad-core processor or however many are availble on a cluster 
	available to you). Here we had a 40 core cluster available to us and
	wanted 50 replicates. So here it was optimal to run sequential 
	simulations for the 3 landscape types (more clustered, random, and 
	more uniform) in parallel for all 8 values of alpha (equivalent to 
	1/8, 1/4, 1/2, 1, 2, 4, and 8 times the mean minimum interpatch 
	distances plus global dispersal) x5 replicates at a given time 
	(hence its.of.5=10 and k=1:5). This was adjusted appropiately 
	depending on how many scenarios we wanted to simulate at a time, how
	many replicates and how many cores were available.

  P and Lm and Sim Eq in parallel 3 (500p).r

        The same script but optimized for large patch numbers and used for 500 patch 
	landscape results (thus, with n.patches = 500 and appropiate alpha 
	values chosen from 500 patch test landscapes) and run only for 
	landscapes with clustered patch distributions. Because this takes a
	long time to run even in parallel just a few replicates (eg. 50) 
	were run at a time and data saved sequentially in seperate files 
	for analysis in case of interuption (eg. a power outage).

Note: To run a single simulation of degradation and destruction for iteratively
larger levels of habitat loss not in parallel you need only run the "Destroy 
and Degrade a Landscape Function2 (P and Lm and SimEq)2" with parameters set 
as desired. To do replicate simulations for each specified alpha value across 
landscapes of just a single type you need only run the "Vary alpha destroy and 
degrade function for parallel" function with parameters set as desired.

CHECK ALL FUNCTIONS2.r

        Just a script for checking all the independent functions necessary for
 	building the simulations are available and run (doesn't include the 
	functions for running of the full simulations themselves, obviously 
	because these functions take a long time to run).

For Simulations also contains the following functions (in alphabetical order):
  
  Choose alphas meanmins2.r
          
	Chooses alpha values for simulation based on each landscape type's 
	distribution of nearest neighbour distances. Thus, levels of alpha 
	represent diff species but of equivalent dispersal ability within the 
	given landscape.Controls for the fact that clustering will have 
	smaller nearest neighbour distances by way of the clustering algorithm,
 	while regular will have larger nndists isolates for the effect of 
	regularity in patch spacing. Details are commented throughout the code.

	Parameters:
	nndists.distribution = data.frame of summary stats of nndists for all 
		three landscape types (aka output from NNDISTS Distribution 
		Summary function)
	landscape.limit = size of landscape (max x and y coordinate that was 
		possible in landscape generation)

	Outputs:
	alphas = a dataframe of the (no longer intuitively named -sorry):
		a.16min = average dispersal distance 1/16x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
  		a.8min = average dispersal distance 1/8x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a.4min = average dispersal distance 1/4x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a.2min = average dispersal distance 1x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a4.min = average dispersal distance 2x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a8.min = average dispersal distance 4x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a16.min = average dispersal distance 8x the mean minimum
			nearest neighbour interpatch distance observed in the 
			test landscapes
		a.limit = average dispersal distance equal to the landscape 
			limit (global dispersal)

  Create landscape function.r

	Creates a landscape of a specified size with a specified number of 
	patches, with a patch distribution of specified level of clustering 
	or uniformity. Details are commented extensively throughout the code.
	
	Parameters:
	n.patches = number of patches in desired landscape
	landscape.limit = size of disired landscape (max possible x and y 
		coordinate of a patch)
	landscape.type = specify whether the desired landscape's patches 
		should be randomly, clustered or more uniformly (regularly)
		distrbuted (accepts either "clustered", "regular" or "random")
		no.runs = number of iterations for which the clustering 
		algorithm is run for, specifying the level of clustering

	Outputs: 
	landscape = a dataframe of:
		patch.ID = a unique number for each patch in the landscape 
                A = the area of each patch
                x.coord = the x coordinate location of a patch
                y.coord = the y coordinate location of a patch
		and all interpatch distances

  Create multiple landscapes function.r
	
	Creates multiple landscapes of all three possible landscape types 
	of a specified size with a specified number of patches, with a patch 
	distribution of specified level of clustering or uniformity. Details 
	are commented throughout the code.
	
	Parameters:
	n.patches = number of patches in desired landscape
	landscape.limit = size of disired landscape (max possible x and y 
		coordinate of a patch)
	landscape.types = may be a list of landscape types to be created 
		eg. "clustered", "random", "regular"
	no.runs = number of iterations for which the clustering algorithm is 
		run for, specifying the level of clustering
	no replicates = number of landscapes of each type to create
	directory = where output data should be saved
	
	Outputs: 
	a csv file containing the landscape data for each landscape generated

  Degrade and Destroy Multiple Landscapes Function.r
	
	Runs replicates of landscape generation and degradation and 
	destruction scenarios of that landscape for a given set of 
	parameters by just iteratively running the "Destroy and Degrade a 
	landscape function2 (P and Lm and SimEq)2" or "Destroy and Degrade 
	a landscape function2 (P and Lm and SimEq)500" (you need to specify 
	which it should use within this function) saving landscape data for 
	the different parameter values specified.

	Parameters:
	n.patches = number of patches desired in landscapes
	landscape limit = size of landscapes (max x and y coord of patches)
	landscape.type = specifiy whether landscapes should be "clustered", 
	"random" or "regular" in patch distribution
	no.runs = level of clustering (number of times the clustering 
	algorithm is iterated for)
	a = 1/average dispersal distance of the species
	n.landscapes = number of landscapes put through the degradation and 
	destruction scenarios
	scaled.lm = value you would like to scale lambda.M to initially

	Outputs:
	a csv file containing the output data for each landscape generated,
	the process of patch destruction and degration scenarios simulated 
	for it and metapopulation response metrics.

 Destroy and Degrade a landscape function2 (P and Lm and SimEq)2.r 
       
	Loops both Degradation vs. Destruction scenarios for multiple levels of
	habitat loss for a given landscape (Note: takes about 10 min (for 
	landscapes with 50 patches) by taking a given landscape and seperately 
	performing two scenarios in which all patches are either destroyed 
	(randomly and sequentially) or degraded (decreasing all patch areas) 
	until no habitat remains, importantly outputing the data required for 
	determining the metapopulation persistence capacity, average 
	probability of patch occupancy at equilibrium across all patches, 
	average number of patches occupied for last 50 of 1000 timesteps of 
	the metapopulation sim, and timestep at which the metapopulation went 
	extinct. Details are commented extensively throughout the code.
	
	Parameters:
	landscape = a dataframe created by the "Create landscape function" 
		which specifies patch locations, areas, and and an interpatch 
		distance matrix
	a = 1/(average dispersal distance) for a species
	delta = the ratio of the extinction to colonization rate of a species

	Outputs:
	output = a dataframe recording:
			patch.ID = a unique number for each patch in the 
				original landscape 
                     	A = the area of each patch
                     	x.coord = the x coordinate location of a patch
                     	y.coord = the y coordinate location of a patch
                     	order.lost = the order in which each patch was lost in 
				the destruction scenarios
                     	lambda.M.r = the persistence capacity following some 
				portion of habitat destroyed 
                     	eq.size.r = predicted size of metapopulation weighted 
				by the area of each occupied patch at 
				equilibrium following some portion of habitat 
				destroyed 
                     	eq.p.r = total predicted number of patches occupied at 
				equilibrium following some portion of habitat 
				destroyed 
                     	avg.p.r = average predicted probability of occupancy 
				across patches at equilibrium following some 
				portion of habitat destroyed 
                     	time.to.eq.r = timesteps it took to reach expected 
				equilibrium occupancy or less following some 
				portion of habitat destroyed 
                     	time.to.p1000.r = timestep at which the metapopulation 
				reached what it's average occupancy following 
				some portion of habitat destroyed for the last 
				50 of 1000 timesteps
                     	sim.eq.size.r = observed occupancy level seen at 1000
				timesteps following some portion of habitat 
				destroyed 
                     	percent.habitatloss = percentage of habitat that was 
				lost either by destruction or degradation 
				(equivalently)
                     	lambda.M.e = the persistence capacity following some 
				portion of habitat degraded 
                     	eq.size.e = predicted size of metapopulation weighted 
				by the area of each occupied patch at 
				equilibrium following some portion of habitat 
				degraded 
                     	eq.p.e = total predicted number of patches occupied at 
				equilibrium following some portion of habitat 
				degraded 
                     	avg.p.e = average predicted probability of occupancy 
				across patches at equilibrium following some 
				portion of habitat degraded 
                     	time.to.eq.e = timesteps it took to reach expected 
				equilibrium occupancy or less following some 
				portion of habitat degraded 
                     	time.to.p1000.e = timestep at which the metapopulation 
				reached what it's average occupancy following 
				some portion of habitat degraded for the last 
				50 of 1000 timesteps
                     	sim.eq.size.e = observed occupancy level seen at 1000
				timesteps following some portion of habitat 
				degraded 
                     	delta = extinction / colonization rate ratio (e/c)
	
  Destroy and Degrade a landscape function2 (P and Lm and SimEq)500 saving 
	landscape data.r
 
	Identical to the above but updated to ensure it works well for large 
	numbers of patches eg. 500 by not removing one at a time but by an
	incremental number of patches to speed things up. It was also 
	updated to save all data of the configurations of landscapes used. 
	(see info in function for details).

  Lambda.M function.r

	Calculates the metapopulation persistence capacity for a given 
	landscape, species specific average dispersal distance (a), and 
	species specific ratio of extinction to colonization rate (delta). 
	Note: delta can be factored out of this calculation by letting delta 
	= 1. Details are commented extensively throughout the code.

	Parameters:
	landscape = a dataframe created by the create landscape function which 
		specifies patch locations, areas, and interpatch distances 
	a = 1/(average dispersal distance) for a species
	delta = the ratio of the extinction to colonization rate of a species

	Outputs: 
	lambda.M = metapopulation persistence capacity

NNDist Distribution Summary Function.r

	Calculates summary statistics of the nearest neighbour interpatch 
	distance for a number of test landscapes.

	Parameters:
	potatoes = csv file of a number of test landscapes data created using 
	the "50 patch test landscape generation (does not work on server)" or
	"500 patch test landscape generation (does not work on server).r" 
	scripts. 
	no.replicates = how many replicates there were of each landscape type
	n.patches = how many patches are in each landscape

	Outputs:
	dist.summary = a dataframe of:
		min.min = minimum of the minimum nndists across landscapes
  		min = average minimum nndists across landscapes
  		min.se = standard error of this
  		first = average first quartile nndists across landscapes
  		first.se = standard error of this
  		median = average median nndists across landscapes
  		median.se = standard error of this
  		mean = average mean nndists across landscapes
  		mean.se = standard error of this
  		third = average third quartile nndists across landscapes
  		third.se = the standard error of this
  		max = average maximum nndists across landscapes
  		max.se = standard error of this
  		max.max = maximum maximum nndist across landscapes

 Pstar function.r
	Calculates the expected probabilities individual patches are occupied 
	at equilibrium. Details are commented extensively throughout the code.

	Parameters:
	landscape = a dataframe created by the create landscape function which 
	specifies patch locations, areas, and and an interpatch distances 
	a = 1/(average dispersal distance) for a species
	delta = the ratio of the extinction to colonization rate of a species
	iterations = the number of iterations for which the iterative function 
		f is iterated, (greater iterations = greater accuracy, less 
		iterations = lower accuracy)

	Outputs: 
	p.star = expected probabilities individual patches are occupied at 
	equilibrium

  Time to eq3.r

	Simulates metapopulation extinction and colonization dynaimcs in 
	discrete time within a specified landscape for the specified species 
	specific parameter values over 1000 timesteps and provides metrics
	used to look at transient dynamics for disturbed landscapes. Details 
	are commented extensively throughout the code.

	Parameters:
	landscape = a dataframe created by the create landscape function which 
	specifies patch locations, areas, and and an interpatch distances
	a = 1/(average dispersal distance) for a species
	delta = the ratio of the extinction to colonization rate of a species
	timesteps = number of timesteps to run the model for
	p.initial = initial probabilities individual patches are occupied
	avg.p = average predicted probability of occupancy across patches at 
	equilibrium

 Vary Alpha Destroy and Degrade Function.r
	Just performs replicates of the degradation and destruction scenario 
	simulations for multiple different alpha values. Details are 
	commented throughout the code.

	Parameters:
	alphas = vector of alpha values
	n.patches = number of patches desired in landscapes
	landscape limit = size of landscapes (max x and y coord of patches)
	landscape.type = specifiy whether landscapes should be "clustered", "random" or "regular" in patch distribution
	no.runs = level of clustering (number of times the clustering algorithm is iterated for)
	n.landscapes = number of landscapes put through the degradation and destruction scenarios
	scaled.lm = desired lambda.M of pristine landscapes

	Outputs: 
	a csv file containing the output data for each landscape generated,
	the process of patch destruction and degration scenarios simulated 
	for it and metapopulation response metrics.

 Vary Alpha Destroy and Degrade Function for parallel.r

	Identical to the above just indexing parameter values appropiately for
	each core the code is run on.

For Figures contains the following scripts to generate figures for the paper:

 Hypothesis fig code.r

	Just a script used to create the hypothesis figure included in the
	paper.

 Manuscript Plots.r

	A script conatining all code used to create the rest of the figures 
	in the manuscript. All data processing is done in the script which 
	makes use of a series of functions used to bin data for increments of
	percent habitat loss (since these did not occur on regular intervals
	but rather were dictated by the size of patches randomly lost in the
	destruction process), calculate the median metric value within that 
	bin (median as opposed to mean due to shifting skew of metric values 
	observed with iterative patch loss see supplementary material) and 
	calculate bootstraped 95% Confidence Intervals (r=1000).
 
 NNDISTS histograms of test landscapes code.r

	A script used to make histograms of nearest neighbour distances in 
	generated test landscapes made using the "50 patch test landscape 
	generation (does not work on server)" script which uses the "NNDist 
	Distribution Summary Function.r"
       
  
