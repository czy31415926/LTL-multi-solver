warning off all
addpath('.\LTL_Toolbox');
T_whole=map();%����DTS
alphabet_whole=alphabet_set(obtainAlphabet(8));%������ĸ��

formula1='Fp1 & Fp2 & Fp3';
formula2='Fp1 & Fp2 & Fp3 & Fp4';
formula3='Fp1 & Fp2 & Fp3 & Fp4 & Fp5';
formula4='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6';
formula5='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & ((!p6)Up7)';
formula6='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7';
formula7='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & Fp8 & ((!p7)Up8)';
formula8='Fp1 & Fp2 & Fp3 & Fp4 & Fp5 & Fp6 & Fp7 & Fp8';
formula9='(F(p1&X(Fp2))|Fp3)';
N=1;
agent=Init_agent(N);%����agent
formula=formula9;
N_p=7;
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


tree=[struct('BS',[1],'PS',[0],'ori',[],'traverse',0,'p',[],'t',[],'cost',[],'flag',0)];
for i=1:length(agent)
    tree(1).p=[tree(1).p;agent(i).p];
    tree(1).t=[tree(1).t;agent(i).t];
end

for ii=1:1000
    n=0;
    for i=1:length(tree)
        if tree(i).traverse==1
            continue;
        end
        tree(i).traverse=1;
        n=n+1;
        father=tree(i);
        BS=abs(father.BS(end));
        son=[];
        for j=1:length(B.S)
            for k=1:T.M
                ap=T.nodes(k).data;
                if ~isempty(find(cell2mat(B.trans(BS,j))==ap))&&isempty(find(tree(i).BS==j))%���ڿ���ת���Ҳ������������
                    son=[son;struct('BS',[],'PS',[],'ori',[],'traverse',0,'p',[],'t',[],'cost',0,'flag',0)];
                    son(end).BS=[father.BS,j];son(end).PS=[father.PS,ap];son(end).ori=[father.ori,i];
                    %son(end)=updata(son(end),father);
                    son(end).p=[0,0];son(end).t=0;son(end).cost=length(son(end).ori+1);
                    if ~isempty(find(B.F==son(end).BS(end))) && father.flag==0%��ǰ׺������ɶ�
                        son(end).flag=-1;
                        son(end).BS=[-j];
                    elseif ~isempty(find(B.F==son(end).BS(end))) && father.flag==-1%�ɹ��ɽ����׺��
                        son(end).flag=son(end).BS(end);
                        son(end).BS=[-j];
                    elseif father.flag==son(end).BS(end) && father.flag>0%��ɵ�һ�κ�׺ѭ��
                        son(end).flag=length(B.S)+1;
                    else
                        son(end).flag=father.flag;%״̬���ı䣬�̳и��ڵ�����׶�״̬
                    end
                end
            end
        end
        %�����½ڵ�ʱ��ѡ�����Žڵ����tree��������
        for k=1:length(son)
            tree=[tree;son(k)];
            over=[];
            %��B����ʱ��������ʱ��ϳ��Ľڵ�ȥ�������ʸ�(�������ӽڵ�)
            for k=1:(length(tree)-1)
                %�жϽڵ��Ƿ�����
                if tree(k).BS(end)==tree(end).BS(end) && tree(k).flag==tree(end).flag
                    if tree(end).t>=tree(k).t
                        tree(end).traverse=1;
                    else
                        over=[over,k];%��¼kΪ���ڵ��ţ��ȴ����������ʸ�
                    end
                end 
            end
            %�������Ƶ����ڵ㼰���ӽڵ�
            for k=1:length(over)%ѡ�����ڵ�
                %�ȴ����ڵ�
                tree(over(k)).traverse=1;
                %�ٴ����ӽڵ�
                for m=1:(length(tree)-1)
                    if ~isempty(find(tree(m).ori==over(k)))
                        tree(m).traverse=1;
                    end
                end
            end
        end
    end
    if n==0
        break
    end
end
[best_stateP,best_stateB,best_stateAP,section] = solve_best_whole(tree,B,T);
                      
                    
         

