# MATLAB Code for Fast Linear Interpolation

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - science](https://img.shields.io/badge/category-science-lightgrey)
![status - unmaintained](https://img.shields.io/badge/status-unmaintained-red)

The **MATLAB code** offers fast **1D linear interpolation** methods.

The following **fast interpolation methods** is implemented:
* Linear interpolation inside the domain, linear extrapolation outside.
* Support vector or matrix (set of 1D values) for the sample values.
* Support for evenly spaced sample points: `interp_regular`.
* Support for evenly arbitrarily spaced sample points: `interp_fast`.
* These algorithms can be **up to 30x faster** than the MATLAB builtin interpolation methods.

The following **algorithm** is used for `interp_regular`:
* The sample points are evenly spaced.
* The position (index) of the query points can be computed without searching.
* Hence, the complexity is O(1).

The following **algorithm** is used for `interp_fast`:
* The sample points are arbitrarily spaced.
* After each query, the position (index) of the point is returned.
* This index is used as an initial value for the next query point.
* Hence, the computational cost is reduced if the query points are partially sorted.
* For randomly distributed query points, the complexity is O(n).
* For sorted query points, the complexity is reduced from O(n) to O(1).

These methods should be **used in the following case**:
* Many calls are done with the same sample points and values.
* The calls cannot be vectorized (interdepency between the query points).
* A typical use case is ODE integration where the calls cannot be vectorized.

These functions can be compiled to **MEX** files with the **MATLAB Coder**.

## Functions

* [interp_regular.m](interp_regular.m) - Fast interpolation method (evenly spaced sample points).
* [interp_fast.m](interp_fast.m) - Fast interpolation method (arbitrarily spaced sample points).

## Examples

* [run_example_simple.m](run_example_simple.m) - Minimal working example for the interpolation code.
* [run_example_ode.m](run_example_ode.m) - Example with interpolation inside an ODE function.

## Benchmark

The following sample points and values are considered (1000 points):

```
% sample points (sorted)
x_vec = linspace(0, 1, 1000);

% sample values (3 rows)
y_mat = [-1+x_vec+x_vec.^2 ; +1+x_vec-x_vec.^2; +2-x_vec-x_vec.^2];
```

The following query points (sorted and random) are considered (12500 points):

```
% query point, mostly sorted
x_vec_pts_sort = [...
    linspace(-1.0, +2.0, 2500)...
    linspace(+2.0, -0.5, 2500)...
    linspace(-0.5, +0.5, 2500)...
    linspace(+0.5, -1.0, 2500)...
    linspace(-1.0, +2.0, 2500)...
    ];

% randomly sorted query points
idx = randperm(length(x_vec_pts_sort));
x_vec_pts_rand = x_vec_pts_sort(idx);
```

The following algorithms are compared with sorted and random query points:
* `interp1` code (MATLAB builtin function, MATLAB and MEX)
* `griddedInterpolant` code (MATLAB builtin function, MATLAB)
* `interp_regular` code (proposed method, MATLAB and MEX)
* `interp_fast` code (proposed method, MATLAB and MEX)
* In this document, the benchmark is run on a Intel i5-8250U laptop on Linux (64 bits).

The following files are required to run the benchmark:
* [run_benchmark_compile.m](run_benchmark_compile.m) - Compile the MATLAB files into MEX files.
* [run_benchmark_run.m](run_benchmark_run.m) - Run the benchmark for the different methods.

### Vectorized Call

All the 12500 query points are evaluated at once with a vectorized call.

```
============================ vectorized call

interp1              MATLAB   sorted = 0.74 ms     random = 0.70 ms  
interp1              MEX      sorted = 0.70 ms     random = 0.85 ms  

griddedInterpolant   MATLAB   sorted = 0.18 ms     random = 0.21 ms  
griddedInterpolant   MEX      sorted = NaN ms      random = NaN ms   

interp_regular       MATLAB   sorted = 1.92 ms     random = 1.59 ms  
interp_regular       MEX      sorted = 2.89 ms     random = 4.18 ms  

interp_fast          MATLAB   sorted = 3.62 ms     random = 18.61 ms 
interp_fast          MEX      sorted = 1.12 ms     random = 18.45 ms 

============================ vectorized call
```

* MEX files are not faster than MATLAB files.
* Sorted query points are better for `interp_fast`.
* The best overall algorithm is `griddedInterpolant`.
* **For vectorized call, `griddedInterpolant` should be prefered.**

### Non-Vectorized Call

All the 12500 query points are evaluated one by one (in a for-loop).

```
============================ non-vectorized call

interp1              MATLAB   sorted = 534.80 ms   random = 649.80 ms
interp1              MEX      sorted = 94.57 ms    random = 75.42 ms 

griddedInterpolant   MATLAB   sorted = 37.21 ms    random = 45.32 ms 
griddedInterpolant   MEX      sorted = NaN ms      random = NaN ms   

interp_regular       MATLAB   sorted = 45.32 ms    random = 29.57 ms 
interp_regular       MEX      sorted = 1.16 ms     random = 1.11 ms  

interp_fast          MATLAB   sorted = 11.36 ms    random = 27.46 ms 
interp_fast          MEX      sorted = 1.11 ms     random = 17.61 ms 

============================ non-vectorized call
```

* MEX files are faster than MATLAB files.
* Sorted query points are better for `interp_fast`.
* The best overall algorithm is `interp_regular` and `interp_fast`.
* **For non-vectorized call, `interp_regular` should be prefered with evenly spaced samples points.**
* **For non-vectorized call, `interp_fast` should be prefered with arbitrarily spaced samples points.**

## Compatibility

* Tested with MATLAB R2021a.
* The MATLAB Coder toolbox is required for compiling MATLAB into MEX.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## Author

**Thomas Guillod** - [GitHub Profile](https://github.com/otvam)

## License

This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
