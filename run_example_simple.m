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

% persistent variable tracking the index of the last query point
persistent idx;

% initialize to an unknow index
idx = NaN;

% call the interpolant
for i=1:length(x_vec_pts)
    [y_mat_pts(:,i), idx] = interp_fast(x_vec, y_mat, x_vec_pts(i), idx);
end

%% plot

% init
figure()
hold('on')
grid('on')

% plot interpolated data
plot(x_vec_pts.', y_mat_pts.', '-')

% plot samples
plot(x_vec.', y_mat.', 'o')

end
