function [ render ] = lamb_render_s(normal, albedo, light_source)
%% lamb_render Lambertian render a surface normal using a point source.
%   [ render ] = lamb_render_s(normal, albedo, light_source)
%   Where normal is a 4D matrix with a normal for each colour channel
%         light_source is a 3x1 vector for the incoming light.
%   format: (l, w, rgb, xyz)
render = albedo.*(max(normal(:,:,1).*light_source(1) + ...
                 normal(:,:,2).*light_source(2) + ...
                 normal(:,:,3).*light_source(3),0));
end

