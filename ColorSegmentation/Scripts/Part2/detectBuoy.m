clear
clc
load ('meanAndVariance.mat');
y = [1:20];
SamplesR = [];
SamplesY = [];
SamplesG = [];
figure1 = figure();
for i = 1:20
Imagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\Frames\' num2str(y(i)) '.png'];
I = imread(Imagename);
RImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\R_' num2str(y(i)) '.png'];
if (exist(RImagename, 'file')==2)
    maskR = imread(RImagename);
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    sample_ind_R = find(maskR > 0);
    RR = R(sample_ind_R);
    GR = G(sample_ind_R);
    BR = B(sample_ind_R);
    SamplesR = [SamplesR; [RR GR BR]];
end
GImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\G_' num2str(y(i)) '.png'];
if (exist(GImagename, 'file')==2)
    maskG = imread(GImagename);
    sample_ind_G = find(maskG > 0);
    RG = R(sample_ind_G);
    GG = G(sample_ind_G);
    BG = B(sample_ind_G);
    SamplesG = [SamplesY; [RG GG BG]];
end
YImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\Y_' num2str(y(i)) '.png'];
if (exist(YImagename, 'file')==2)
    maskY = imread(YImagename);
    sample_ind_Y = find(maskY > 0);
    RY = R(sample_ind_Y);
    GY = G(sample_ind_Y);
    BY = B(sample_ind_Y);
    SamplesY = [SamplesY; [RY GY BY]];
end
end
GMModelR= fitgmdist(SamplesR,3,'Options',statset('MaxIter',100),'CovarianceType','full');
GMModelG= fitgmdist(SamplesG,3,'Options',statset('MaxIter',100),'CovarianceType','full');
GMModelB= fitgmdist(SamplesY,3,'Options',statset('MaxIter',100),'CovarianceType','full');

for j = 1:200
    TestImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Scripts\AllImages\' num2str(y(i)) '.png'];
    tI = imread(TestImagename);
    tIr=imgaussfilt(tI,15);
    tIg=imgaussfilt(tI,1);
    tIy=imgaussfilt(tI,6);
    rr=tIr(:,:,1);gr=tIr(:,:,2);br=tIr(:,:,3);
    rg=tIg(:,:,1);gg=tIg(:,:,2);bg=tIg(:,:,3);
    ry=tIy(:,:,1);gy=tIy(:,:,2);by=tIy(:,:,3);
    for width = 1:size(tI,1)
        for height = 1:size(tI,2)
        x=[rr(width,height) gr(width,height) br(width,height)]';
        y=[rg(width,height) gg(width,height) bg(width,height)]';
        z=[ry(width,height) gy(width,height) by(width,height)]';
        ProbR = 0;
        ProbG = 0;
        ProbY = 0;
        
        for i=1:3
            mu_x=GMModelR.mu(i,:)';
            sigma_x=GMModelR.Sigma(:,:,i)';
            probX=exp(-0.5*((double(x)-mu_x)'/sigma_x)*(double(x)-mu_x))/(((2*pi)^3/2)*sqrt(det(sigma_x)));
            ProbR =ProbR +GMModelR.ComponentProportion(i)*probX;  
            mu_y=GMModelG.mu(i,:)';
            sigma_y=GMModelG.Sigma(:,:,i)';
            probG=exp(-0.5*((double(y)-mu_y)'/sigma_y)*(double(y)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
            ProbG =ProbG +GMModelG.ComponentProportion(i)*probG; 
            mu_z=GMModelB.mu(i,:)';
            sigma_z=GMModelB.Sigma(:,:,i)';
            probY=exp(-0.5*((double(z)-mu_z)'/sigma_z)*(double(z)-mu_z))/(((2*pi)^3/2)*sqrt(det(sigma_z)));
            ProbY =ProbY +GMModelB.ComponentProportion(i)*probY;   
        end
        ProbabilityR(width,height) = ProbR;
        ProbabilityG(width,height) = ProbG;
        ProbabilityY(width,height) = ProbY;
        
        end
        width
    end
        maskRed = ProbabilityR >2*std2(ProbabilityR); %fine tuning needed
        maskYellow = ProbabilityY > 6*std2(ProbabilityY); %final value
        maskGreen = ProbabilityG > 9*std2(ProbabilityG); %final value
%         [BoundaryRed,L] = bwboundaries(maskRed,'holes');
%         [BoundaryYellow,L] = bwboundaries(maskYellow,'holes');
%         [BoundaryGreen,L] = bwboundaries(maskGreen,'holes');
%         tIR = tI(:,:,1);
%         tIG = tI(:,:,2);
%         tIB = tI(:,:,3);
%         tIR(maskRed) = 256;
%         tIG(maskRed) = 0;
%         tIB(maskRed) = 0;
%         
%         tIG(maskYellow) = 256;
%         tIR(maskYellow) = 256;
%         tIB(maskYellow) = 0;
%         
%         tIG(maskGreen) = 256;
%         output(:,:,1) = tIR;
%         output(:,:,2) = tIG;
%         output(:,:,3) = tIB;
%         imshow(output);hold on;
%         for k = 1:length(BoundaryRed)
%             boundaryRed = BoundaryRed{k};
%             plot(boundaryRed(:,2), boundaryRed(:,1), 'k', 'LineWidth', 2);
%         end
%         for k = 1:length(BoundaryYellow)
%             boundaryYellow = BoundaryYellow{k};
%             plot(boundaryYellow(:,2), boundaryYellow(:,1), 'w', 'LineWidth', 2);
%         end
%         for k = 1:length(BoundaryGreen)
%             BoundaryGreen = BoundaryGreen{k};
%             plot(BoundaryGreen(:,2), BoundaryGreen(:,1), 'b', 'LineWidth', 2);
%         end
%         newimagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Output\Part1\out_' num2str(j) '.png'];
%         saveas(figure1,newimagename);
imshow(tI);hold on;
maskR2=zeros(size(maskR));
maskR(1:90,:)=0;
maskR=bwareafilt(maskR,[200,5500]);
propsR=regionprops(maskR);
ccR = bwconncomp(maskR);
if ccR.NumObjects>0
    numPixelsR = cellfun(@numel,ccR.PixelIdxList);
    [biggestR,idxR] = max(numPixelsR);
    maskR2(ccR.PixelIdxList{idxR}) = 1;
    [bwR,~] = bwboundaries(maskR2,'holes');
    plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
end
maskY2=zeros(size(maskY));
maskY=bwareafilt(maskY,[200,2000]);
propsY=regionprops(maskY);
ccY = bwconncomp(maskY);
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
maskY2=imdilate(maskY2,strel('disk',5));
[bwY,~] = bwboundaries(maskY2,'holes');
plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);
if(j<23)
maskG=bwareafilt(maskG,[1,150]);
maskG2=zeros(size(maskG));
propsG=regionprops(maskG);
ccG = bwconncomp(maskG);
numPixelsG = cellfun(@numel,ccG.PixelIdxList);
[biggestG,idxG] = max(numPixelsG);
if(~isempty(idxG))
maskG2(ccG.PixelIdxList{idxG}) = 1;
maskG2=imdilate(maskG2,strel('disk',10));
[bwG,~] = bwboundaries(maskG2,'holes');
    plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
end
end
newimagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Output\Part2\out_' num2str(j) '.png'];
saveas(figure1,newimagename);
end