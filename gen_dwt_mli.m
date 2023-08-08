function dwt_LF4D = gen_dwt_mli(dwt_spa_LF4D)
[~,Nsc] = size(dwt_spa_LF4D);
dwt_LF4D = cell(1,Nsc);
spa_dim = 2;
[LoF_D,HiF_D] = wfilters('haar','d');

for N = 1:Nsc
    y = {dwt_spa_LF4D{1,N}};
    for i = 1:2
        y2 = {};
        for j = 1:length(y)
            [a,d] = dwtnd1(y{j},i,LoF_D,HiF_D);
            y2={y2{1:length(y2)},a,d};
        end
        y = y2;
    end
    dwt_LF4D{1,N} = y;
end