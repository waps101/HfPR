setup;

disp('Computing: Naive');
[N_Naive, A_Naive] = naive_PS(imgs, L, mask);

disp('Computing: RANSAC - HfPR');
[N_RANSAC, ~, Z_RANSAC] = ransac_ps(imgs, L, mask);

disp('Computing: Naive - HfPR');
[N_Model_Naive, ~, ~, ~, ~, Z_Model_Naive] =  guided_PS(imgs, L, N_Naive, A_Naive, 4, 1, mask);

