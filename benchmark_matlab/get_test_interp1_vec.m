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
%    Thomas Guillod.
%    2021 - BSD License.

% check format
get_test_check(x_vec, y_mat, x_vec_pts);

% interpolate (for all sample points)
y_mat_pts = interp1(x_vec.', y_mat.', x_vec_pts.', 'linear', 'extrap').';

end
