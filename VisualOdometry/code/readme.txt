The file project2.m is the main executable code. 
Drag and drop Oxford dataset images folder into the input folder(this has been omitted to reduce zip size and upload time)
Change the path for the input based on how the folder structure for the input is in getImages.
Run the getImages() command from the command line, A new folder called processed is created in the code folder with the 
undistorted RGB images.This step was done to reduce the computation time for each of the images.
Once all the images are stored in the processed folder, Run project2.m


The getFeatures.m file is my code implementing the Harris corner detection, matlab's inbuilt function has been used for speed in
the main code.
