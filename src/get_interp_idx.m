function idx = get_interp_idx(x_vec, x_pts, idx_old)

idx = idx_old;
if x_pts>x_vec(idx_old+1)
    for i=(idx_old+1):+1:(length(x_vec)-1)
        if x_vec(i+1)>=x_pts
            idx = i;
            break
        end
        idx = length(x_vec)-1;
    end
end
if x_pts<x_vec(idx_old)
    for i=(idx_old-1):-1:1
        if x_vec(i)<=x_pts
            idx = i;
            break
        end
        idx = 1;
    end
end

end
