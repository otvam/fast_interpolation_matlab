function y_mat_pts = interp_regular(x_min, x_max, y_mat, x_vec_pts)
% Extremely fast linear interpolation method with evenly spaced points.
%
%    Parameters:
%        x_min - minimum sample point value (float / scalar)
%        x_max - maximum sample point value (float / scalar)
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
%    This function can be compiled to a MEX file with the MATLAB Coder.
%    For reducing the computational cost, the size/type of the inputs are not checked.
%
%    Thomas Guillod.
%    2021 - BSD License.

% get space between samples
n = size(y_mat, 2);
dx = (x_max-x_min)./(n-1);

% get query point indices
idx = 1+floor((x_vec_pts-x_min)./dx);
idx(idx<=0) = 1;
idx(idx>=n) = n-1;

% get the slope
slope = (y_mat(:,idx+1)-y_mat(:,idx))./dx;

% get distance
dx_pts = x_vec_pts-x_min-(idx-1).*dx;

% interpolate
y_mat_pts = zeros(size(y_mat, 1), size(x_vec_pts, 2));
for i=1:size(y_mat, 1)
    y_mat_pts(i,:) = y_mat(i,idx)+slope(i,:).*dx_pts;
end

end