function MakeGIF( ImgSeries )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
count=1;
for i=1:size(ImgSeries,2)
    filename=['D:\\Matlab\\Depth2gif\\material\\',num2str(count),'.jpg'];
    Img=ImgSeries{i};
    imwrite(uint8(Img),filename);
    count=count+1;
end
for i=size(ImgSeries,2)-1:-1:2
    filename=['D:\\Matlab\\Depth2gif\\material\\',num2str(count),'.jpg'];
    Img=ImgSeries{i};
    imwrite(uint8(Img),filename);
    count=count+1;
end

filename='D:\\Matlab\\Depth2gif\\bear_move.gif';
for i=1:count-1
    str = sprintf('D:\\Matlab\\Depth2gif\\material\\%d.jpg',i); %图片绝对位置和类型，注意这里的图片类型不能是bmp格式
    img = imread(str);     %读取图像
    figure(i)
    imshow(img)
%     set(gcf,'color','w');  %设置背景为白色
%     set(gca,'units','pixels','Visible','off');
%     frame = getframe(gcf); 
%     im = frame2im(frame);     %将影片动画转换为编址图像,因为图像必须是index索引图像
%     %imshow(im);
    [I,map] = rgb2ind(img,256); %将真彩色图像转化为索引图像
    if i==1;
        imwrite(I,map,filename,'gif','Loopcount',inf,'DelayTime',0.1);     %Loopcount只是在i==1的时候才有用
    else
        imwrite(I,map,filename,'gif','WriteMode','append','DelayTime',0.1);%DelayTime:帧与帧之间的时间间隔
    end
end
end

