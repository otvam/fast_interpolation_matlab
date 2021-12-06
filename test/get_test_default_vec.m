function y_vec_pts = get_test_default_vec(x_vec, y_vec, x_vec_pts)

y_vec_pts = interp1(x_vec.', y_vec.', x_vec_pts.', 'linear', 'extrap').';

end
