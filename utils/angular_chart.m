function [ ] = angular_chart(method_name, N_true, N_LS, mask)


[h, w] = size(mask);
m = find(mask(:)==1);


figure;

subplot(1,2,1)
imagesc(uint8((N_LS+1)*128));
title(['Normal (', method_name,  ')']);
axis equal;
axis off;

[meanA_LS, ~, ~, ~, angle_LS]  = normalAngleEval(N_true, N_LS, m(:));
disp(['Median Anglular error of', method_name, ' method is: ', num2str(meanA_LS)]);


subplot(1,2,2)
AngleMat = zeros(h*w,1);
AngleMat(m) = angle_LS;
AngleMat = reshape(AngleMat, h, w);
imagesc(AngleMat);
title(['Error (', method_name, ')']);
axis equal;
axis off;


end

