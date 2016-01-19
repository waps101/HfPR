function [ ] = gen_chart(method_name, N_true, N_LS, mask, depth_a, depth_b)

if exist('depth_a', 'var')
    numchart = 3;
else
    numchart = 2;
end

[h, w] = size(mask);
m = find(mask(:)==1);

figure;

subplot(1,numchart,1)
imagesc(uint8((N_LS+1)*128));
title(['Normal (', method_name,  ')']);
axis equal;
axis off;

[meanA_LS, ~, ~, ~, angle_LS]  = normalAngleEval(N_true, N_LS, m(:));
disp(['Median Anglular error of ', method_name, ' method is: ', num2str(meanA_LS)]);


subplot(1,numchart,2)
AngleMat = zeros(h*w,1);
AngleMat(m) = angle_LS;
AngleMat = reshape(AngleMat, h, w);
imagesc(AngleMat);
title(['Error (', method_name, ')']);
axis equal;
axis off;

if numchart == 3
    subplot(1,3,3)
    [z_diff, diff_map] = calc_depth_depth_diff( depth_a, depth_b, mask );
    disp(['The mean-squared error of ', method_name, 'method is: ', num2str(z_diff)]);
    imagesc(diff_map);
    title(['Depth Error (', method_name, ')']);
    axis equal;
    axis off;
end

end

