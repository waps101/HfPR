function N = depthnormals_mask( z,mask )
%DEPTHNORMALS_MASK Compute normal map from depth map with mask
%   Uses finite difference approximation to surface graidents from supplied
%   depth map. For pixels with missing neighbours (according to binary
%   foreground mask), either central or simple forward/backward finite
%   differences are used.
%
% Inputs:
% z    - rows by cols depth map
% mask - rows by cols logical matrix, 1 for foreground, 0 for background
%
% Output:
% N    - rows by cols by 3 array containing surface normals at each pixel
%

rows = size(mask,1);
cols = size(mask,2);

% Pad to avoid boundary problems
z2 = zeros(rows+2,cols+2);
z2(2:rows+1,2:cols+1)=z;
z = z2;
clear z2
mask2 = zeros(rows+2,cols+2);
mask2(2:rows+1,2:cols+1)=mask;
mask = mask2;
clear mask2
rows = rows+2;
cols = cols+2;

p = zeros(size(mask));
q = zeros(size(mask));

for row=1:rows
    for col=1:cols
        if mask(row,col)
            % Now decide which combination of neighbours are present
            % This determines which version of the numerical
            % approximation to the surface gradients will be used

            % Calculate X gradient
            if mask(row,col-1) && mask(row,col+1)
                % Both X neighbours present
                if mask(row-1,col-1) && mask(row-1,col+1) && mask(row+1,col-1) && mask(row+1,col+1)
                    % All 6 X neighbours present
                    p(row,col)=1/12 * (4*z(row,col+1) - 4*z(row,col-1) + ...
                                       z(row+1,col+1) - z(row+1,col-1) + ...
                                       z(row-1,col+1) - z(row-1,col-1));
                else
                    % Central difference
                    p(row,col)=(z(row,col+1)-z(row,col-1))/2;
                end
            elseif mask(row,col-1)
                % Only backward in X
                p(row,col)=z(row,col)-z(row,col-1);
            elseif mask(row,col+1)
                % Only forward in X
                p(row,col)=z(row,col+1)-z(row,col);
            end

            % Calculate Y gradient
            if mask(row-1,col) && mask(row+1,col)
                % Both Y neighbours present
                if mask(row-1,col-1) && mask(row-1,col+1) && mask(row+1,col-1) && mask(row+1,col+1)
                    % All 6 Y neighbours present
                    q(row,col)=1/12 * (4*z(row+1,col) - 4*z(row-1,col) + ...
                                       z(row+1,col-1) - z(row-1,col-1) + ...
                                       z(row+1,col+1) - z(row-1,col+1));
                else
                    % Central difference
                    q(row,col)=(z(row+1,col)-z(row-1,col))/2;
                end
            elseif mask(row-1,col)
                % Only backward in Y
                q(row,col)=z(row,col)-z(row-1,col);
            elseif mask(row+1,col)
                % Only forward in Y
                q(row,col)=z(row+1,col)-z(row,col);
            end


            % Finished with a pixel
        end
    end
end

p(~mask)=NaN;
q(~mask)=NaN;

N(:,:,1)=-p;
N(:,:,2)=q;
N(:,:,3)=1;
N = EWnorm(N);

N = N(2:rows-1,2:cols-1,:);

end

