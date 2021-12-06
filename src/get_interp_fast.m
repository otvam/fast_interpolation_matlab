function [y_pts, idx] = get_interp_fast(x_vec, y_vec, x_pts, idx)

if isnan(idx)
    idx = get_interp_init(x_vec, x_pts);
end

idx = get_interp_idx(x_vec, x_pts, idx);
y_pts = get_interp_lin(x_vec, y_vec, x_pts, idx);

end
