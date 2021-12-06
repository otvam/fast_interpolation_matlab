function y_vec_pts = get_test_default_loop(x_vec, y_vec, x_vec_pts)

y_vec_pts = zeros(size(y_vec, 1), size(x_vec_pts, 2));
for i=1:size(x_vec_pts, 2)
    y_vec_pts(:,i) = interp1(x_vec.', y_vec.', x_vec_pts(i), 'linear', 'extrap').';
end

end
