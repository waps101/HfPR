function [ normal,albedo, height, N_RANSAC, A_RANSAC] = RANSACPS(images, L, mask)
%PS_RANSAC Summary of this function goes here
%   Detailed explanation goes here

% This is a threshold that determines what is considered an outlier. For
% any observation where abs(i-n.l)>t, the observation will be excluded.
% A value of 0.05 seems reasonable for the Harvard data. For synthetic,
% this can be set lower (if no noise).
t = 0.05;

x = size(images,1);
y = size(images,2);

N_RANSAC = zeros(x, y, 3);
A_RANSAC = zeros(x, y);

L = L';

parfor i = 1:x
    for j = 1:y
        if mask(i,j)
            I = squeeze(images(i,j,:));
            % Only retain observations brighter than a shadow threshold
            nonshadow = find(I>0.01);
            L2 = L(nonshadow,:);
            I2 = I(nonshadow,1);
            [~, inliers_ind] = ransac([L2 I2]', @(x) fittingfn(x), @(M,x,t) distfn(M,x,t), @(x) isdegenerate(x), 3, t);
            % Of the non-shadowed observations, select those that RANSAC
            % considers inliers
            inliers = nonshadow(inliers_ind);
            % If we want to use these selections for later, need to store
            % inliers for each pixel and then compute pairs
            
            %%% Comment out if pairs not needed
            %for k=1:length(inliers)-1
            %    pairs{i,j}(k,:)=inliers([k k+1]);
            %end
            %pairs{i,j}(length(inliers),:)=inliers([1 length(inliers)]);
            %%%
            
            normal = L(inliers,:)\I(inliers,1);
            N_RANSAC(i,j,:) = normal./norm(normal);
            A_RANSAC(i,j) = norm(normal);
        end
    end
end

L = L';

[normal, albedo, ~, ~, ~, height] = guided_PS(images, L, N_RANSAC, A_RANSAC, 4, 1, mask);

end

