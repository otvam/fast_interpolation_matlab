function run_compile_mex()
% Compile the different test files into MEX files.
%
%    MEX files are significantly faster than MATLAB files.
%    A compiler should be installed and configured for the MATLAB Coder.
%
%    Thomas Guillod.
%    2021 - BSD License.

addpath(genpath('example'))

% define variable types
x_vec = coder.typeof(double(0), [1 Inf]);
y_mat = coder.typeof(double(0), [Inf Inf]);
x_vec_pts = coder.typeof(double(0), [1 Inf]);

% call the MEX compiler
codegen get_test_interp1_loop.m -args {x_vec, y_mat, x_vec_pts} -report -v	
codegen get_test_interp1_vec.m -args {x_vec, y_mat, x_vec_pts} -report -v	
codegen get_test_fast.m -args {x_vec, y_mat, x_vec_pts} -report -v	

% move the created files to the mex folder
[s, d] = rmdir('mex', 's');
[s, d] = mkdir('mex');
movefile('get_test_interp1_loop_mex.mexa64', 'mex')
movefile('get_test_interp1_vec_mex.mexa64', 'mex')
movefile('get_test_fast_mex.mexa64', 'mex')

end