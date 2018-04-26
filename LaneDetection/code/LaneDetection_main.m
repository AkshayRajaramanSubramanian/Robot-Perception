%Change the path of the input video based on requirements
vid = VideoReader('D://Education/Fall 2017/Semester2/Perception/Project1/P1_Submission/LaneDetection/input/project_video.mp4');
 ii = 1;
 newSlope = [];
 while hasFrame(vid)
    clear img Image Edge BW
    img = medfilt2(rgb2gray(readFrame(vid)),[5 5]);
    Image = wiener2(img,[5 5]);
    h = (fspecial('sobel'))';
    Edge = imfilter(Image,h);
    Edge = imbinarize(Edge);
    se = strel('line',3,3);
    Edge = imerode(Edge,se);
    Edge(1:425,:) = 0;
    BW = Edge;
    [H,T,R] = hough(BW);
    P  = houghpeaks(H,5,'threshold',ceil(0.4*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));

    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',9);
    figure1 = figure;set(figure1, 'Visible', 'off')
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 4 3])
    imshow(Image), hold on
    max_len = 0;
    [rows,columns] = size(BW);
    posSlopeExists = 0;
    negSlopeExists = 0;
    isLeft = 0;
    isRight = 0;
    isStraight = 0;
    avgSlope = 0;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        %plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','red');
        x1 = xy(1,1);
    	y1 = xy(1,2);
    	x2 = xy(2,1);
    	y2 = xy(2,2);
    	slope = (y2-y1)/(x2-x1); 
        if(slope>0 && posSlopeExists==0)
            posSlopeExists = 1;
            newSlope(ii,1) = slope;
        elseif(slope<0 && negSlopeExists==0)
            negSlopeExists = 1;
            newSlope(ii,2) = slope;
            if(slope<-0.85)
                isLeft = 1;
                isStraight = 0;
                isRight = 0;
            elseif(slope<-0.7 && slope>-0.85)
                isLeft= 0;
                isRight = 0;
                isStraight = 1;
            else
                isLeft = 0;
                isStraight = 0;
                isRight = 1;
            end
        else
            slope = 0;
        end
        yBottom = rows;
        xBottom = ((yBottom-y1)/slope)+x1;
        yTop = 426;
        xTop = ((yTop-y1)/slope)+x1;
        avgSlope = avgSlope+slope;
        if(slope ~=0)
    	plot([xBottom, xTop], [yBottom, yTop], 'LineWidth',5,'Color','red');
        end
   % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
            max_len = len;
            xy_long = xy;
        end
    end
    avgSlope = avgSlope/2;
    if(avgSlope > -0.01)
        text(150,100,'RIGHT','Color','r','FontWeight','Bold','FontSize',40)
    elseif(avgSlope <  -0.01 && avgSlope > -0.08)
        text(150,100,'STRAIGHT','Color','r','FontWeight','Bold','FontSize',40)
    elseif(avgSlope <-0.08 && avgSlope > -0.27)
        text(150,100,'LEFT','Color','r','FontWeight','Bold','FontSize',40)
    end
    folder = ['D:/Education/Fall 2017/Semester2/Perception/Project1/DataSet/Project1FramesNew/Changed',num2str(ii),'.jpg'];
    saveas(figure1,folder);
    ii = ii+1;
 end
 %Change path in both the below codes to the required value
 compileAsVideo
 viewVideo