clear; clc; close;
ref_lfi = imread('./figure/Flowers.bmp');% reference LFI
ref_lfi = permute(reshape(ref_lfi,[9, 434, 9, 625, 3]),[1,3,2,4,5]);
dis_lfi = imread('./figure/HEVC_Flowers_39.bmp');% distorted LFI
dis_lfi = permute(reshape(dis_lfi,[9, 434, 9, 625, 3]),[1,3,2,4,5]);
addpath(genpath('matlabPyrTools'))
num_level = 1;
%% reference lfi
% reconstruct PLFI
ref_rec_LFI = ref_lfi;
for level = 1:num_level
    temp_LFI = level_reconstruct_PLF(ref_rec_LFI);
    ref_rec_LFI = temp_LFI;
end
[u,v,s,t,c] = size(ref_rec_LFI);
ref_gray_pse_LF = zeros(u,v,s,t);
%grayscale
for uu = 1:u
    for vv = 1:v
        ref_gray_pse_LF(uu,vv,:,:) = rgb2gray(squeeze(ref_rec_LFI(uu,vv,:,:,:)));
    end
end
% 4D wavelet transform
ref_dwt_spa_LF4D = gen_dwt_sai(ref_gray_pse_LF);
ref_wavelet_4D_coef = gen_dwt_mli(ref_dwt_spa_LF4D);

%%distorted lfi
% reconstruct PLFI
dis_rec_LFI = dis_lfi;
for level = 1:num_level
    temp_LFI = level_reconstruct_PLF(dis_rec_LFI);
    dis_rec_LFI = temp_LFI;
end
[u,v,s,t,c] = size(dis_rec_LFI);
dis_gray_pse_LF = zeros(u,v,s,t);
%grayscale
for uu = 1:u
    for vv = 1:v
        dis_gray_pse_LF(uu,vv,:,:) = rgb2gray(squeeze(dis_rec_LFI(uu,vv,:,:,:)));
    end
end
% 4D wavelet transform
dis_dwt_spa_LF4D = gen_dwt_sai(dis_gray_pse_LF);
dis_wavelet_4D_coef = gen_dwt_mli(dis_dwt_spa_LF4D);

[~,Nsc] = size(dis_wavelet_4D_coef);
num = 0;
for nband = 1:Nsc
    ref_band = ref_wavelet_4D_coef{1,nband};
    dis_band = dis_wavelet_4D_coef{1,nband};

    [~,nNsc] = size(ref_band);
    for nnband = 1:nNsc
        num = num + 1;
        ref_nband = ref_band{1,nnband};
        dis_nband = dis_band{1,nnband};

        ref_nband = abs(ref_nband);
        dis_nband = abs(dis_nband); 

        score(num) = ssim_pool(ref_nband,dis_nband);
    end        
end

