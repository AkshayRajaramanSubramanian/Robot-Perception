%input cube coordinates
X = [0 0 0;
    1 0 0;
    1 1 0;
    0 1 0;
    0 0 1;
    1 0 1;
    1 1 1;
    0 1 1];
%plotting cube
subplot(2,1,1);
axis auto
scatter3(X(:,1),X(:,2),X(:,3));hold on
plotcube(X);
%defining the axes of the camera frame after rotation and translation wrt the world frame
theta = -45;
Rc= [1 0 0;0 cosd(theta) -sind(theta);0 sind(theta) cosd(theta)];
Rcu = [1 0 0;0 0 -1;0 1 0];
R = Rcu*Rc;
%R = Rc;
T = [0;0;5];
k = [800 0 250;0 800 250;0 0 1];
u = project(X',R,T,k);
u = u';
subplot(2,1,2);
axis auto
scatter(u(:,1),u(:,2));hold on
plotcube(u);