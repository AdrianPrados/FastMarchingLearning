function [points,count]= kinesthetic_teaching (M, dataset)

points = [];
button = 1;
count = 1;

s = warndlg('Introduce points of the trajectory by clicking on the map.To finish, press any other button than primary click.','Help','modal');
uiwait(s);
        

hold on;
imagesc(M'); 
axis image;
axis off;
colormap gray(256);
axis xy;
title('Obstacles Map');

imagesc(M')
if  ~numel(dataset)==0
 plot(dataset(1,:), dataset(2,:),'.b');
end
axis image;
axis off;
colormap gray(256);
axis xy;
title('Trajectory Map');

fx = size(M,1); % x size of the map
fy = size(M,2); % y size of the map

while button == 1
    [x, y, button] = ginput(1);
    x = round(x);
    y = round(y);
    if button == 1 
        if x > 0 && y > 0 && x < fx && y < fy && M(x,y)~=0 % no obstacle and it is in the range
            points(:,count) = [x; y];          
            count = count + 1;
            if count > 2 
                if points(:,count-1) == points(:,count-2) % two equal points, avoid to save two equal points in the same demo.
                    points(:,count-1) = []; 
                    count = count - 1;
                end
            end
        elseif x < 0 || y < 0 || x > fx || y > fy  % Restriction to dont use outside points
            l = errordlg('Point out of map bounds, please select another point.',...
            'Start point selection error','modal');
            uiwait(l);            
        elseif  M(x,y) == 0 % Point in an obstacle.
            l = errordlg('Point in an obstacle, please select another point.',...
            'Start point selection error','modal');
            uiwait(l);            
        end
    end
    plot(x,y,'.r');
end
