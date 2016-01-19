function [ img_mask, diff_stack, self_shadow_mask, diff_mean, diff_std, expect_img] = ...
    mask_gen(image_src, s_normal, s_albedo, light, obj_mask, threshold )
%guided_rough_mask_gen Generate the rough bit mask for guided photometric
%stereo
%   Detailed explanation goes here

% initialise variables
x = size(image_src, 1);
y = size(image_src, 2);
z = size(image_src, 3);
img_mask = false(x, y, z);
diff_mean = zeros(z, 1);
diff_std = zeros(z, 1);

% Re-render expected image, generate diff
expect_img = lamb_render_s_a(s_normal, s_albedo, light);
% diff_stack = expect_img - image_src;
diff_stack = zeros(x, y, z);

for i=1:z
    synthetic = squeeze(expect_img(:,:,i));
    actual = squeeze(image_src(:,:,i));
    temp = actual(obj_mask)./synthetic(obj_mask);
    scale = median(temp(~isnan(temp)&~isinf(temp)));
    diff_stack(:,:,i) = scale*synthetic- actual;
end

% Generate self-shadow mask
self_shadow_mask = expect_img <= 0;
% self_shadow_mask = (expect_img <= 0.01*median(expect_img(:))) | (image_src <= 0.01*median(image_src(:)));


for i=1:z
    img_diff = diff_stack(:,:,i);
    temp = img_diff(obj_mask);
    diff_mean(i) = 0;
    diff_std(i) = 1.4826 * nanmedian(abs(temp(:)));

    % pixels are selected if the difference is smaller than threshold,
    % and if it is not self-shadowed.
    img_mask(:,:,i)= ...
    (img_diff > (diff_mean(i) - threshold * diff_std(i))) & ...
    (img_diff < (diff_mean(i) + threshold * diff_std(i))) & ...
    ~self_shadow_mask(:,:,i) & ...
    obj_mask;
end
end

