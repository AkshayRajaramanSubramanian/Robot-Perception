function plotcube(u)
uk = [u(1,:);u(2,:);u(3,:);u(4,:);u(1,:);u(5,:);u(6,:);u(2,:);u(6,:);u(7,:);u(3,:);u(7,:);u(8,:);u(4,:);u(8,:);u(5,:)];
if(size(u,2) == 2)
    plot(uk(:,1),uk(:,2))
else
plot3(uk(:,1),uk(:,2),uk(:,3))
    
end