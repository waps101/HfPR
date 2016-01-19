function [ render_out] = lamb_render_s_a(normal, albedo, light)
%% lamb_render_s_a Re-render surface normal using input light source, 
%   [ render_out] = lamb_render_s_a(normal, albedo, light)
%   plot the result against original image

render_out = zeros(size(albedo, 1), size(albedo,2), size(light, 2));

for i = 1:size(light, 2)
    render_out(:,:,i) = lamb_render_s(normal, albedo, ...
        squeeze(light(:,i)));
end
