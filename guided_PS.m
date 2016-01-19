function [p_normal, p_albedo, img_mask, expect_img, diff_stack, p_height] = guided_PS(image_src, light, s_normal, s_albedo, min_img, threshold, obj_mask)
%% guided_PS Point source photometric stereo using surface normal and albedo to guide the pixel selection process.
%   [p_normal, p_albedo, img_mask, expect_img] = guided_PS(image_src, light, s_normal, s_albedo, min_img, threshold)
%   image_src is the input image,
%   light is the light source direction
%   s_normal is the surface normal for pixel selection guidance
%   s_albedo is the albedo map for pixel selection guidance
%   min_img is the minimum number of images used for each pixel
%   threshold is the re-rendering difference threshold for pixel selection

%% Load variables
% determine image size
x = size(image_src, 1);
y = size(image_src, 2);
z = size(image_src, 3);

%% Generate bit mask
[ img_mask, diff_stack, self_shadow_mask, diff_mean, diff_std, expect_img] = ...
    mask_gen(image_src, s_normal, s_albedo, light, obj_mask, threshold );

%% Calculate the surface normal
disp('Generating fine mask');
parfor i = 1:x
    for j = 1:y
        % Mask variables
        mask_col = squeeze(img_mask(i,j,:));
        self_shadow_mask_col = squeeze(self_shadow_mask(i,j,:));
        diff_stack_col = squeeze(diff_stack(i,j,:));

        % Mask refinement
        [ mask_col , ~ ] = mask_refine(...
            mask_col, self_shadow_mask_col, diff_stack_col, diff_mean, diff_std, min_img, z);
        img_mask(i,j,:) = mask_col;
    end
end

%% Will Smith's pipeline

% Generate valid image pairs
valid_pairs = mask_to_pair(img_mask);
% Actual calculation
[p_height, p_normal, p_albedo] = HfPR(image_src, valid_pairs, light, obj_mask);
end

