%change path for outAvi
outAvi = VideoReader('Out2.avi');
jj = 1;
while hasFrame(outAvi)
   mov(jj) = im2frame(readFrame(outAvi));
   jj = jj+1;
end
figure
imshow(mov(1).cdata)
movie(mov,1,outAvi.FrameRate)