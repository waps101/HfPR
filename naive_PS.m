function [ normal, albedo ] = naive_PS(image_m, light, mask)
%% PointSN_n Naive point source photometric stereo
%   normal = naive_PS(image_m, light)

n_list = reshape(image_m, [], size(image_m,3))/ light;
normal = reshape(n_list, [ size(image_m,1) size(image_m,2) ,3 ]);
normal(~mask) = nan;

% Normalisation of the surface normal
albedo = sqrt(normal(:,:,1).^2 + normal(:,:,2).^2 + ...
                normal(:,:,3).^2);
for i = 1:3
        normal(:,:,i) = normal(:,:,i) ./ albedo;
end

end
