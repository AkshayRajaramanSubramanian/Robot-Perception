windowSize = 7;
cost = [];
I_L = padarray(imread('tsukuba_l.png'),[floor(windowSize/2) floor(windowSize/2)]);
I_R = padarray(imread('tsukuba_r.png'),[floor(windowSize/2) floor(windowSize/2)]);
for i = 1:windowSize:size(I_L,1)-windowSize+1
    i
   for j = 1:windowSize:size(I_L,2)-windowSize+1
        for k = 1:size(I_L,2)-windowSize+1
                cost(k) = sum(sum((double(I_L(i:i+windowSize-1,j:j+windowSize-1))-double(I_R(i:i+windowSize-1,k:k+windowSize-1))).^2));
        end
        [a,m] = min(cost);
         if abs(j-m)<30
            diss(i:i+windowSize-1,j:j+windowSize-1) = abs(j-m);
         else
             diss(i:i+windowSize-1,j:j+windowSize-1) = 0;
         end
   end
end
figure;imagesc(uint8(diss*255/max(max(diss))));colormap(gray);axis image;