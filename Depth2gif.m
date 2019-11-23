OrgImg=imread('bear.jpg');
DphImg=imread('bear_depth.jpg');
DphImg=rgb2gray(DphImg);
imshow(DphImg);
MAXMOVE=8;
LEVEL=6;
FRAME=6;
OrgImg=double(OrgImg);
[h,w]=size(DphImg);

Threshold=255/(LEVEL-1);
for i=1:LEVEL
%   figure
    NewImgR=OrgImg(:,:,1);
    NewImgG=OrgImg(:,:,2);
    NewImgB=OrgImg(:,:,3);
    if i==1
        NewImgR(find(DphImg<(i-1)*Threshold|DphImg>i*Threshold))=-1;
        NewImgG(find(DphImg<(i-1)*Threshold|DphImg>i*Threshold))=-1;
        NewImgB(find(DphImg<(i-1)*Threshold|DphImg>i*Threshold))=-1;
    else
        NewImgR(find(DphImg<=(i-1)*Threshold|DphImg>i*Threshold))=-1;
        NewImgG(find(DphImg<=(i-1)*Threshold|DphImg>i*Threshold))=-1;
        NewImgB(find(DphImg<=(i-1)*Threshold|DphImg>i*Threshold))=-1;
    end
    NewImg{i}=cat(3,NewImgR,NewImgG,NewImgB);
    imshow(NewImg{i});

end
figure
for i=1:FRAME
    [h,w]=size(DphImg);
    EmtImg=zeros(h,w,3);
    for j=1:LEVEL
        FeatureImg=NewImg{j};
        EmtImg(:,:,1)=OverLap(EmtImg(:,:,1),FeatureImg(:,:,1),MAXMOVE/LEVEL*j*(i-round(FRAME/2)));
        EmtImg(:,:,2)=OverLap(EmtImg(:,:,2),FeatureImg(:,:,2),MAXMOVE/LEVEL*j*(i-round(FRAME/2)));
        EmtImg(:,:,3)=OverLap(EmtImg(:,:,3),FeatureImg(:,:,3),MAXMOVE/LEVEL*j*(i-round(FRAME/2)));
        EmtImg=uint8(EmtImg);
        %imshow(EmtImg);
    end
    FinalImg{i}=EmtImg(:,1+MAXMOVE*round(FRAME/2):w-round(FRAME/2),:);
end
MakeGIF( FinalImg );
% for i=1:FRAME
%     imshow(FinalImg{i});
% end
% [h,w]=size(DphImg);
% NewImg=zeros(h,w);
% for i=1:FRAME
%     
% end
