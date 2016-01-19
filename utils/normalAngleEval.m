function [medianA, varA, stdA, maxA, angle] =  normalAngleEval(N_true, N_est, maskindex)

% Calculate the angle between ground truth and estimated surface normal
% N_true and N_est should be (height X width X 3) vectors (unit vector)
masklength = length(maskindex);
N_true1  = zeros(masklength, 3);
N_est1  = zeros(masklength, 3);
for i = 1 : 3
     temp1 = N_true(:, :, i);
     N_true1(:, i) = temp1(maskindex);
     
     temp2 = N_est(:, :, i);
     N_est1(:, i) = temp2(maskindex);
end
dotM = dot(N_true1, N_est1, 2);
angle = (180 .* acos(dotM)) ./ pi;
angle = real(angle);
medianA = nanmedian(angle);
varA = var(angle);
stdA = std(angle);
maxA = max(angle);