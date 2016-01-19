setup;

disp('Computing: Naive');
[N_Naive, A_Naive] = naive_PS(imgs, L, mask);

disp('Computing: RANSAC - HfPR');
[N_RANSAC, ~, Z_RANSAC] = ransac_ps(imgs, L, mask);

disp('Computing: Naive - HfPR');
[N_Model_Naive, ~, ~, ~, ~, Z_Model_Naive] =  guided_PS(imgs, L, N_Naive, A_Naive, 4, 1, mask);

angular_chart('Least-squared', N, N_Naive, mask);
angular_chart('Naive - HfPR', N, N_RANSAC, mask);
angular_chart('Least-squared', N, N_Model_Naive, mask);

