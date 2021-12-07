function y_mat_pts = get_test_interp1_vec(x_vec, y_mat, x_vec_pts)
% Linear interpolation using 'interp1' (evaluate all the query points at once).
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
%    Thomas Guillod.
%    2021 - BSD License.

% check format
get_test_check(x_vec, y_mat, x_vec_pts);

% use interp1 with a vector input
y_mat_pts = interp1(x_vec.', y_mat.', x_vec_pts.', 'linear', 'extrap').';

end
