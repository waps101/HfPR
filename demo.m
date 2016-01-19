% Please cite: W. A. P. Smith and F. Fang. "Height from Photometric Ratio
% with Model-based Light Source Selection." Computer Vision and Image
% Understanding (2015). if you use this code in your research.
%
% William A. P. Smith
% University of York
% 2015

setup;

disp('Computing: Naive');
[N_Naive, A_Naive] = naive_PS(imgs, L, mask);

disp('Computing: RANSAC - HfPR');
[N_RANSAC, ~, Z_RANSAC] = ransac_ps(imgs, L, mask);

disp('Computing: Naive - HfPR');
[N_Model_Naive, ~, ~, ~, ~, Z_Model_Naive] =  guided_PS(imgs, L, N_Naive, A_Naive, 4, 1, mask);



gen_chart('Least-squared', N, N_Naive, mask);
gen_chart('RANSAC - HfPR', N, N_RANSAC, mask, depth_gt, Z_RANSAC);
gen_chart('Naive - HfPR', N, N_Model_Naive, mask, depth_gt, Z_Model_Naive);

