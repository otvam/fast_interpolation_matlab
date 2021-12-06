function y_mat_pts = get_test_interp1_loop(x_vec, y_mat, x_vec_pts)
% Linear interpolation using 'interp1' (evaluate the query points one by one (in a for-loop)).
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_vec_pts - vector with the query points (float / row vector)
%
%    Returns:
%        y_mat_pts - interpolated values (float / matrix)
%
%    Row vector are considered for both the samples and query points.
%    If the sample values is a matrix, then each row contains a set of 1D values.
%
%    Linear interpolation inside the domain, linear extrapolation outside.
%
%    Evaluating the query points one by one (in a for-loop) is suboptimal and slow.
%    This should only be done is required (interdependency between the query points).
%
%    Thomas Guillod.
%    2021 - BSD License.

% check format
validateattributes(x_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y_mat, {'double'},{'2d', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(x_vec_pts, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(size(x_vec, 2)==size(y_mat, 2), 'invalid size')

% init the solution vector
y_mat_pts = zeros(size(y_mat, 1), size(x_vec_pts, 2));

% use interp1 with a scalar input (for each sample point)
for i=1:size(x_vec_pts, 2)
    y_mat_pts(:,i) = interp1(x_vec.', y_mat.', x_vec_pts(i), 'linear', 'extrap').';
end

end
