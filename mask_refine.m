function [ mask_col , im_used] = mask_refine(...
    mask_col, self_shadow_mask_col, diff_stack_col, diff_mean, diff_std, min_img, z)
%mask_refinement Refine the rough mask

im_used = sum(mask_col);
if im_used < min_img
    z_score = abs(diff_stack_col-diff_mean)./diff_std;
    [~, pix_ind] = sort(z_score, 'ascend');
    for k = 1:z
        if mask_col(pix_ind(k)) == 0
            if self_shadow_mask_col(pix_ind(k)) == 1
                continue;
            end
            im_used = im_used + 1;
            mask_col(pix_ind(k)) = 1;
        end
        if im_used >= min_img
            break;
        end
    end
end

end

