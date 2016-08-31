%Warning: in order to run this file, first set the exact path of the
%directory of un-normalized images in line 8 of this code

% SVD for Images
clc
clear all
%change the path to where the images are on your computer
directory =  'C:\\all_faces\';
%reading all the images
filenames = dir(strcat(directory,'*.jpg'));
filenames = {filenames.name};
len = length(filenames);
MaxIter = 20;
s = zeros(6,len);
filename = char(filenames(1));
filename = strrep(filename,'.jpg','.txt');
filename = strrep(filename,'.JPG','.txt');
[x, y] = textread(strcat(directory,filename),'%u %u', 'delimiter', '\n');
F = [];
for j = 1:5
    F = [F; x(j); y(j)];  
end
%finding transformation indices
b = [13 20 50 20 34 34 16 50 48 50]';
A = [];
for j = 1:5
    A = [A; F(2*j-1) F(2*j) 0 0 1 0; 0 0 F(2*j-1) F(2*j) 0 1];  
end
sprime = pinv(A)*b;
Fnew = [];
for j = 1:5
    temp = [sprime(1) sprime(2); sprime(3) sprime(4)]*[F(2*j-1);F(2*j)] + [sprime(5); sprime(6)];
    Fnew = [Fnew; temp];
end
F = Fnew;
pA = zeros(6,10,len);
%normalizing
for iter=1:MaxIter
    Fold = F;
    Ftotal = zeros(10,1);
    for i=1:len
        filename = char(filenames(i));
        filename = strrep(filename,'.jpg','.txt');
        filename = strrep(filename,'.JPG','.txt');
        [x, y] = textread(strcat(directory,filename),'%u %u', 'delimiter', '\n');
        Fi = [];
        for j = 1:5
            Fi = [Fi; x(j); y(j)];  
        end
        b = F;
        if (iter == 1)
            A = [];
            for j = 1:5
                A = [A; Fi(2*j-1) Fi(2*j) 0 0 1 0; 0 0 Fi(2*j-1) Fi(2*j) 0 1];  
            end
            pA(:,:,i) = pinv(A);
        end
        s(:,i) = pA(:,:,i)*b;
        Fnew = [];
        for j = 1:5
            temp = [s(1,i) s(2,i); s(3,i) s(4,i)]*[Fi(2*j-1);Fi(2*j)] + [s(5,i); s(6,i)];
            Fnew = [Fnew; temp];
        end
        Ftotal = Ftotal + Fnew;
    end
    F = Ftotal/len;
    if (norm(F-Fold) <= 2)
        break;
    end    
end

disp('SVD Normalization Converged in Iteration :')
disp(iter)
%splitting into test and train images
out_directory = 'C:\\normalized_faces\';
for i=1:len
    filename = char(filenames(i));
    I = imread(strcat(directory,filename));
    I = rgb2gray(I);
    [m, n] = size(I);
    I0 = zeros(64,64);
    
    for k=1:64
        for j=1:64
            f = round(([s(1,i) s(2,i); s(3,i) s(4,i)])\([j;k] - [s(5,i); s(6,i)]));
            if ((f(1) > 0) && (f(1) <= n) && (f(2) > 0) && (f(2) <= m))
                I0(k,j)=I(f(2),f(1));
            end
        end
    end    
    
    I0 = uint8(I0);
    imwrite(I0,strcat(out_directory,filename),'jpg');
end



        