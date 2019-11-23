function [ NewImg ] = OverLap( OrgImg, FeatureImg, step )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
step=round(step+5);
[h,w]=size(FeatureImg);
for i=1:h
    for j=1:w
        if FeatureImg(i,j)==-1
            OrgImg(i,j)=OrgImg(i,j);
        else
            if j+step>0&&j+step<=w
                OrgImg(i,j+step)=FeatureImg(i,j);
            end
        end
    end
end
NewImg=OrgImg;
end

