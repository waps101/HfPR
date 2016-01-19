function [ result ] = run_once(set_name, numImages, noise, itr_count)
%%RUN_ONCE Generate results for a single entry in the final table.

%% Actual computation


%% Generate results
% Integrated naive height vs naive guided height
Z_Naive = g2s_wrap(N_Naive, mask);
[Z_Naive_diff] = calc_depth_depth_diff( Z_Naive, depth_gt, mask );
[Z_Model_Naive_diff] = calc_depth_depth_diff( Z_Model_Naive, depth_gt, mask );

% HfPR using RANSAC without guidance vs RANSAC normal guided height
[Z_RANSAC_diff] = calc_depth_depth_diff( Z_RANSAC, depth_gt, mask );

% Integrated SBL vs SBL guided model height
[Z_SBL] = g2s_wrap( N_SBL, mask );
[Z_SBL_diff] = calc_depth_depth_diff( Z_SBL, depth_gt, mask );
[Z_Model_SBL_diff] = calc_depth_depth_diff( Z_Model_SBL, depth_gt, mask );

[medianA_RANSAC, ~, ~, ~, ~]  = normalAngleEval(N, N_RANSAC, mask_index);
[medianA_Naive, ~, ~, ~, ~]  = normalAngleEval(N, N_Naive, mask_index);
[medianA_Model_Naive, ~, ~, ~, ~]  = normalAngleEval(N, N_Model_Naive, mask_index);
[medianA_SBL, ~, ~, ~, ~]  = normalAngleEval(N, N_SBL, mask_index);
[medianA_Model_SBL, ~, ~, ~, ~]  = normalAngleEval(N, N_Model_SBL, mask_index);


end
