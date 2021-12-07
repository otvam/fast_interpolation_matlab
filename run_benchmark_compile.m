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

% file to be compiled
name = {...
    'get_test_interp1_loop',...
    'get_test_interp1_vec',...
    'get_test_interp_regular_loop',...
    'get_test_interp_regular_vec',...
    'get_test_interp_fast_loop',...
    'get_test_interp_fast_vec',...
    };

% call the MEX compiler
[s, d] = mkdir('benchmark_mex');
for i=1:length(name)
    codegen([name{i} '.m'], '-args', '{x_vec, y_mat, x_vec_pts}', '-report', '-v')	
    movefile([name{i} '_mex.mexa64'], 'benchmark_mex')
end

end