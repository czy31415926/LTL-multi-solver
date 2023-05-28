function tree = PDT1(B,T,AG,cost_max,tree)
for ii=1:1000
    n=0;
    for i=1:length(tree)
        if tree(i).traverse~=0
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
            if son(j).cost>=cost_max
                continue;
            end
            tree=[tree;son(j)];
            over=[];
            %当B过大时，相似且时间较长的节点去除遍历资格(包括其子节点)
            for k=1:(length(tree)-1)
                %判断节点是否相似
                if tree(k).BS(end)==tree(end).BS(end) && tree(k).flag==tree(end).flag
                    if tree(end).t>=tree(k).t
                        tree(end).traverse=2;
                    else
                        over=[over,k];%记录k为弱节点编号，等待消除遍历资格
                    end
                end 
            end
            %处理相似的弱节点及其子节点
            for k=1:length(over)%选择弱节点
                %先处理父节点
                tree(over(k)).traverse=2;
                %再处理子节点
                for m=1:(length(tree)-1)
                    if ~isempty(find(tree(m).ori==over(k)))
                        tree(m).traverse=2;
                    end
                end
            end
        end
    end
    if n==0
        break
    end
end
end

