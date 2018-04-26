s = RandStream('mlfg6331_64'); 
y = 1:20;
for i = 1:20
   Imagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Scripts\AllImages\' num2str(y(i)) '.png'];
   I = imread(Imagename);
   TrainingImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\Frames\' num2str(y(i)) '.png'];
   imwrite(I,TrainingImagename);
   croppedBuoyRed = roipoly(I);
   if(~isempty(croppedBuoyRed))
   RedBuoyImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\R_' num2str(y(i)) '.png'];
   imwrite(croppedBuoyRed,RedBuoyImagename);
   end
   croppedBuoyYellow = roipoly(I);
   if(~isempty(croppedBuoyYellow))
   YellowBuoyImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\Y_' num2str(y(i)) '.png'];
   imwrite(croppedBuoyYellow,YellowBuoyImagename);
   end
   croppedBuoyGreen = roipoly(I);
   if(~isempty(croppedBuoyGreen))
   GreenBuoyImagename = ['D:\Education\Fall 2017\Semester2\Perception\Project3\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\G_' num2str(y(i)) '.png'];
   imwrite(croppedBuoyGreen,GreenBuoyImagename);
   end
end