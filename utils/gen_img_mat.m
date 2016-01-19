function [ I ] = gen_img_mat(N, albedo, L)
%GEN_IMG_MAT Generate the image matrix
for i=1:size(L,2)
    l = L(:,i);
    sl = l;
    sl(1) = -l(2);
    sl(2) = l(1);
    I(:,:,i)=render_BP(N,albedo,0.5,75,l)./1.5;
end

end
