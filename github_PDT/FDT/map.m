function T=map()
%��ͼ��С
T.X=10;T.Y=10;
%�����ʼ״̬
T.Q0 = [1,1];
%��������ڵ�λ��
T.nodes=[];
T.N=8;%����ڵ���
T.M=8;%��������ڵ�
wrong=2^T.M-1;
N=T.N;
for i=1:N
    T.nodes=[T.nodes, struct('position',[],'atomicProp',[],'data',[])];
end
d=0.35;
dd=1.5;
T.nodes(1).atomicProp='a';T.nodes(1).position=[d,d];T.nodes(1).data=1;
T.nodes(2).atomicProp='b';T.nodes(2).position=[T.X-d,d];T.nodes(2).data=2;
T.nodes(3).atomicProp='c';T.nodes(3).position=[T.X-d,T.Y-d];T.nodes(3).data=4;
T.nodes(4).atomicProp='d';T.nodes(4).position=[d,T.Y-d];T.nodes(4).data=8;
T.nodes(5).atomicProp='e';T.nodes(5).position=[dd,dd];T.nodes(5).data=16;
T.nodes(6).atomicProp='f';T.nodes(6).position=[T.X-dd,dd];T.nodes(6).data=32;
T.nodes(7).atomicProp='g';T.nodes(7).position=[T.X-dd,T.Y-dd];T.nodes(7).data=64;
T.nodes(8).atomicProp='h';T.nodes(8).position=[dd,T.Y-dd];T.nodes(8).data=128;




%����ڵ�ת��
T.adj = zeros([N,N]);
for i=1:N
    for j=1:N
        T.adj(i,j)=((T.nodes(i).position(1)-T.nodes(j).position(1))^2+(T.nodes(i).position(2)-T.nodes(j).position(2))^2)^0.5;
    end
end

    

