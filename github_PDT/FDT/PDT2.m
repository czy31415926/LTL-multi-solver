function tree = PDT2(B,T,AG,cost_max,tree)


for ii=1:1000
    n=0;
    for i=1:length(tree)
        if tree(i).traverse~=0 && tree(i).traverse~=2
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
                if ~isempty(find(cell2mat(B.trans(BS,j))==ap))&&isempty(find(tree(i).BS==j))%存在可行转换且不在完成序列中
                    son=[son;struct('BS',[],'PS',[],'ori',[],'traverse',0,'p',[],'t',[],'cost',0,'flag',0)];
                    son(end).BS=[father.BS,j];son(end).PS=[father.PS,k];son(end).ori=[father.ori,i];
                    son(end)=updata(father,son(end),k,T,AG);
                    son(end).cost=max(son(end).t);
                    if ~isempty(find(B.F==son(end).BS(end))) && father.flag==0%由前缀进入过渡段
                        son(end).flag=-1;
                        son(end).BS=[-j];
                    elseif ~isempty(find(B.F==son(end).BS(end))) && father.flag==-1%由过渡进入后缀段
                        son(end).flag=son(end).BS(end);
                        son(end).BS=[-j];
                    elseif father.flag==son(end).BS(end) && father.flag>0%完成第一次后缀循环
                        son(end).flag=length(B.S)+1;son(end).traverse=1;
                    else
                        son(end).flag=father.flag;%状态不改变，继承父节点任务阶段状态
                    end
                end
            end
        end
        %当有新节点时，选择最优节点加入tree，并过滤
        for j=1:length(son)
            if son(j).cost<cost_max
                tree=[tree;son(j)];
            end
        end
    end
    if n==0
        break
    end
end
end

