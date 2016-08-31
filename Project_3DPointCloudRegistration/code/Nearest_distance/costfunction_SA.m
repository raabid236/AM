function val = costfunction_SA(data0, data1,p)
t_xy = p(1);
t_xz = p(2);
t_yz = p(3);
[m1,n1] = size(data1);
R_xy = [cos(t_xy) -sin(t_xy) 0;sin(t_xy) cos(t_xy) 0; 0 0 1];
R_xz = [cos(t_xz) 0 -sin(t_xz);0 1 0; sin(t_xz) 0 cos(t_xz)];
R_yz = [1 0 0; 0 cos(t_yz) -sin(t_yz);0 sin(t_yz) cos(t_yz)];
 

%% For the number of points in two points cloud
if size(data0,1) == size(data1,1)
    
    meand0 = mean(data1);
    d = (R_xy *R_yz * R_xz * (data1-repmat(meand0,m1,1))')' + repmat(meand0,m1,1);
    val = sqrt(sum(sum((data0 - d).^2)));
else
%% The number of points not the same in two points cloud
val = 0;
meand0 = mean(data1);
d_sb_mean = (R_xy *R_yz * R_xz * (data1-repmat(meand0,m1,1))')' + repmat(meand0,m1,1);
for i = 1 : m1
    d = d_sb_mean(i,:);
    %compute the Euclidean distance between this point and the points in the other cloud
    tmp = zeros(size(data0));
    tmp(:,1) = data0(:,1) - d(1);
    tmp(:,2) = data0(:,2) - d(2);
    tmp(:,3) = data0(:,3) - d(3);
    tmp = sqrt(sum(tmp.^2 , 2));
    [min_val,idx] = sort(tmp);
    val = val + min_val(1);
end
end
end

