%transformation matrix for rotation and translation
function P=trans6(Qx, Qy, Qz,tx,ty,tz)
    r=[1 0 0;0 cos(Qx) -sin(Qx);0 sin(Qx) cos(Qx)]*[cos(Qy) 0 -sin(Qy);0 1 0; sin(Qy) 0 cos(Qy)]*[cos(Qz) -sin(Qz) 0;sin(Qz) cos(Qz) 0; 0 0 1];
    t=[tx;ty;tz];
% converting to 4x4 matrix
    p=[r, t];
    t=[0 0 0 1];
    P=[p;t];
end