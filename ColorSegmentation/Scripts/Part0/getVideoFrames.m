vidobj = VideoReader('detectbuoy.avi');
i =1;
frames=vidobj.Numberofframes;
for f=1:frames
 thisframe=read(vidobj,f);
 newimagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Scripts\AllImages\' num2str(i) '.png'];
imwrite(thisframe,newimagename);
 i = i+1;
end