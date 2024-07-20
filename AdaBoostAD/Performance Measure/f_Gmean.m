function [gmeans,F1,Auc,Rp,tpr,precision,acc] = f_Gmean(Y,H,Uc)  
numcls = length(Uc);
confMat = confusion( Y,H,Uc );
tpr = diag(confMat)'./sum(confMat,2)';
precision = diag(confMat)'./(sum(confMat,1)+eps); %(sum(confMat,1) - diag(confMat)')./sum(confMat,1);
gmeans = nthroot(prod(tpr),numcls);
fpr = zeros((length(Uc)-1),length(Uc));
for r = 1:length(Uc)
   fpr_tmp = confMat(:,r)./sum(confMat,2);
   fpr_tmp(r) = [];
   fpr(:,r) = fpr_tmp;
end

Auc = mean(mean((1+repmat(tpr,size(fpr,1),1)-fpr)/2)); % (testtpr+testtnr)/2;
F1 = mean((2.*precision.*tpr)./(tpr+precision+eps));
Rp = mean((precision+tpr)/2);
acc = mean(Y==H);

   
end
