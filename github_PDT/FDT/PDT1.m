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
                if ~isempty(find(cell2mat(B.trans(BS,j))==ap))&&isempty(find(tree(i).BS==j))%���ڿ���ת���Ҳ������������
                    son=[son;struct('BS',[],'PS',[],'ori',[],'traverse',0,'p',[],'t',[],'cost',0,'flag',0)];
                    son(end).BS=[father.BS,j];son(end).PS=[father.PS,k];son(end).ori=[father.ori,i];
                    son(end)=updata(father,son(end),k,T,AG);
                    son(end).cost=max(son(end).t);
                    if ~isempty(find(B.F==son(end).BS(end))) && father.flag==0%��ǰ׺������ɶ�
                        son(end).flag=-1;
                        son(end).BS=[-j];
                    elseif ~isempty(find(B.F==son(end).BS(end))) && father.flag==-1%�ɹ��ɽ����׺��
                        son(end).flag=son(end).BS(end);
                        son(end).BS=[-j];
                    elseif father.flag==son(end).BS(end) && father.flag>0%��ɵ�һ�κ�׺ѭ��
                        son(end).flag=length(B.S)+1;son(end).traverse=1;
                    else
                        son(end).flag=father.flag;%״̬���ı䣬�̳и��ڵ�����׶�״̬
                    end
                end
            end
        end
        %�����½ڵ�ʱ��ѡ�����Žڵ����tree��������
        for j=1:length(son)
            if son(j).cost>=cost_max
                continue;
            end
            tree=[tree;son(j)];
            over=[];
            %��B����ʱ��������ʱ��ϳ��Ľڵ�ȥ�������ʸ�(�������ӽڵ�)
            for k=1:(length(tree)-1)
                %�жϽڵ��Ƿ�����
                if tree(k).BS(end)==tree(end).BS(end) && tree(k).flag==tree(end).flag
                    if tree(end).t>=tree(k).t
                        tree(end).traverse=2;
                    else
                        over=[over,k];%��¼kΪ���ڵ��ţ��ȴ����������ʸ�
                    end
                end 
            end
            %�������Ƶ����ڵ㼰���ӽڵ�
            for k=1:length(over)%ѡ�����ڵ�
                %�ȴ����ڵ�
                tree(over(k)).traverse=2;
                %�ٴ����ӽڵ�
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

