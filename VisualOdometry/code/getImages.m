function [K,images] = getImages()
imagefiles = dir(strcat(pwd,'\stereo\centre\','*.png'));      
nfiles = length(imagefiles);
    for ii=1:nfiles
        currentfilename = imagefiles(ii).name;
        currentimage = imread(strcat(pwd,'\stereo\centre\',currentfilename));
        image = demosaic(currentimage,'gbrg');
        [fx,fy,cx,cy,~,LUT]=ReadCameraModel('.\stereo\centre','.\model');
        images = UndistortImage(image, LUT);
        baseFileName = sprintf('%d.png', ii);
        fullFileName = fullfile('.\processed\', baseFileName);
        imwrite(images, fullFileName);
    end
    K = [fx 0 cx;0 fy cy;0 0 1];
end