%% This script helps setting up the demo. 
% Please cite: W. A. P. Smith and F. Fang. "Height from Photometric Ratio 
% with Model-based Light Source Selection." Computer Vision and Image 
% Understanding (2015). if you use this code in your research.
%
% William A. P. Smith
% University of York
% 2015

%% Settings
% Please modify the variables here to change the demo.

% The level of noise in the image set. 
noise = 0;
% This demo contains two datasets, which are  "mozart" and "bunny". 
set_name = 'bunny';
% The number of images used for photometric stereo
numImages = 40;

%% Loading variables
% The lighting vector matrix is a 3xn matrx, n being the number of light
% sources. For this dataset, n = 40.
load('data/lighting.mat');
total_image_count = size(L, 2);

load(strcat('data/',set_name,'_depth.mat'));

%% Calculate the sample vector
% We randomly take light source vector samples. 
sv = randsample(1:total_image_count, numImages);

%% Processing the light source vector
L = -L(:, sv);

%% Processing to ensure sanity
mask = logical(mask);
mask = mask(:,:,1);
mask_index = find(mask(:)==1);

%% Re-compute the normal map just in case
N = depthnormals_mask( depth_gt,mask );

%% Generate the images
[ imgs ] = gen_img_mat( N, albedo, L );

%% Add noises, if required
if (noise > 0)
    imgs = imgs + Box_Muller(size(imgs),0,0.1,noise);
end