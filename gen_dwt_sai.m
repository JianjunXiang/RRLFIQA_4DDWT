function dwt_spa_LF = gen_dwt_sai(LF4D)
[u,v,s,t] = size(LF4D);
[~,pind] = buildSpyr(zeros(s,t), 4, 'sp5Filters', 'reflect1');
pind_num = size(pind,1);
subbands=[4 7 10 13 16 19 22 25];
dwt_spa_LF = cell(1,length(subbands));
for nband = 1:length(subbands)
    sub_num = subbands(nband);
    dwt_spa_LF{1,nband} = zeros(u,v,pind(pind_num-sub_num+1,1),pind(pind_num-sub_num+1,2));
end

for uu = 1:u
    for vv = 1:v
        sai = squeeze(LF4D(uu,vv,:,:));
        [pyr,pind] = buildSpyr(sai, 4, 'sp5Filters', 'reflect1'); % compute transform
        sai_dwt=ind2wtree(pyr,pind); % convert to cell array
        for nband = 1:length(subbands)
            sub_num = subbands(nband);
            sub_sai_dwt = sai_dwt{sub_num};
            dwt_spa_LF{1,nband}(uu,vv,:,:) = sub_sai_dwt;
        end
    end
end