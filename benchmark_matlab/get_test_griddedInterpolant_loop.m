function y_mat_pts = get_test_griddedInterpolant_loop(x_vec, y_mat, x_vec_pts)
% Linear interpolation using 'griddedInterpolant' (evaluate the query points one by one (in a for-loop)).
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_vec_pts - vector with the query points (float / row vector)
%
%    Returns:
%        y_mat_pts - interpolated values (float / matrix)
%
%    Evaluating the query points one by one (in a for-loop) is suboptimal and slow.
%    This should only be done if required (interdependency between the query points).
%
%    Thomas Guillod.
%    2021 - BSD License.


% check format
get_test_check(x_vec, y_mat, x_vec_pts);

% init the solution vector
y_mat_pts = zeros(size(y_mat, 1), size(x_vec_pts, 2));

% init the interpolant
fct = griddedInterpolant(x_vec.', y_mat.', 'linear', 'linear');

% interpolate (for each sample point)
for i=1:size(x_vec_pts, 2)
    y_mat_pts(:,i) = fct(x_vec_pts(i)).';
end

end
