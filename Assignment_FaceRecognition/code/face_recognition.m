% PCA for images

clc
clear all
close all;
%reading all the images
train_dir = 'train_faces\';
test_dir = 'test_faces\';
train_filenames = dir(strcat(train_dir,'*.jpg'));
train_filenames = {train_filenames.name};
test_filenames = dir(strcat(test_dir,'*.jpg'));
test_filenames = {test_filenames.name};
train_length = length(train_filenames);
test_length = length(test_filenames);
train_data = [];
test_data = [];
train_labels = cell(train_length,1);
test_labels = cell(test_length,1);
indextrain = 1;
indextest = 1;
%assigning name labels to each image
for i=1:train_length
    filename = char(train_filenames(i));
    I = imread(strcat(train_dir,filename));
    I = reshape(I, 1, 64*64);
    label = strrep(filename,'.jpg','');
    label = strrep(label,'.JPG','');
    label = strrep(label,'1','');
    label = strrep(label,'2','');
    label = strrep(label,'3','');
    label = strrep(label,'4','');
    label = strrep(label,'5','');
    label = strrep(label,'_','');
    train_labels{indextrain} = label;
    indextrain = indextrain + 1;
    train_data = [train_data; double(I)];
end
for i=1:test_length
    filename = char(test_filenames(i));
    I = imread(strcat(test_dir,filename));
    I = reshape(I, 1, 64*64);
    label = strrep(filename,'.jpg','');
    label = strrep(label,'.JPG','');
    label = strrep(label,'1','');
    label = strrep(label,'2','');
    label = strrep(label,'3','');
    label = strrep(label,'4','');
    label = strrep(label,'5','');
    label = strrep(label,'_','');
    test_labels{indextest} = label;
    indextest = indextest + 1;
    test_data = [test_data; double(I)];
end


% PCA

Npca = 10;

D = train_data;
[p, d] = size(D);
meanD = mean(D);
D = D - repmat(meanD,p,1);

C=(1/(p-1))*(D*D');
[U,E] = eig(C);
V = D'*U;

[t,k] = sort(diag(E),'descend');
knew = k(1:Npca,:);
Vnew = V(:,knew');
datanew = D*Vnew;

[N,~] = size(test_data);
error = 0;
%finding the best matches
for i = 1:N
    FeatureQ = test_data(i,:) - meanD;
    FeatureQ = FeatureQ*Vnew;
    t = [];
    for j = 1:p
        t = [t; norm(FeatureQ-datanew(j,:))];
    end
    [val,ind] = sort(t);
    disp('Test label : ')
    disp(test_labels(i))
    disp('Top 3 Matched labels : ');
    disp(train_labels(ind(1:3)))
%output screens for all images    
    hFig = figure;
    set(hFig, 'Position', [250 250 450 250])
    set(gcf,'color','w');
    subplot(2,3,2);
    imshow(uint8(reshape(test_data(i,:),64,64)));
    title(test_labels(i),'Color','r');
    for dis=2:4
        subplot(2,3,dis+2);
        imshow(uint8(reshape(train_data(ind(dis-1),:),64,64)));
        title(train_labels(ind(dis-1)),'Color','b');
    end
%finding accuracy of the system
    if (strcmp(train_labels(ind(1)),test_labels(i)) ~= 1)
        error = error + 1;
    end
%gender classification
    girl=0;
    for g=1:3
        if (strcmp(train_labels(ind(g)),'Armine') == 1 || strcmp(train_labels(ind(g)),'PaolaArdon') == 1)
            girl=girl+1;
        end
    end
    if girl<=1
        disp(sprintf ( '\t Boy') )
        suptitle('BOY');
    else
        disp(sprintf ( '\t Girl') )
        suptitle('GIRL');
    end
end
%displaying accuracy on matlab screen
acc = (1-error/N)*100;
disp('Accuracy % : ')
disp(acc)
    


