% 3d dataset fitting using optimization techniques
close all;
clear all;
clc;

% add these lines and remove the above part in order to run on:-
% sprocket
load('mySave.mat');
% bunny
%load('bun.mat');

% Just inverting the dataset to match our code (for load files only)
V1=V1';
V2=V2';

% rotate and translate one of the data with any parameters you want 
V2=trans6(1.5,1.5,1.5,2,3,5)*V2;

%plotting the initial situation
figure;
scatter3(V1(1,:),V1(2,:),V1(3,:),'o');
hold on;
scatter3(V2(1,:),V2(2,:),V2(3,:),'*','r');
hold off;

%mean subtraction to decrease workload
m1x=mean(V1(1,:));
m1y=mean(V1(2,:));
m1z=mean(V1(3,:));
V1(1,:)=V1(1,:);
V1(2,:)=V1(2,:);
V1(3,:)=V1(3,:);

mx=mean(V2(1,:));
my=mean(V2(2,:));
mz=mean(V2(3,:));

V2(1,:)=V2(1,:)-(mx-m1x);
V2(2,:)=V2(2,:)-(my-m1y);
V2(3,:)=V2(3,:)-(mz-m1z);

%initial guess
x2=[1 1 1 0 0 0];

%cost function
ObjectiveFunction2 = @(x) volum(x,V1,V2);
lb=[-pi -pi -pi -10 -10 -10];
ub=[pi pi pi 10 10 10];

% a combination of simulated annealing and local minima finding
for i=1:1
    x2 = simulannealbnd(ObjectiveFunction2,x2,lb,ub)
    x2 = fminsearch(ObjectiveFunction2,x2)

%plotting the output
    V1=trans6(x2(1),x2(2),x2(3),x2(4),x2(5),x2(6))*V1;
    figure;
    scatter3(V1(1,:),V1(2,:),V1(3,:),'o');
    hold on;
    scatter3(V2(1,:),V2(2,:),V2(3,:),'*','r');
    hold off;

end
