% perform inversion to bound an april tag given a pose

Tapril = SE3(0,0,1);
corners = [.1 -.1 -.1 .1;
           .1 .1 -.1 -.1;
            0  0   0   0];       
cam = CentralCamera('default');
p = cam.project(corners,'objpose',Tapril)
