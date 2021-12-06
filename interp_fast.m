function [y_vec_pts, idx] = get_interp_fast(x_vec, y_mat, x_pts, idx_init)
% Extremely fast linear interpolation method.
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_pts - scalar with the query point (float / scalar)
%        idx_init - initial value for the location of the query point (integer / scalar)
%
%    Returns:
%        y_vec_pts - interpolated values (float / col vector)
%        idx - location of the query point (integer / scalar)
%
%    Row vector are considered for both the samples and query points.
%    If the sample values is a matrix, then each row contains a set of 1D values.
%
%    Linear interpolation inside the domain, linear extrapolation outside.
%
%    The following fast interpolation method is implemented:
%        - After each query, the position (index) of the point is returned.
%        - This index is used as an initial value for the next query point. 
%
%    This method reduces the computational cost if the query points are partially sorted.
%    In such cases, the complexity is reduced from O(n) to O(1).
%
%    This function can be compiled to a MEX file with the MATLAB Coder.
%    For reducing the computational cost, the size/type of the inputs are not checked.
%
%    Thomas Guillod.
%    2021 - BSD License.

% if no index is provided, search for one
if isnan(idx_init)
    idx_init = get_interp_init(x_vec, x_pts);
end

% update the index with respect to the provided query points
idx = get_interp_idx(x_vec, x_pts, idx_init);

% linear interpolation
y_vec_pts = get_interp_lin(x_vec, y_mat, x_pts, idx);

end

function idx = get_interp_init(x_vec, x_pts)
% Find the location of the query point without an initial guess.
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        x_pts - scalar with the query point (float / scalar)
%
%    Returns:
%        idx - location of the query point (integer / scalar)

% find the position of the query point
x_diff_vec = x_vec-x_pts;
x_diff_vec(x_diff_vec>0) = -Inf;
[~, idx] = max(x_diff_vec);

% the number of intervals is smaller than the number of points
if idx==length(x_vec)
    idx = length(x_vec)-1;
end

end

function idx = get_interp_idx(x_vec, x_pts, idx_init)
% Find the location of the query point with an initial guess.
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        x_pts - scalar with the query point (float / scalar)
%        idx_init - initial value for the location of the query point (integer / scalar)
%
%    Returns:
%        idx - location of the query point (integer / scalar)

% default case, initial guess is correct
idx = idx_init;

% initial guess is too small
if x_pts>x_vec(idx_init+1)
    for i=(idx_init+1):+1:(length(x_vec)-1)
        if x_vec(i+1)>=x_pts
            idx = i;
            break
        end
        idx = length(x_vec)-1;
    end
end

% initial guess is too large
if x_pts<x_vec(idx_init)
    for i=(idx_init-1):-1:1
        if x_vec(i)<=x_pts
            idx = i;
            break
        end
        idx = 1;
    end
end

end

function y_vec_pts = get_interp_lin(x_vec, y_mat, x_pts, idx)
% Extremely fast linear interpolation method.
%
%    Parameters:
%        x_vec - vector with the sample points (float / row vector)
%        y_mat - matrix with the sample values (float / matrix)
%        x_pts - scalar with the query point (float / scalar)
%        idx - location of the query point (integer / scalar)
%
%    Returns:
%        y_vec_pts - interpolated values (float / col vector)

% get the two samples points
x_1 = x_vec(idx);
x_2 = x_vec(idx+1);
y_1 = y_mat(:,idx);
y_2 = y_mat(:,idx+1);

% linear interpolation between the two points
slope = (y_2-y_1)./(x_2-x_1);
y_vec_pts = y_1+slope.*(x_pts-x_1);

end
