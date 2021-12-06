function run_benchmark_compile()
% Compile the different test files into MEX files.
%
%    MEX files are significantly faster than MATLAB files.
%    A compiler should be installed and configured for the MATLAB Coder.
%
%    Thomas Guillod.
%    2021 - BSD License.

addpath(genpath('benchmark_matlab'))

% define variable types
x_vec = coder.typeof(double(0), [1 Inf]);
y_mat = coder.typeof(double(0), [Inf Inf]);
x_vec_pts = coder.typeof(double(0), [1 Inf]);

% call the MEX compiler
codegen get_test_interp1_loop.m -args {x_vec, y_mat, x_vec_pts} -report -v	
codegen get_test_interp1_vec.m -args {x_vec, y_mat, x_vec_pts} -report -v	
codegen get_test_interp_fast.m -args {x_vec, y_mat, x_vec_pts} -report -v	

% move the created files to the mex folder
[s, d] = mkdir('benchmark_mex');
movefile('get_test_interp1_loop_mex.mexa64', 'benchmark_mex')
movefile('get_test_interp1_vec_mex.mexa64', 'benchmark_mex')
movefile('get_test_interp_fast_mex.mexa64', 'benchmark_mex')

end