function run_benchmark_run()
% Compare the computational cost of different linear interpolation methods.
%
%    The follwing methods are compard:
%        - 'interp1', evaluate all the query points at once
%        - 'interp1', evaluate the query points one by one (in a for-loop)
%        - 'griddedInterpolant', evaluate all the query points at once
%        - 'griddedInterpolant', evaluate the query points one by one (in a for-loop)
%        - 'interp_regular', evaluate all the query points at once
%        - 'interp_regular', evaluate the query points one by one (in a for-loop)
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

% sample points (sorted and evenly spaced)
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

% interp1
fct.vec_mat = @get_test_interp1_vec;
fct.vec_mex = @get_test_interp1_vec_mex;
fct.loop_mat = @get_test_interp1_loop;
fct.loop_mex = @get_test_interp1_loop_mex;
res_interp1 = get_run(fct, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% griddedInterpolant
fct.vec_mat = @get_test_griddedInterpolant_vec;
fct.vec_mex = [];
fct.loop_mat = @get_test_griddedInterpolant_loop;
fct.loop_mex = [];
res_griddedInterpolant = get_run(fct, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% interp_regular
fct.vec_mat = @get_test_interp_regular_vec;
fct.vec_mex = @get_test_interp_regular_vec_mex;
fct.loop_mat = @get_test_interp_regular_loop;
fct.loop_mex = @get_test_interp_regular_loop_mex;
res_interp_regular = get_run(fct, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

% interp_fast_loop
fct.vec_mat = @get_test_interp_fast_vec;
fct.vec_mex = @get_test_interp_fast_vec_mex;
fct.loop_mat = @get_test_interp_fast_loop;
fct.loop_mex = @get_test_interp_fast_loop_mex;
res_interp_fast = get_run(fct, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep);

%% display

fprintf('============================ vectorized call\n')
fprintf('\n')
get_disp_timing('vec', 'interp1', res_interp1);
fprintf('\n')
get_disp_timing('vec', 'griddedInterpolant', res_griddedInterpolant);
fprintf('\n')
get_disp_timing('vec', 'interp_regular', res_interp_regular);
fprintf('\n')
get_disp_timing('vec', 'interp_fast', res_interp_fast);
fprintf('\n')
fprintf('============================ vectorized call\n')

fprintf('============================ non-vectorized call\n')
fprintf('\n')
get_disp_timing('loop', 'interp1', res_interp1);
fprintf('\n')
get_disp_timing('loop', 'griddedInterpolant', res_griddedInterpolant);
fprintf('\n')
get_disp_timing('loop', 'interp_regular', res_interp_regular);
fprintf('\n')
get_disp_timing('loop', 'interp_fast', res_interp_fast);
fprintf('\n')
fprintf('============================ non-vectorized call\n')

end

function res = get_run(fct, x_vec, y_mat, x_vec_pts_sort, x_vec_pts_rand, n_rep)
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

% test different combinations (all the query points at once)
res.t_vec_mat_sort = get_time(fct.vec_mat, x_vec, y_mat, x_vec_pts_sort, n_rep);
res.t_vec_mat_rand = get_time(fct.vec_mat, x_vec, y_mat, x_vec_pts_rand, n_rep);
res.t_vec_mex_sort = get_time(fct.vec_mex, x_vec, y_mat, x_vec_pts_sort, n_rep);
res.t_vec_mex_rand = get_time(fct.vec_mex, x_vec, y_mat, x_vec_pts_rand, n_rep);

% test different combinations (loop over the query points)
res.t_loop_mat_sort = get_time(fct.loop_mat, x_vec, y_mat, x_vec_pts_sort, n_rep);
res.t_loop_mat_rand = get_time(fct.loop_mat, x_vec, y_mat, x_vec_pts_rand, n_rep);
res.t_loop_mex_sort = get_time(fct.loop_mex, x_vec, y_mat, x_vec_pts_sort, n_rep);
res.t_loop_mex_rand = get_time(fct.loop_mex, x_vec, y_mat, x_vec_pts_rand, n_rep);

end

function t = get_time(fct, x_vec, y_mat, x_vec_pts, n_rep)
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
%        t - mean run time (float)

if isempty(fct)
    t = NaN;
else
    t = tic();
    for i=1:n_rep
        y_mat_pts  = fct(x_vec, y_mat, x_vec_pts);
    end
    t = toc(t)./n_rep;
    assert(isnumeric(y_mat_pts), 'invalid data')
end

end

function get_disp_timing(type, name, res)
% Display the timing information for an interpolation method.
%
%    Parameters:
%        type - type of data to display (string)
%        name - name of the interpolation method (string)
%        res - interpolated values and timing information (struct)

switch type
    case 'vec'
        t_mat_sort = res.t_vec_mat_sort;
        t_mat_rand = res.t_vec_mat_rand;
        t_mex_sort = res.t_vec_mex_sort;
        t_mex_rand = res.t_vec_mex_rand;
    case 'loop'
        t_mat_sort = res.t_loop_mat_sort;
        t_mat_rand = res.t_loop_mat_rand;
        t_mex_sort = res.t_loop_mex_sort;
        t_mex_rand = res.t_loop_mex_rand;
    otherwise
        error('invalid data')
end

name = pad(name, 18);
t_mat_sort = pad(sprintf('%.2f ms', 1e3.*t_mat_sort), 9);
t_mat_rand = pad(sprintf('%.2f ms', 1e3.*t_mat_rand), 9);
t_mex_sort = pad(sprintf('%.2f ms', 1e3.*t_mex_sort), 9);
t_mex_rand = pad(sprintf('%.2f ms', 1e3.*t_mex_rand), 9);

fprintf('%s   MATLAB   sorted = %s   random = %s\n', name, t_mat_sort, t_mat_rand)
fprintf('%s   MEX      sorted = %s   random = %s\n', name,t_mex_sort, t_mex_rand)

end
