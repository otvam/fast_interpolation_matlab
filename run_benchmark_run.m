function run_benchmark_run()
% Compare the computational cost of different linear interpolation methods.
%
%    The follwing methods are compard:
%        - 'interp1', evaluate all the query points at once
%        - 'interp1', evaluate the query points one by one (in a for-loop)
%        - 'griddedInterpolant', evaluate all the query points at once
%        - 'griddedInterpolant', evaluate the query points one by one (in a for-loop)
%        - 'interp_fast', evaluate the query points one by one (in a for-loop)
%
%    The interpolation methods are tested with two different situations:
%        - many query points, the points are mostly sorted
%        - many query points, the order is random
%
%    For each method (except griddedInterpolant), MATLAB and MEX files are compared.
%
%    Thomas Guillod.
%    2021 - BSD License.

addpath(genpath('benchmark_matlab'))
addpath(genpath('benchmark_mex'))

%% interpolation data

% sample points (sorted)
x_vec = linspace(0, 1, 1000);

% sample values (3 rows)
y_mat = [-1+x_vec+x_vec.^2 ; +1+x_vec-x_vec.^2; +2-x_vec-x_vec.^2];

%% query points

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

%% evaluate the interpolation

% number of repetition to obtain reproducable timing
n_rep = 25;

% 'interp1', evaluate all the query points at once
interp1_vec = get_run(@get_test_interp1_vec, @get_test_interp1_vec_mex, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% 'interp1', evaluate the query points one by one (in a for-loop)
interp1_loop = get_run(@get_test_interp1_loop, @get_test_interp1_loop_mex, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% 'griddedInterpolant', evaluate all the query points at once
griddedInterpolant_vec = get_run(@get_test_griddedInterpolant_vec, [], x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% 'griddedInterpolant', evaluate the query points one by one (in a for-loop)
griddedInterpolant_loop = get_run(@get_test_griddedInterpolant_loop, [], x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% faster interpolation method, evaluate the query points one by one (in a for-loop)
interp_fast = get_run(@get_test_interp_fast, @get_test_interp_fast_mex, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

%% display

% display the timing for the different methods
get_disp_timing('interp1_vec', interp1_vec);
get_disp_timing('interp1_loop', interp1_loop);
get_disp_timing('griddedInterpolant_vec', griddedInterpolant_vec);
get_disp_timing('griddedInterpolant_loop', griddedInterpolant_loop);
get_disp_timing('interp_fast', interp_fast);

% display the error for the different methods 
get_disp_error('interp1_vec vs. interp_fast', interp1_vec, interp_fast);
get_disp_error('interp1_loop vs. interp_fast', interp1_loop, interp_fast);
get_disp_error('griddedInterpolant_vec vs. interp_fast', griddedInterpolant_vec, interp_fast);
get_disp_error('griddedInterpolant_loop vs. interp_fast', griddedInterpolant_loop, interp_fast);

end

function res = get_run(fct_mat, fct_mex, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep)
% Run and time an interpolation method.
%
%    Parameters:
%        fct_mat - function handle for the MATLAB version (handle)
%        fct_mex - function handle for the MEX version (handle)
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_vec_pts_sort - vector with the query points, mostly sorted (float / row vector)
%        x_vec_pts_rand - vector with the query points, random order (float / row vector)
%        n_rep - number of repetition to obtain reproducable timing (integer)
%
%    Returns:
%        timing - interpolated values and timing information (struct)

% test different combinations (MATLAB, MEX, query point order)
[t_mat_sort, y_mat_pts_mat_sort] = get_time(fct_mat, x_vec, y_mat, x_vec_pts_sort, n_rep);
[t_mat_rand, y_mat_pts_mat_rand] = get_time(fct_mat, x_vec, y_mat, x_vec_pts_rand, n_rep);
[t_mex_sort, y_mat_pts_mex_sort] = get_time(fct_mex, x_vec, y_mat, x_vec_pts_sort, n_rep);
[t_mex_rand, y_mat_pts_mex_rand] = get_time(fct_mex, x_vec, y_mat, x_vec_pts_rand, n_rep);

% assign results
res.t_mat_sort = t_mat_sort;
res.t_mat_rand = t_mat_rand;
res.t_mex_sort = t_mex_sort;
res.t_mex_rand = t_mex_rand;
res.y_mat_pts_mat_sort = y_mat_pts_mat_sort;
res.y_mat_pts_mat_rand = y_mat_pts_mat_rand;
res.y_mat_pts_mex_sort = y_mat_pts_mex_sort;
res.y_mat_pts_mex_rand = y_mat_pts_mex_rand;

end

function [t, y_mat_pts] = get_time(fct, x_vec, y_mat, x_vec_pts, n_rep)
% Run and time an interpolation method.
%
%    Parameters:
%        fct - function handle for the interpolation method (handle)
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_vec_pts - vector with the query points (float / row vector)
%        n_rep - number of repetition to obtain reproducable timing (integer)
%
%    Returns:
%        res - interpolated values and timing information (struct)

if isempty(fct)
    t = NaN;
    y_mat_pts = NaN(size(y_mat, 1), size(x_vec_pts, 2));
else
    t = tic();
    for i=1:n_rep
        y_mat_pts  = fct(x_vec, y_mat, x_vec_pts);
    end
    t = toc(t)./n_rep;
end

end

function get_disp_error(name, res_1, res_2)
% Display the error between two interpolation method.
%
%    Parameters:
%        name - name of the interpolation method (string)
%        res_1 - interpolated values and timing information (struct)
%        res_2 - interpolated values and timing information (struct)

res_2_vec = [res_2.y_mat_pts_mat_sort res_2.y_mat_pts_mat_rand res_2.y_mat_pts_mex_sort res_2.y_mat_pts_mex_rand];
res_1_vec = [res_1.y_mat_pts_mat_sort res_1.y_mat_pts_mat_rand res_1.y_mat_pts_mex_sort res_1.y_mat_pts_mex_rand];
err_vec = max(abs(res_2_vec-res_1_vec), [], 2);

fprintf('============================ %s\n', name)
fprintf('\n')
fprintf('error / max = %e\n', max(err_vec))
fprintf('error / mean = %e\n', mean(err_vec))
fprintf('\n')

end

function get_disp_timing(name, res)
% Display the timing information for an interpolation method.
%
%    Parameters:
%        name - name of the interpolation method (string)
%        res - interpolated values and timing information (struct)

fprintf('============================ %s\n', name)
fprintf('\n')
fprintf('timing / mat / sort = %.2f ms / rand = %.2f ms\n', 1e3.*res.t_mat_sort, 1e3.*res.t_mat_rand)
fprintf('timing / mex / sort = %.2f ms / rand = %.2f ms\n', 1e3.*res.t_mex_sort, 1e3.*res.t_mex_rand)
fprintf('\n')

end
