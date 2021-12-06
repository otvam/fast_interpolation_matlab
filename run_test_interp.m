function run_test_interp()

close('all')
addpath(genpath('src'))
addpath(genpath('test'))

%% interpolation data

x_vec = linspace(0, 1, 1000);
y_vec = [-1+x_vec+x_vec.^2 ; +1+x_vec-x_vec.^2; +2-x_vec-x_vec.^2];

%% query points

% inital query point, mostly sorted
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

%% evaluate the interpolation

% number of repetition to obtain reproducable timing
n_rep = 10;

% default matlab interp1, evaluate all the query points at once
default_vec = get_run(@get_test_default_vec, @get_test_default_vec_mex, x_vec, y_vec, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% default matlab interp1, evaluate the query points one by one in a loop
default_loop = get_run(@get_test_default_loop, @get_test_default_loop_mex, x_vec, y_vec, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% faster interpolation method, evaluate the query points one by one in a loop
fast = get_run(@get_test_fast, @get_test_fast_mex, x_vec, y_vec, x_vec_pts_sort, x_vec_pts_rand, n_rep);

%% display

% display the timing for the different methods
get_disp('default_vec', default_vec);
get_disp('default_loop', default_loop);
get_disp('fast', fast);

% compare the interpolation methods
get_cmp('default_vec vs. default_loop', default_loop, default_vec);
get_cmp('fast vs. default_loop', default_loop, fast);

end

function get_cmp(name, ref, cmp)

cmp_vec = [cmp.y_vec_pts_mat_sort cmp.y_vec_pts_mat_rand cmp.y_vec_pts_mex_sort cmp.y_vec_pts_mex_rand];
ref_vec = [ref.y_vec_pts_mat_sort ref.y_vec_pts_mat_rand ref.y_vec_pts_mex_sort ref.y_vec_pts_mex_rand];
err_vec = max(abs(cmp_vec-ref_vec), [], 2);

fprintf('============================ %s\n', name)
fprintf('\n')
fprintf('speedup / mat / sort = %.2fx / rand = %.2fx\n', ref.t_mat_sort./cmp.t_mat_sort, ref.t_mat_rand./cmp.t_mat_rand)
fprintf('speedup / mex / sort = %.2fx / rand = %.2fx\n', ref.t_mex_sort./cmp.t_mex_sort, ref.t_mex_rand./cmp.t_mex_rand)
fprintf('\n')
fprintf('error / max = %e\n', max(err_vec))
fprintf('\n')

end

function get_disp(name, timing)

fprintf('============================ %s\n', name)
fprintf('\n')
fprintf('timing / mat / sort = %.2fms / rand = %.2fms\n', 1e3.*timing.t_mat_sort, 1e3.*timing.t_mat_rand)
fprintf('timing / mex / sort = %.2fms / rand = %.2fms\n', 1e3.*timing.t_mex_sort, 1e3.*timing.t_mex_rand)
fprintf('\n')

end

function timing = get_run(fct_mat, fct_mex, x_vec, y_vec, x_vec_pts_sort, x_vec_pts_rand, n_rep)

[t_mat_sort, y_vec_pts_mat_sort] = get_time(fct_mat, x_vec, y_vec, x_vec_pts_sort, n_rep);
[t_mat_rand, y_vec_pts_mat_rand] = get_time(fct_mat, x_vec, y_vec, x_vec_pts_rand, n_rep);
[t_mex_sort, y_vec_pts_mex_sort] = get_time(fct_mex, x_vec, y_vec, x_vec_pts_sort, n_rep);
[t_mex_rand, y_vec_pts_mex_rand] = get_time(fct_mex, x_vec, y_vec, x_vec_pts_rand, n_rep);

timing.t_mat_sort = t_mat_sort;
timing.t_mat_rand = t_mat_rand;
timing.t_mex_sort = t_mex_sort;
timing.t_mex_rand = t_mex_rand;
timing.y_vec_pts_mat_sort = y_vec_pts_mat_sort;
timing.y_vec_pts_mat_rand = y_vec_pts_mat_rand;
timing.y_vec_pts_mex_sort = y_vec_pts_mex_sort;
timing.y_vec_pts_mex_rand = y_vec_pts_mex_rand;

end

function [t, y_vec_pts] = get_time(fct, x_vec, y_vec, x_vec_pts, n_rep)

t = tic();
for i=1:n_rep
    y_vec_pts  = fct(x_vec, y_vec, x_vec_pts);
end
t = toc(t)./n_rep;

end