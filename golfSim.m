% image inversion routine

% camera assumptions
% z = forward [optical direction]
% x = right
% y = down

% drone and camera reference frame
% x = forward 
% y = right
% z = down [optical direction]

% need to rotate by -90 in x and then -90 in z to get to NED

% translation in meters and rotation in degrees
% x,y,z roll, pitch, yaw [NED reference frame]
pose = [0 0 -20 0 0 0];

% create object with a given pose 
Tapril = SE3(0,0,0);
Tquad = SE3(pose(1:3)) * SE3.rpy(pose(4:6),'deg', 'zyx');
Tcamera = SE3.Rz(90,'deg');

% set the corners for the object with the pose listed above
corners = [ 10   10   -10  -10;
           -10   10   10   -10;
             0    0    0     0;];  
            
ball = [0;0;0];
         
% create default camera
cam = CentralCamera('default');

% project the corners onto the camera focal plane
p = cam.plot([corners ball],'objpose',Tapril, 'pose', Tquad*Tcamera)

figure
plot(Tapril,'color','r')
hold on
plot(Tquad*Tcamera,'color','g')
set(gca, 'Zdir', 'reverse')
set(gca, 'Ydir', 'reverse')
scatter3(corners(1,:),corners(2,:),corners(3,:))
zlim auto
xlim auto
ylim auto

% generate homography
% homography is only for planes so it only works on x,y data.

h = homography(corners(1:2,:),p(:,1:4));

cornersInvert = h2e(inv(h)*e2h(p))
