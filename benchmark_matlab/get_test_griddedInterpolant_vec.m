function y_mat_pts = get_test_griddedInterpolant_vec(x_vec, y_mat, x_vec_pts)
% Linear interpolation using 'griddedInterpolant' (evaluate all the query points at once).
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

% use griddedInterpolant with a vector input
fct = griddedInterpolant(x_vec.', y_mat.', 'linear', 'linear');
y_mat_pts = fct(x_vec_pts.').';

end
