%% 0. myGA settings
-> in `myGA.m`, it's possible to choose for recombination between interpolation and Random Uniform Crossover. The default is set to interpolation. See `myGA.m` for more explanation.

%% 1. Make evaluation faster

-> in benchmark.m: comment the code for ZDT6, and uncomment the code below, which is a vectorized version of ZDT6
-> in evaluatePopulation.m: comment the for loop, and uncomment the line below (line 19). This allows MATLAB to evaluate the whole population matrix in parallel using the vectorized benchmark function

-> `evaluateGA` runs myGA many times and shows average, median, maximum convergence speed.

%% 2. Make testing faster
-> evaluateGA tests myGA on ZDT6, and runs it lots of times, until it finds and acceptable average value for the convergence speed. It runs multiple instances of the GA in parallel using MATLAB's `parafor` command.

%% 3. Optimizing the GA using a GA
-> in the GA_parameters folder, you'll find functions to optimize the GA parameters, as described in our report. It's required to modify the poins under 1. in order to run this.
-> you'll also find a .mat file with some optimized values we found.

%% 4. Sweeping
-> in the sweeps_graphs folder you'll find functions to sweep a parameter, and a plot.m function with which you can generate corresponding graphs.

%% 5. InterfaceEldo
-> in interfaceEldo, BW, GBW, Gain and unityGain are extracted from a circuit. Circuit 3 is a differential pair with resistive load and 7 parameters, circuit 4 with 5 parameters; circuit 5 is a diff. pair with active load and 6 parameters. Circuit 6 is a model of a cascode amplifier.
Run the circuits through `example_RCFilter.m`