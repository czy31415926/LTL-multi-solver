function agent = Init_agent(N)
agent=[];
for i=1:N
    agent=[agent;struct('p',[5,1+i*8/N],'t',0)];
end

