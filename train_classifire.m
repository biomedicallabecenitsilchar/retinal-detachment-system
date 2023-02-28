imds = imageDatastore('E:\sonal project\GUI_project\original_dataset\training',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

figure
numImages = length(imds.Files);
perm = randperm(numImages,50);
for i = 1:50
    subplot(10,5,i);
    imshow(imds.Files{perm(i)});
    drawnow
end

% augmenter = imageDataAugmenter( ...
%     'RandXReflection',true, ...
%     'RandRotation',[-180 180],...
%     'RandXScale',[1 4], ...
%     'RandYReflection',true, ...
%     'RandYScale',[1 4])

[imdsTrain,imdsTest] = splitEachLabel(imds,0.7,'randomize');

% imageSize = [224 224 3];

augmentedTrainData = augmentedImageDatastore([224 224 3],imdsTrain,'ColorPreprocessing', 'gray2rgb');
augmentedTestData = augmentedImageDatastore([224 224 3],imdsTest,'ColorPreprocessing', 'gray2rgb');


layers = [ ...
    imageInputLayer([224 224 3],'Name','input')  
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer ];

% lgraph = layerGraph(layers);
% figure
% plot(lgraph)

options = trainingOptions('sgdm', ...
    'MaxEpochs',100,...
    'InitialLearnRate',1e-4, ...
    'Verbose',true, ...
    'Plots','training-progress');

net = trainNetwork(augmentedTrainData,layers,options);
analyzeNetwork(net)
%numel(net.Layers(end).ClassNames)

% imdsTest_rsz = augmentedImageDatastore(imageSize,imdsTest,'DataAugmentation',augmenter)
YPred = classify(net,augmentedTestData);
%YTest = imdsTest.Labels;
%accuracy = sum(YPred == YTest)/numel(YTest)

figure
idx = randperm(length(augmentedTestData.Files),25);
for i = 1:25
    subplot(5,5,i);
    I = readimage(imdsTest,idx(i));
    label = YPred(idx(i));
    imshow(I)
    title(char(label))
end

save net

I = imread(".\original_dataset\training\RD\1_output.jpg");
I2= imresize(I,[224,224],'nearest');
[Pred,scores] = classify(net,I2);
scores = max(double(scores*100));
figure
imshow(I);
title(join([string(Pred),'' ,scores ,'%']))
