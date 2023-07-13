function de_U = defuzzy(num,N,cluster)
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
num=num';
num_max=max(num);
de_U=zeros(cluster,N);
for i=1:size(num,1)
    for j=1:num_max
        if(num(i)==j)
          de_U(j,i)=1;
        end
    end
%     if(num(i)==2)
%         de_U(i,:)=[0,1];
%     end
%     if(num(i)==3)
%         de_U(i,:)=[0,0,1];
%     end
end