function lambda = density(Y,sort_distance,index,k)
N = length(Y);
Q_index = zeros(N,k);
min = unique(sort_distance);
min = min(2);

for i = 1:N
    start = find(sort_distance(i,:)~=0);
    intra_class = Y(index(i,start(1):k+start(1)-1)) == Y(i);
    t(i) = sum(intra_class); % the number of intra-class nearest neighbors
    sum_dist_r(i) = 0;
    for j = 1:k
        if intra_class(j) == 1
            Q_index(i,j) = index(i,start(1)+j-1); % the index of intra-class nearest neighbors
            sum_dist_r(i) = sum_dist_r(i) + 1/sort_distance(i,start(1)+j-1);
        end
    end
    if t(i) ~= 0
        lambda(i) = 1/t(i)*sum_dist_r(i);
    else
        lambda(i) = 0;
    end
end

% for i = 1:N
%     intra_class = Y(index(i,2:k+1)) == Y(i);
%     t(i) = sum(intra_class); % the number of intra-class nearest neighbors
%     sum_dist_r(i) = 0;
%     for j = 1:k
%         if intra_class(j) == 1
%             Q_index(i,j) = index(i,j+1); % the index of intra-class nearest neighbors
%             if sort_distance(i,j+1) == 0
%                 dist = min/10;
%             else
%                 dist = sort_distance(i,j+1);
%             end
%             sum_dist_r(i) = sum_dist_r(i) + 1/dist;
%         end
%     end
%     if t(i) ~= 0
%         lambda(i) = 1/t(i)*sum_dist_r(i);
%     else
%         lambda(i) = 0;
%     end
% end

end

