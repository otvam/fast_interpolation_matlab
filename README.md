# MATLAB Code for Fast Linear Interpolation

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - science](https://img.shields.io/badge/category-science-lightgrey)
![status - maintained](https://img.shields.io/badge/status-maintained-green)

The **MATLAB code** offers a fast **1D linear interpolation** method.

The following **fast** interpolation **method** is implemented:
* Linear interpolation inside the domain, linear extrapolation outside.
* Support vector or matrix (set of 1D values) for the sample values.
* This algorithm can be **up to 30x faster** than the MATLAB builtin interpolation methods.

The following **algorithm** is used:
* After each query, the position (index) of the point is returned.
* This index is used as an initial value for the next query point.
* Hence, the computational cost is reduced if the query points are partially sorted.
* In such cases, the complexity is reduced from O(n) to O(1).

This method should be **used in the following case**:
* Many calls are done with the same sample points and values.
* The calls cannot be vectorized (interdepency between the query points).
* A typical use case is ODE integration where the calls cannot be vectorized.

This function can be compiled to a **MEX** file with the **MATLAB Coder**.

## Examples

* [interp_fast.m](interp_fast.m) - Implementation of the fast interpolation method.
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
* `interp_fast` code (the proposed method, MATLAB and MEX)
* `interp1` code (MATLAB builtin function, MATLAB and MEX)
* `griddedInterpolant` code (MATLAB builtin function, MATLAB)
* In this document, the benchmark is run on a Intel i5-8250U laptop on Linux (64 bits).

The following files are required to run the benchmark:
* [run_benchmark_compile.m](run_benchmark_compile.m) - Compile the MATLAB files into MEX files.
* [run_benchmark_run.m](run_benchmark_run.m) - Run the benchmark.

### Vectorized Call

All the 12500 query points are evaluated at once with a vectorized call.

| Method               | Type   | Order  | Time        |
| -------------------- |--------| -------|-------------| 
| `interp1`            | MATLAB | Sorted | 0.75ms      |
| `interp1`            | MATLAB | Random | 0.65ms      |
| `interp1`            | MEX    | Sorted | 0.61ms      |
| `interp1`            | MEX    | Random | 0.82ms      |
|                      |        |                      | 
| `griddedInterpolant` | MATLAB | Sorted | **0.16ms**  |
| `griddedInterpolant` | MATLAB | Random | **0.21ms**  |
|                      |        |                      | 
| `interp_fast`        | MATLAB | Sorted | 6.87ms      |
| `interp_fast`        | MATLAB | Random | 21.74ms     |
| `interp_fast`        | MEX    | Sorted | 1.03ms      |
| `interp_fast`        | MEX    | Random | 12.94ms     |

For vectorized call, the following conclusions are drawn:
* MEX files are not faster than MATLAB files for `interp1`.
* MEX files are faster than MATLAB files for `interp_fast`.
* Sorted query points are better for `interp_fast`.
* The best overall algorithm is `griddedInterpolant`.

**For vectorized call, `griddedInterpolant` should be prefered.**

### Non-Vectorized Call

All the 12500 query points are evaluated one by one (in a for-loop).

| Method               | Type   | Order  | Time        |
| -------------------- |--------| -------|-------------| 
| `interp1`            | MATLAB | Sorted | 483.33ms    |
| `interp1`            | MATLAB | Random | 531.44ms    |
| `interp1`            | MEX    | Sorted | 70.01ms     |
| `interp1`            | MEX    | Random | 69.60ms     |
|                      |        |                      | 
| `griddedInterpolant` | MATLAB | Sorted | 34.31ms     |
| `griddedInterpolant` | MATLAB | Random | 34.56ms     |
|                      |        |                      |
| `interp_fast`        | MATLAB | Sorted | 6.87ms      |
| `interp_fast`        | MATLAB | Random | 21.74ms     |
| `interp_fast`        | MEX    | Sorted | **1.03ms**  |
| `interp_fast`        | MEX    | Random | **12.94ms** |

For vectorized call, the following conclusions are drawn:
* MEX files are faster than MATLAB files for `interp1`.
* MEX files are faster than MATLAB files for `interp_fast`.
* Sorted query points are better for `interp_fast`.
* The best overall algorithm is `interp_fast`.

**For non-vectorized call, `interp_fast` should be prefered.**

## Compatibility

* Tested with MATLAB R2021a.
* The MATLAB Coder toolbox is required for compiling MATLAB into MEX.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## Author

**Thomas Guillod** - [GitHub Profile](https://github.com/otvam)

## License

This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
