function run_example_simple()
% Simple example for the fast interpolation method.
%
%    Thomas Guillod.
%    2021 - BSD License.

%% interpolation data

% sample points (sorted)
x_vec = [0 1 2 3 4 5 6];

% sample values (2 rows)
y_mat = [4 5 6 7 8 9 10 ; 2 4 5 2 2 6 8];

% query points
x_vec_pts = linspace(-2, 8, 100);

%% run

% get evenly spaced points
x_min = min(x_vec);
x_max = max(x_vec);

% initialize to an unknow index
idx = NaN;

% call the interpolant
y_mat_pts_regular = interp_regular(x_min, x_max, y_mat, x_vec_pts);
y_mat_pts_fast = interp_fast(x_vec, y_mat, x_vec_pts, idx);

%% plot

% init
figure()
hold('on')
grid('on')

% plot interpolated data
plot(x_vec_pts.', y_mat_pts_fast.', '-')
plot(x_vec_pts.', y_mat_pts_regular.', '--')

% plot samples
plot(x_vec.', y_mat.', 'o')

end
