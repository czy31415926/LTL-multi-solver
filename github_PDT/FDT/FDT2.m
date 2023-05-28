function [best_stateP,best_stateB,best_stateAP,section,tree,cost_max] = FDT2(B,T,AG)
cost_max=10000;
Nd1=struct('BS',[1],'PS',[0],'ori',[],'traverse',0,'p',[],'t',[],'cost',0,'flag',0);
for i=1:length(AG)
    Nd1.p=[Nd1.p;AG(i).p];
    Nd1.t=[Nd1.t;AG(i).t];
end
tree=[Nd1];NS=1;
tree=PDT1(B,T,AG,cost_max,tree);
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
tree=PDT2(B,T,AG,cost_max,tree);
[best_stateP,best_stateB,best_stateAP,section] = solve_best_whole(tree,B,T);
end

