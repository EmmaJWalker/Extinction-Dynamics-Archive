# PathstoExtinction
List of Data Files and explanation:

For 50 patch landscapes:
1. 50_p_100landscapes_clevel500
	Data describing 100 test landscapes of 50 patches of each landscape 
	type (more clustered, random and more uniform (regular)).
		patch.ID = a unique number for each patch in the landscape 
                A = the area of each patch
                x.coord = the x coordinate location of a patch
                y.coord = the y coordinate location of a patch
		X1-X50 = all interpatch distances
		landscape = a unique number for each landscape of a given
		type created
		landscape.type = whether the distribution of patches was 
		created with a more clustered, random and more uniform 
		(regular) patch distribution.
2. alphas50p: 
	alpha values chosen based on mean minimum interpatch distances within
	the 1000 50 patch test landscapes (no longer intuitively named -sorry):
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
		landscape.type = whether the distribution of patches was 
		were more clustered, random and more uniform (regular) patch 
		distribution.
3. 2000reps_PnLMnSimEq_3_50pnew2
	Simulation data for degradation and destruction and destruction 
	scenarios across 2000 landscapes of 50 patches.
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
		alpha = 1/(average dispersal distance)
		rep.no = a unique number for each replicate simulation
4. clustered50p disp summary table
	Summary stats of delta (e/c) as set for simulations of varied levels 
	of dispersal across more clustered landscapes.
		Min = minimum delta value
		1st.Q = first quartile of delta values
		Med = median delta value
		Mean = mean delta value
		3rd.Q = 3rd quartile of delta values
		Max = maximum delta value
		a = alpha
		avg.disp = describes average dispersal distance relative to 
		the mean minimum nearest neighbour interpatch distance
5. random50p disp summary table
	Summary stats of delta (e/c) as set for simulations of varied levels 
	of dispersal across random landscapes.
		Min = minimum delta value
		1st.Q = first quartile of delta values
		Med = median delta value
		Mean = mean delta value
		3rd.Q = 3rd quartile of delta values
		Max = maximum delta value
		a = alpha
		avg.disp = describes average dispersal distance relative to 
		the mean minimum nearest neighbour interpatch distance
6. regular50p disp summary table
	Summary stats of delta (e/c) as set for simulations of varied levels 
	of dispersal across more uniform (regular) landscapes.
		Min = minimum delta value
		1st.Q = first quartile of delta values
		Med = median delta value
		Mean = mean delta value
		3rd.Q = 3rd quartile of delta values
		Max = maximum delta value
		a = alpha
		avg.disp = describes average dispersal distance relative to 
		the mean minimum nearest neighbour interpatch distance
For 500 patch landscapes:
1. 500_p_100landscapes_clevel500
	Data describing 100 test landscapes of 500 patches of each landscape 
	type (more clustered, random and more uniform (regular)).
2. alphas500p: 
	alpha values chosen based on mean minimum interpatch distances within
	the 1000 500 patch test landscapes.
3. 10reps_PnLMnSimEq_3_500pnew2
4. 10_40reps_PnLMnSimEq_3_500pnew2
5. 40_70reps_PnLMnSimEq_3_500pnew2
6. 70_100reps_PnLMnSimEq_3_500pnew2
	Simulation data for degradation and destruction and destruction 
	scenarios across 100 landscapes of 500 patches (subsetted into files
	containing the first 10, 11-40, 41-70, 71-100 replicates respectively).
7. clustered500p disp summary table
	Summary stats of delta (e/c) as set for simulations of varied levels 
	of dispersal across more clustered landscapes.
		Min = minimum delta value
		1st.Q = first quartile of delta values
		Med = median delta value
		Mean = mean delta value
		3rd.Q = 3rd quartile of delta values
		Max = maximum delta value
		a = alpha
		avg.disp = describes average dispersal distance relative to 
		the mean minimum nearest neighbour interpatch distance
