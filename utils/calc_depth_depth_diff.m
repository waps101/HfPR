function [diff, diff_map] = calc_depth_depth_diff( depth_a, depth_b, mask )
%CALC_DEPTH_DIFF Calculate the difference between two depth maps
depth_a(isinf(depth_a)) = nan;
depth_b(isinf(depth_b)) = nan;
depth_a = depth_a - nanmean(depth_a(mask));
depth_b = depth_b - nanmean(depth_b(mask));
diff = sqrt(meansqr(depth_a(mask)- depth_b(mask)));
diff_map = sqrt((depth_a - depth_b).^2);
end

