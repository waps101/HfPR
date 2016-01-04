function [height,normals,albedo] = HfPR( images,pairs,L,mask )
%HFPR Height from photometric ratio
%   images is rows*cols*nimages
%   pairs is a rows*cols cell array where each entry is a k*2 matrix where
%   k depends on the number of pairs for that pixel
%   L is a 3*nimages matrix of light source vectors
%   mask is a rows*cols binary foreground mask
%
% Please cite: W. A. P. Smith and F. Fang. "Height from Photometric Ratio 
% with Model-based Light Source Selection." Computer Vision and Image 
% Understanding (2015). if you use this code in your research.
%
% William A. P. Smith
% University of York
% 2015

rows = size(mask,1);
cols = size(mask,2);
nimages = size(images,3);

% Pad to avoid boundary problems
images2 = zeros(rows+2,cols+2,nimages);
for i=1:nimages
    images2(2:rows+1,2:cols+1,i)=images(:,:,i);
end
images = images2;
clear images2
mask2 = zeros(rows+2,cols+2);
mask2(2:rows+1,2:cols+1)=mask;
mask = mask2;
clear mask2
rows = rows+2;
cols = cols+2;

% Build lookup table relating x,y coordinate of valid pixels to index
% position in vectorised representation
count = 0;
indices = zeros(size(mask));
for row=1:rows
    for col=1:cols
        if mask(row,col)
            count=count+1;
            indices(row,col)=count;
        end
    end
end

% Put here the maximum number of pairs that any one pixel has - it's just
% used to allocate enough space (worst case) for the sparse matrix indices
% This could be computed from the number of images
maxpairsperpix = 15;

% The number of usable pixels
npix = sum(mask(:));

disp(['Using ' num2str(npix) ' pixels'])

% Preallocate maximum required space
% This would be if all valid pixels had equations for all 8 neighbours for
% all possible pairs of images - it will be less in practice
i = zeros(npix*8*maxpairsperpix,1);
j = zeros(npix*8*maxpairsperpix,1);
s = zeros(npix*8*maxpairsperpix,1);

% Right hand side of linear system:
d = zeros(npix*maxpairsperpix,1);

NumEq = 0; % number of rows in matrix
k=0; % total number of non-zero entries in matrix

for row=1:rows
    for col=1:cols
        if mask(row,col)
            % For all pairs for this pixel...
            for light=1:size(pairs{row-1,col-1},1)
                
                % Extract relevant pair of intensities and light source
                % vectors
                i1 = images(row,col,pairs{row-1,col-1}(light,1));
                i2 = images(row,col,pairs{row-1,col-1}(light,2));
                L1 = L(:,pairs{row-1,col-1}(light,1));
                L2 = L(:,pairs{row-1,col-1}(light,2));

                % Compute some values that will be used repeatedly in the
                % linear system for this pixel
                RHS = i2*L1(3)-i1*L2(3);
                xval=i2*L1(1)-i1*L2(1);
                yval=i2*L1(2)-i1*L2(2);

                % Now decide which combination of neighbours are present
                % This determines which version of the numerical
                % approximation to the surface gradients will be used
                
                if mask(row,col-1) && mask(row,col+1)
                    % Both X neighbours present
                    if mask(row-1,col)
                        if mask(row+1,col)
                            if mask(row-1,col-1) && mask(row-1,col+1) && mask(row+1,col-1) && mask(row+1,col+1)
                                % All 8 neighbours present
                                NumEq=NumEq+1;
                                d(NumEq)=RHS;
                                % Edge neighbours
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-(4/12)*xval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row,col+1); s(k)=(4/12)*xval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row-1,col); s(k)=(4/12)*yval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-(4/12)*yval;
                                % Corner neighbours
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row-1,col-1); s(k)=-(1/12)*xval+(1/12)*yval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row-1,col+1); s(k)=(1/12)*xval+(1/12)*yval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row+1,col-1); s(k)=-(1/12)*xval-(1/12)*yval;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row+1,col+1); s(k)=(1/12)*xval-(1/12)*yval;
                            else
                                % All 4 neighbours present
                                NumEq=NumEq+1;
                                d(NumEq)=RHS;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval/2;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval/2;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval/2;
                                k=k+1;
                                i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval/2;
                            end
                        else
                            % Both X, only forward in Y
                            NumEq=NumEq+1;
                            d(NumEq)=RHS;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval/2;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval/2;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col); s(k)=-yval;
                        end
                    elseif mask(row+1,col)
                        % Both X, only backward in Y
                        NumEq=NumEq+1;
                        d(NumEq)=RHS;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval/2;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval/2;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col); s(k)=yval;
                    end
                elseif mask(row,col-1)
                    % Only backward in X
                    if mask(row-1,col)
                        if mask(row+1,col)
                            % Backward in X, both in Y
                            NumEq=NumEq+1;
                            d(NumEq)=RHS;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col); s(k)=xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval/2;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval/2;
                        else
                            % Backward in X, only forward in Y
                            NumEq=NumEq+1;
                            d(NumEq)=RHS;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col); s(k)=xval-yval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval;
                            %k=k+1;
                            %i(k)=NumEq; j(k)=indices(row,col); s(k)=-yval;

                        end
                    elseif mask(row+1,col)
                        % Backward in X, only backward in Y
                        NumEq=NumEq+1;
                        d(NumEq)=RHS;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col-1); s(k)=-xval;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col); s(k)=xval+yval;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval;
                        %k=k+1;
                        %i(k)=NumEq; j(k)=indices(row,col); s(k)=yval;
                    end
                elseif mask(row,col+1)
                    % Only forward in X
                    if mask(row-1,col)
                        if mask(row+1,col)
                            % Forward in X, both in Y
                            NumEq=NumEq+1;
                            d(NumEq)=RHS;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col); s(k)=-xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval/2;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval/2;
                        else
                            % Forward in X, only forward in Y
                            NumEq=NumEq+1;
                            d(NumEq)=RHS;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row,col); s(k)=-xval-yval;
                            k=k+1;
                            i(k)=NumEq; j(k)=indices(row-1,col); s(k)=yval;
                            %k=k+1;
                            %i(k)=NumEq; j(k)=indices(row,col); s(k)=-yval;

                        end
                    elseif mask(row+1,col)
                        % Forward in X, only backward in Y
                        NumEq=NumEq+1;
                        d(NumEq)=RHS;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col+1); s(k)=xval;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row,col); s(k)=-xval+yval;
                        k=k+1;
                        i(k)=NumEq; j(k)=indices(row+1,col); s(k)=-yval;
                        %k=k+1;
                        %i(k)=NumEq; j(k)=indices(row,col); s(k)=yval;
                    end
                end
                
            end

            % Finished with a pixel
        end
    end
end

disp(['System contains ' num2str(NumEq) ' linear equations with ' num2str(k) ' non-zero entries in C'])

i=i(1:k,1);
j=j(1:k,1);
s=s(1:k,1);
d=d(1:NumEq,1);

% Fix one pixel's height to zero to resolve unknown constant of integration
i(k+1)=NumEq+1;
j(k+1)=1;
s(k+1)=1;
d(NumEq+1)=0;

% Build matrix        +1
C = sparse(i,j,s,NumEq+1,npix);

[c,A] = qr(C,d,0);
issparse(A)
size(A)
size(c)
tic
z = A\c;
toc

% Copy vector of height values back into appropriate pixel positions
height=zeros(size(mask)).*NaN;
count=0;
for row=1:rows
    for col=1:cols
        if mask(row,col)
            count=count+1;            
            height(row,col)=z(count);
        end
    end
end

% Unpad
height = height(2:rows-1,2:cols-1);
mask = mask(2:rows-1,2:cols-1);

rows = rows-2;
cols = cols-2;

normals = depthnormals_mask( height,mask );

% Solve for albedo
albedo = zeros(rows,cols).*NaN;

for row=1:rows
    for col=1:cols
        if mask(row,col)
            valid=unique(pairs{row,col}(:));
            if length(valid)>0
                I_obs = zeros(length(valid),1);
                I_mod = zeros(length(valid),1);
                for i=1:length(valid)
                    I_obs(i,1)=images(row,col,valid(i));
                    I_mod(i,1)=max(0,normals(row,col,1).*L(1,valid(i))+normals(row,col,2).*L(2,valid(i))+normals(row,col,3).*L(3,valid(i)));
                end
                albedo(row,col)=I_mod\I_obs;
            end
        end
    end
end

end

