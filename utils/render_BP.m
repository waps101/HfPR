function im = render_BP( N,A,rho_s,eta,L )
%RENDER_BP Render with Blinn-Phong model

diffuse = render_diffuse( N,A,L );
H = L+[0 0 1]';
H = H./norm(H);
specular = render_diffuse( N,1,H ).^eta.*rho_s;

im = specular+diffuse;

end

