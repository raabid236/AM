% TP Optimization Project
clc
clear all

%% Data Creating
[X,Y,Z] = cylinder([1 1],20);

[~,n] = size(X);

% First
X0 = X(:,round(0.2*n):round(n)); %discard 20% points           
Y0 = Y(:,round(0.2*n):round(n));                                       
Z0 = Z(:,round(0.2*n):round(n));              

[m0,n0] = size(X0);
data0 = [reshape(X0,m0*n0,1),reshape(Y0,m0*n0,1),reshape(Z0,m0*n0,1)];




% rotation in 3 planes
theta_xy = pi/3;
theta_xz = pi/6;
theta_yz = pi/3;
R_xy = [cos(theta_xy) -sin(theta_xy) 0;sin(theta_xy) cos(theta_xy) 0; 0 0 1];
R_xz = [cos(theta_xz) 0 -sin(theta_xz);0 1 0; sin(theta_xz) 0 cos(theta_xz)];
R_yz = [1 0 0; 0 cos(theta_yz) -sin(theta_yz);0 sin(theta_yz) cos(theta_yz)];

meand0 = mean(data0);
data1 = (R_xy * R_xz*R_yz*(data0-repmat(meand0,m0*n0,1))')' + repmat(meand0,m0*n0,1);


% translate in 3 directions
data1(:,1) = data1(:,1) + 2;
data1(:,2) = data1(:,2) + 2;
data1(:,3) = data1(:,3) + 4;

% Create another cylinder
[X,Y,Z] = cylinder([1 1],17);
[~,n] = size(X);

% % First
X0 = X(:,round(0.2*n):round(n)); %discard 20% points           
Y0 = Y(:,round(0.2*n):round(n));                                       
Z0 = Z(:,round(0.2*n):round(n));              

[m0,n0] = size(X0);
data0 = [reshape(X0,m0*n0,1),reshape(Y0,m0*n0,1),reshape(Z0,m0*n0,1)];

figure();
axis normal
scatter3(data0(:,1),data0(:,2),data0(:,3),'o'), hold on
scatter3(data1(:,1),data1(:,2),data1(:,3),'r*');
hold off;

%% fitting
figure;
mean_d0 = mean(data0);
mean_d1 = mean(data1);
translate = mean_d1 - mean_d0;


data1_new(:,1) = data1(:,1) - translate(1);
data1_new(:,2) = data1(:,2) - translate(2);
data1_new(:,3) = data1(:,3) - translate(3);

% BruteForce optimization to match cylinder 2 with cylinder 1
thre = 10000;
itr = 0;
while thre >0.0001 || itr <2
[t_xy, t_xz, t_yz] = meshgrid(0:0.2:2*pi, 0:0.2:2*pi, 0:0.2:2*pi);
[m,n,p] = size(t_xy);
minval = 100000;
t_xy_min = 0;
t_xz_min = 0;
t_yz_min = 0;
for i = 1:m
    for j=1:n
        for k=1:p
            temp = costfunction(data0,data1_new,t_xy(i,j,k),t_xz(i,j,k),t_yz(i,j,k));
            if (temp < minval)
                minval = temp;
                t_xy_min = t_xy(i,j,k);
                t_xz_min = t_xz(i,j,k);
                t_yz_min = t_yz(i,j,k);
            end
        end
    end
end

scatter3(data0(:,1),data0(:,2),data0(:,3),'o'), hold on

R_xy = [cos(t_xy_min) -sin(t_xy_min) 0;sin(t_xy_min) cos(t_xy_min) 0; 0 0 1];
R_xz = [cos(t_xz_min) 0 -sin(t_xz_min);0 1 0; sin(t_xz_min) 0 cos(t_xz_min)];
R_yz = [1 0 0; 0 cos(t_yz_min) -sin(t_yz_min);0 sin(t_yz_min) cos(t_yz_min)];


[m_new1,~] = size(data1_new);
meand0 = mean(data1_new);
data1_new = (R_xy *R_yz * R_xz * (data1_new-repmat(meand0,m_new1,1))')' + repmat(meand0,m_new1,1);

mean_new = mean(data1_new);
translate = mean_new - mean_d0;



data1_new(:,1) = data1_new(:,1) - translate(1);
data1_new(:,2) = data1_new(:,2) - translate(2);
data1_new(:,3) = data1_new(:,3) - translate(3);

thre = norm(mean_d0 - mean_new);

sca = scatter3(data1_new(:,1),data1_new(:,2),data1_new(:,3),'*','r'); hold off;
delete(sca);
itr = itr + 1;
end

scatter3(data0(:,1),data0(:,2),data0(:,3),'o'), hold on
scatter3(data1_new(:,1),data1_new(:,2),data1_new(:,3),'*','r'); hold off;