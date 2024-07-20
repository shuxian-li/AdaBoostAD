clear;clc;

dataname = 'newtyroid2';
load(dataname);
[~,~,label] = unique(label);
class = unique(label);
for i = 1:length(class)
    I = find(label == i);
    if length(I) < 10
        data(I,:) = [];
        label(I) = [];
    end
end
[~,~,label] = unique(label);
class = unique(label);
        
save(dataname,'data','label');
