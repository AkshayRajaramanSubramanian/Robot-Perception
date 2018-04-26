clc
clear
load ('ValuesMatrix.mat')
y = [1:20];
load ('meanAndVariance.mat');
figure1 = figure();
for i = 1:200
Imagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Scripts\AllImages\' num2str(i) '.png'];
I = imread(Imagename);   
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
Red =R>(maxR-(meanVarianceR/2));
[BoundaryRed,L] = bwboundaries(Red,'holes');
RedComponent = ones(size(I,1),size(I,2),3);
RedComponent(:,:,1) = Red*255;
Yellow = and(G>(maxY-(meanVarianceY/2)),R>(maxY-(meanVarianceY/2)));
[BoundaryYellow,L] = bwboundaries(Yellow,'holes');
YellowComponent = zeros(size(I,1),size(I,2),3);
YellowComponent(:,:,1) = Yellow*255;
YellowComponent(:,:,2) = Yellow*255;
Green = G>(maxG-(meanVarianceG/2));
[BoundaryGreen,L] = bwboundaries(Green,'holes');
GreenComponent = zeros(size(I,1),size(I,2),3);
GreenComponent(:,:,2) = Green*255;
R(Red) = 256;
G(Red) = 0;
B(Red) = 0;

R(Yellow) = 256;
G(Yellow) = 256;
B(Yellow) = 0;

%G(Green) = 255;
I(:,:,1) = R;
I(:,:,2) = G;
I(:,:,3) = B;
imshow(I);hold on;
for k = 1:length(BoundaryRed)
   boundaryRed = BoundaryRed{k};
   plot(boundaryRed(:,2), boundaryRed(:,1), 'k', 'LineWidth', 2);
end
for k = 1:length(BoundaryYellow)
   boundaryYellow = BoundaryYellow{k};
   plot(boundaryYellow(:,2), boundaryYellow(:,1), 'w', 'LineWidth', 2);
end
% if(~isempty(BoundaryGreen))
% for k = 1:length(BoundaryGreen)
%    BoundaryGreen = BoundaryGreen{k};
%    plot(BoundaryGreen(:,2), BoundaryGreen(:,1), 'b', 'LineWidth', 2);
% end
%end
pause(0.01);

newimagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Output\Part0\seg_' num2str(i) '.png'];
saveas(figure1,newimagename);
end