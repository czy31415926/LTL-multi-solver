function [NS_new,cost_max]=Filter(tree,NS,cost_max,B)
cost_best=cost_max;
k_best=0;
for i=1:length(tree)
    if tree(i).flag==length(B.S)+1
        if tree(i).cost<cost_best
            cost_best=tree(i).cost;
            k_best=i;
        end
    end
end
if k_best~=0
    cost_max=cost_best;
end
NS_new=[];
for i=1:length(NS)
    if tree(NS(i)).cost<cost_max
        NS_new=[NS_new;NS(i)];
    end
end
end

