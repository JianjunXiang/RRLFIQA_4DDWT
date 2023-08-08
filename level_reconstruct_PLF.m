function PLFI = level_reconstruct_PLF(LF)
LF_in = LF;
[U,V,S,T,C] = size(LF);
LF_out = zeros(U-1,V-1,S,T,C);
l_a = 2;
for uu = 1:U-1
    for vv = 1:V-1
        local_LF = LF_in(uu:uu + l_a -1,vv:vv + l_a -1,:,:,:);
        temp_LF1 = reshape(permute(local_LF,[1,2,5,3,4]),[l_a,l_a,C,S*T]);
        rec_LF = imresize(temp_LF1, 2-1/l_a, 'bicubic');
        temp_LF2 = permute(reshape(rec_LF,[2*l_a-1,2*l_a-1,C,S,T]),[1,2,4,5,3]);
        LF_out(uu,vv,:,:,:) = temp_LF2(l_a,l_a,:,:,:);
    end
end
PLFI = uint8(LF_out);