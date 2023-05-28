function node = updata(father,node,ap,T,AG)
node.t=father.t;node.p=father.p;
for i=1:length(AG)
    if ~isempty(find(AG(i).PS==ap))
        node.p(i,:)=T.nodes(ap).position;
        node.t(i)=father.t(i)+norm(node.p(i,:)-father.p(i,:));
    end
end

