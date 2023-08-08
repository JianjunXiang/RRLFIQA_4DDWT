function ssim_4d_value = ssim_pool(blk1_4d, blk2_4d)
    C1 = 0.1;
    C2 = 0.1;
    ssim_4d_map = (2 * blk1_4d .* blk2_4d + C1) ./(blk1_4d .* blk1_4d + blk2_4d .* blk2_4d + C1);
    [u,v,s,t] = size(blk1_4d);
    ang_wei = zeros(s,t);
    spa_wei = zeros(s,t);
    ang_spa_wei = zeros(u,v,s,t);
    for ss = 1:s
        for tt = 1:t
            mli1 = squeeze(blk1_4d(:,:,ss,tt));
            mli2 = squeeze(blk2_4d(:,:,ss,tt));
            ssim_mli_map = (2 * mli1 .* mli2 + C2) ./ (mli1.^2 + mli2.^2 + C2);
            ssim_mli = mean(ssim_mli_map(:));
            ang_wei(ss,tt) = 1-ssim_mli;
        end
    end
    
    for uu = 1:u
        for vv = 1:v 
            sai1 = squeeze(blk1_4d(uu,vv,:,:));
            sai2 = squeeze(blk2_4d(uu,vv,:,:));
            spa_wei = max(sai1,sai2);
            ang_spa_wei(uu,vv,:,:) = spa_wei .* ang_wei;
        end
    end

    fenzi = ssim_4d_map .* ang_spa_wei;
    fenmu = ang_spa_wei;
    ssim_4d_value = sum(fenzi(:))/sum(fenmu(:));
end