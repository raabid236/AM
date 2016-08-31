% cost function depending on volume approximation
function y=volum(x,V1,V2)
% apply transformation and compute volume of one data set
V1=trans6(x(1),x(2),x(3),x(4),x(5),x(6))*V1;
v1=[V1(1,:);V1(2,:);V1(3,:)];
[k, y1]= convhulln(v1');
% finding volume of both datasets combined and subtract from the first one
% to get a nice cost function
v2=[V2(1,:);V2(2,:);V2(3,:)];
V=[v1 v2];
[k, y]= convhulln(V');
y=y-y1;
end