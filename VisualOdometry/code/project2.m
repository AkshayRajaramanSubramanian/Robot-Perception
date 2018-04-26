clear
clc
W = [0 1 0;-1 0 0;0 0 1];
[fx,fy,cx,cy,~,LUT]=ReadCameraModel('.\stereo\centre','.\model');
K = [fx 0 cx;0 fy cy;0 0 1];
points(1,:)=[0;0;0];
RotationMatrix{1} = eye(3);

TranslationMatrix{1} = [0 0 0]';
Z = [0 -1 0;1 0 0;0 0 0];

for i = 1:3873
    %Obtaining the features and correspondence points
    minCost = 1000;
    baseFileName1 = sprintf('%d.png', i);
    fullFileName1 = fullfile('.\processed\', baseFileName1);
    baseFileName2 = sprintf('%d.png', i+1);
    fullFileName2 = fullfile('.\processed\', baseFileName2);
    
    image1 = imread(fullFileName1);
    image2 = imread(fullFileName2);
    points1 = detectHarrisFeatures(rgb2gray(image1));
    points2 = detectHarrisFeatures(rgb2gray(image2));
    [features1,valid_points1] = extractFeatures(rgb2gray(image1),points1);
    [features2,valid_points2] = extractFeatures(rgb2gray(image2),points2);
    indexPairs = matchFeatures(features1,features2);
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);

    %calculating the Essential Matrix and Fundamental Matrix using RANSAC
    if(size(matchedPoints1.Location(:,1),1) > 8)
        x1 = matchedPoints1.Location(:,1);
        y1 = matchedPoints1.Location(:,2);
        x2 = matchedPoints2.Location(:,1);
        y2 = matchedPoints2.Location(:,2);
        for iterations = 1:1000
            cost = 0;
            random = randi(size(x1,1),8,1);
            [N1,T1] = normalize([x1(random,:) y1(random,:)]');
            [N2,T2] = normalize([x2(random,:) y2(random,:)]');
                    one= ones(8,1);
            m1 = N1(1,:);
            n1 = N1(2,:);
            m2 = N2(1,:);
            n2 = N2(2,:);
            A = [m2'.*m1' m2'.*n1' m2' n2'.*m1' n2'.*n1' n2' m1' n1' one];
            [~,~,V] = svd(A,0);
            F = reshape(V(:,9),3,3)';
            [U,D,V] = svd(F,0);
            F = U*diag([D(1,1) D(2,2) 0])*V';
            F = T2'*F*T1;  
            F = F/norm(F);
            X1 = [m1' n1' ones(8,1)];
            X2 = [m2' n2' ones(8,1)];
            for ii = 1:8
                cost = cost+((X1(ii,:)*F)*X2(ii,:)')^2;
            end
            if(cost<minCost)
               minCost = cost;
               FundamentalMatrix = F;
               XX1 = X1;
               XX2 = X2;
            end
        end
        
        
    else
        RotationMatrix{i+1} = eye(3);
        translationMatrix{i+1} = [0 0 0]';
    end
    
    
    
    
    %Obtaining the Rotation and Translation Matrices
    E = (K'*FundamentalMatrix)*K;
    [U,D,V] = svd(E);
    E = (U*diag([1 1 0]))*V';
    if(uint8(det(U*V)) == 1)
        EssentialMatrix{i} = E;
    else
        EssentialMatrix{i} = -E;
    end
    [U,D,V] = svd(E);
    R1 = (U*W)*V';
    if(det(R1)<0)
        R1 = -R1;
    end
    R2 = (U*W')*V';
    if(det(R2)<0)
        R2 = -R2;
    end
    T{i} = (U*Z)*U';
    translation1=round([T{i}(3,2); T{i}(1,3); T{i}(2,1)]);
    translation2= -round([T{i}(3,2); T{i}(1,3); T{i}(2,1)]);
    
    if(translation1(3,1)>0)
        translationMatrix{i+1} = translation1;
    else
        translationMatrix{i+1} = translation2;
    end
    if(R1(2,2)>0)
        RotationMatrix{i+1} = R1;
    else
        RotationMatrix{i+1} = R2;
    end
     RotationMatrix{i+1} = RotationMatrix{i+1}*RotationMatrix{i};
     %translationMatrix{i+1} = translationMatrix{i+1}+translationMatrix{i};
    points(i+1,:) = RotationMatrix{i+1}*translationMatrix{i+1}+points(i,:)';
    i
end