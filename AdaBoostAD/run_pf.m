clc
clear

load(['results_save/','recall_avg'],'recall_avg');
load(['results_save/','recall_std'],'recall_std');

load(['results_save/','gmean'],'gmean');
load(['results_save/','f1'],'f1');
load(['results_save/','auc'],'auc');
load(['results_save/','rp'],'rp');

load(['results_save/','tkde_gmean'],'gmean_50');
load(['results_save/','tkde_auc'],'Auc_50');

% wtl_gmean = win_tie_lose(gmean);
% wtl_auc = win_tie_lose(auc);

wtl_gmean = win_tie_lose_tkde(gmean, gmean_50);
wtl_auc = win_tie_lose_tkde(auc, Auc_50);

function [wtl] = win_tie_lose(pf)
    wtl = zeros(6,3);
    for i = 1:20
        pf_i_contral = pf{i,7};
        for j = 1:6
            pf_i_j = pf{i,j};
            pf_compare_groups = cat(2,pf_i_j,pf_i_contral);
            [R_K,RejectH0] = Examp_wilcoxon(pf_compare_groups);
            if RejectH0 == 0
                wtl(j,2) = wtl(j,2)+1;
            else
                if R_K(1)<R_K(2)
                    wtl(j,1) = wtl(j,1)+1;
                else
                    if j == 3
                        i
                    end
                    wtl(j,3) = wtl(j,3)+1;
                end
            end
        end
    end
end

function [wtl] = win_tie_lose_tkde(pf, tkde)
    wtl = zeros(1,3);
    for i = 1:20
        pf_i_contral = pf{i,7};
        pf_i_j = tkde{i};
        pf_compare_groups = cat(2,pf_i_j,pf_i_contral);
        [R_K,RejectH0] = Examp_wilcoxon(pf_compare_groups);
        if RejectH0 == 0
            wtl(2) = wtl(2)+1;
        else
            if R_K(1)<R_K(2)
                wtl(1) = wtl(1)+1;
            else
                wtl(3) = wtl(3)+1;
            end
        end
    end
end

