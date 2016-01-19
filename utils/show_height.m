function [] = show_height( input_args )
%show_height Display the photometric ratio height map in a sensible way

a = surf(input_args','EdgeColor','none','FaceColor',[1 1 1],'AmbientStrength',0,'SpecularStrength',0,'DiffuseStrength',1, 'FaceLighting', 'gouraud');
light('Position',[0 0 1],'Style','infinite');
axis equal;
axis off;

end

