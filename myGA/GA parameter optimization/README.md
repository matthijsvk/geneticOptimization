These files can be used to optimize parameters for a GA using another, manually defined GA.
-	Set the correct boundary conditions in optimizeGeneticAlgorithm.m
-	set the correct order of parameters in benchmark.m (case 5), that are used as input to myGA_evaluator.m.
- 	in myGA_evaluator.m, change the GA parameter start values. By default, we optimize a GA that uses random uniform recombination, but you can set the recombination_interpolation value to 1, and it will optimize a GA using interpolation for recombination. If so, you'll also need to change the sd_mut_rec to intervalScalar.

