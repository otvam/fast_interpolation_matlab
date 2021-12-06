function y_pts = get_interp_lin(x_vec, y_vec, x_pts, idx)

x_1 = x_vec(idx);
x_2 = x_vec(idx+1);
y_1 = y_vec(:,idx);
y_2 = y_vec(:,idx+1);

slope = (y_2-y_1)./(x_2-x_1);
y_pts = y_1+slope.*(x_pts-x_1);

end
