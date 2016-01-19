function [ pair_array ] = mask_to_pair( img_mask )
%% mask_to_pair Convert image mask to an array of cell arrays with the valid
%pixel pairs
%   [ pair_array ] = mask_to_pair( img_mask )

% Initialise size information
x = size(img_mask, 1);
y = size(img_mask, 2);
z = size(img_mask, 3);
pair_array = cell(x,y);
% waitbar_h = waitbar(0.5, 'Generating pair array');
disp('Generating pair array');
% disp('     ');
parfor i = 1:x
%     fprintf('\b\b\b\b\b\b%05.2f%%', i/x*100);
    for j = 1:y
%         waitbar(i/x);
        con = squeeze(img_mask(i,j,:));
        con = graphminspantree(sparse(double(con)*double(con)'));
%         con = (sparse(double(con)*double(con)'));
%         con = triu(con);
%         con(logical(eye(size(con,1)))) = 0;

        % convert to the old format
        col_len = sum(con(:));
        if col_len
            tmp = zeros(col_len, 2);
            k = 1;
            for l = 1:size(con,1)
                for m = 1:size(con,2)
                    if(con(l, m))
                        tmp(k, :) = [l m];
                        k = k + 1;
                    end
                end
            end
            pair_array{i,j} = tmp;
        end
%         if ((i == 6) && (j == 37)) || ((i == 37) && (j == 6))
%             disp('break');
%         end
    end
end
disp(' ');
% delete(waitbar_h);
end

