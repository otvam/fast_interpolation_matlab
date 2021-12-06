function run_compile_mex()

addpath(genpath('src'))
addpath(genpath('test'))

x_vec = coder.typeof(double(0), [1 Inf]);
y_vec = coder.typeof(double(0), [Inf Inf]);
x_vec_pts = coder.typeof(double(0), [1 Inf]);

codegen get_test_default_loop.m -args {x_vec, y_vec, x_vec_pts} -report -v	
codegen get_test_default_vec.m -args {x_vec, y_vec, x_vec_pts} -report -v	
codegen get_test_fast.m -args {x_vec, y_vec, x_vec_pts} -report -v	

movefile('get_test_default_loop_mex.mexa64', 'test')
movefile('get_test_default_vec_mex.mexa64', 'test')
movefile('get_test_fast_mex.mexa64', 'test')

end