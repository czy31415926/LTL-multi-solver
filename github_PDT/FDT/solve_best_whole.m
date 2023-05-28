function [best_stateP,best_stateB,best_stateAP,section] = solve_best_whole(tree,B,T)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%寻找最优的终止状态
cost_best=100000;
k_best=0;
for i=1:length(tree)
    if tree(i).flag==length(B.S)+1
        if tree(i).cost<cost_best
            cost_best=tree(i).cost;
            k_best=i;
        end
    end
end
%追溯路径
point=tree(k_best);
node_best=tree(k_best);
node_best.ori=[node_best.ori,k_best];
best_stateB=[];
best_stateAP=[];
best_stateP=[];
section=[1,0,0];
for i=1:length(node_best.ori)
    node=tree(node_best.ori(i));
    best_stateB=[best_stateB,abs(node.BS(end))];
    best_stateAP=[best_stateAP,node.PS(end)];
    best_stateP=[best_stateP,node.p];
    if node.flag<length(B.S)+1 &&node.flag>0
        section(3)=section(3)+1;
    elseif node.flag<0
        section(2)=section(2)+1;
    elseif node.flag==0
        section(1)=section(1)+1;
    end
end
end

