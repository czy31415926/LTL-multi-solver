warning off all
addpath('.\LTL_Toolbox','.\data');
T_whole=map();%构建DTS
alphabet_whole=alphabet_set(obtainAlphabet(8));%构造字母表

formula1='Fp1 & Fp2 & Fp3';
formula2='Fp1 & Fp2 & Fp3 & Fp4';
formula3='Fp1 & Fp2 & Fp3 & Fp4 & Fp5';
formula4='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6';
formula5='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & ((!p6)Up7)';
formula6='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7';
formula7='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & Fp8 & ((!p7)Up8)';
formula8='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & Fp8';
formula9='(F(p1&X(Fp2))|Fp3)';
formula=formula6;
N_p=7;
N=1;
AG=Init_agent(N);%构造agent
for i=1:N
    modnum=mod(N,N_p);
    if modnum==0
        AG(i).PS=[1,N_p];
    else
        AG(i).PS=[modnum,modnum+1];
    end
end
AG(1).PS=1:N_p;
alphabet=alphabet_whole(1:2^N_p);
%B=create_buchi(formula,alphabet);
B=load('128.mat').B;
T=T_whole;
T.M=N_p;

for i=1:length(T_whole.nodes)
    if T_whole.nodes(i).data==2^N_p
        N=i-1;
        break;
    end
end
T.nodes=T_whole.nodes(1:N_p);
T.N=N_p;
T.adj=T_whole.adj(1:N_p,1:N_p);

cost_max=10000;
Nd1=struct('BS',[1],'PS',[0],'ori',[],'traverse',0,'p',[],'t',[],'cost',0,'flag',0);
for i=1:length(AG)
    Nd1.p=[Nd1.p;AG(i).p];
    Nd1.t=[Nd1.t;AG(i).t];
end
tree=[Nd1];NS=1;
while(~isempty(NS))
    tree(NS(1)).traverse=0;
    [tree,NS_new] = PDT(B,T,AG,cost_max,tree);
    NS=[NS(2:end);NS_new];
    [NS,cost_max]=Filter(tree,NS,cost_max,B);
    cost_max
end
[best_stateP,best_stateB,best_stateAP,section] = solve_best_whole(tree,B,T);








