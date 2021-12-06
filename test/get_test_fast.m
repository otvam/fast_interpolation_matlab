function y_vec_pts = get_test_fast(x_vec, y_vec, x_vec_pts)

persistent idx;
idx = NaN;

y_vec_pts = zeros(size(y_vec, 1), size(x_vec_pts, 2));
for i=1:size(x_vec_pts, 2)
    [y_vec_pts(:,i), idx] = get_interp_fast(x_vec, y_vec, x_vec_pts(i), idx);
end

end
