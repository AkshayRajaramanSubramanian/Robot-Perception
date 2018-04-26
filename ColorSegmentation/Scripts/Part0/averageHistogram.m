clear
clc
y = [1:20];
meanValues = [];
RValues = [];
GValues = [];
BValues = [];
for i = 1:20
RImage = [];
GImage = [];
YImage = [];
RHist = [0];
GHist = [0];
YHist = [0];
RHistEq = [0];
GHistEq = [0];
YHistEq = [0];
Imagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\Frames\' num2str(y(i)) '.png'];
I = imread(Imagename);   
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
RImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\R_' num2str(y(i)) '.png'];
if (exist(RImagename, 'file')==2)
RImage = imread(RImagename);
RedR = R(RImage>0);
GreenR = G(RImage>0);
BlueR = B(RImage>0);
RHist = imhist(RedR);
RHistEq = histeq(RedR);
RValues = [RValues;RedR GreenR BlueR];
end
GImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\G_' num2str(y(i)) '.png'];
if (exist(GImagename, 'file')==2)
GImage = imread(GImagename);
RedG = R(GImage>0);
GreenG = G(GImage>0);
BlueG = B(GImage>0);
Green = I(GImage>0);
GHist = imhist(GreenG);
GHistEq = histeq(GreenG);
GValues = [GValues;RedG GreenG BlueG];
end
YImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\Y_' num2str(y(i)) '.png'];
if (exist(YImagename, 'file')==2)
YImage = imread(YImagename);
RedY = R(YImage>0);
GreenY = G(YImage>0);
BlueY = B(YImage>0);
Yellow = I(YImage>0);
YHist = imhist(BlueY);
YHistEq = histeq(BlueY);
BValues = [BValues;RedY GreenY BlueY];
end

plot(RHist,'r');hold on;

plot(GHist,'g');hold on;

plot(YHist,'y');hold on;




meanR = mean(RHistEq);
meanG = mean(GHistEq);
meanY = mean(YHistEq);
 stdR = std(double(RHistEq));
 stdG = std(double(GHistEq));
 stdY = std(double(YHistEq));
 
 varR(i) = sqrt(stdR);
 varG(i) = sqrt(stdG);
 varY(i) = sqrt(stdY);
end
meanVarianceR = mean(varR);
meanVarianceG = mean(varG);
meanVarianceY = mean(varY);
maxR = 256;
maxY = 229;
maxG = 105;
