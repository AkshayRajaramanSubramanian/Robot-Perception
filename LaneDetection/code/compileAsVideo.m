%change paths for outputVideo,vid and img
outputVideo = VideoWriter('Out2.avi');
 vid = VideoReader('D://Education/Fall 2017/Semester2/Perception/Project1/P1_Submission/LaneDetection/input/project_video.mp4');
outputVideo.FrameRate = vid.FrameRate;
open(outputVideo)
for j = 1:473
    img = imread(['D:/Education/Fall 2017/Semester2/Perception/Project1/DataSet/Project1FramesNew/Changed',num2str(j),'.jpg']);
   writeVideo(outputVideo,img);
end
close(outputVideo)
 