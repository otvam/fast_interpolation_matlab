function get_test_check(x_vec, y_mat, x_vec_pts)
% Check the validity of interpolation data.
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_vec_pts - vector with the query points (float / row vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

validateattributes(x_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y_mat, {'double'},{'2d', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(x_vec_pts, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(size(x_vec, 2)==size(y_mat, 2), 'invalid size')
assert(all(diff(x_vec)>0), 'invalid order')

end