% image inversion routine

% camera assumptions
% z = forward
% x = right
% y = down

% drone and camera reference frame
% x = forward [optical direction]
% y = right
% z = down

% need to rotate by -90 in x and then -90 in z to get to NED

% translation in meters and rotation in degrees
% x,y,z roll, pitch, yaw [NED reference frame]
pose = [-1 0 0 0 0 0];

% create object with a given pose 
Tapril = SE3(0,0,0);
Tquad = SE3(pose(1:3)) * SE3.rpy(pose(4:6),'deg', 'zyx');
Tcamera = SE3.Ry(90,'deg') * SE3.Rz(90,'deg');

% set the corners for the object with the pose listed above
corners = [ 0  0   0   0;
           .1 -.1 -.1 .1;
           .1 .1 -.1 -.1;];  
       
ball =     [ 0 .5 0]';
        
% create default camera
cam = CentralCamera('default');

% project the corners onto the camera focal plane
p = cam.plot(corners,'objpose',Tapril, 'pose', Tquad*Tcamera);

figure
plot(Tapril,'color','r')
hold on
plot(Tquad,'color','g')
set(gca, 'Zdir', 'reverse')
set(gca, 'Ydir', 'reverse')

% generate homography
% homography is only for planes so it only works on x,y data.

h = homography(corners(2:3,:),p);

cornersInvert = h2e(inv(h)*e2h(p));

inversionError = corners(2:3,:) - cornersInvert
