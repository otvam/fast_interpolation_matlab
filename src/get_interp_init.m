function idx = get_interp_init(x_vec, x_pts)

x_diff_vec = x_vec-x_pts;

idx = x_diff_vec>0;
x_diff_vec(idx) = -Inf;

[~, idx] = max(x_diff_vec);

if idx==length(x_vec)
    idx = length(x_vec)-1;
end

end