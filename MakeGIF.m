function MakeGIF( ImgSeries )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
    str = sprintf('D:\\Matlab\\Depth2gif\\material\\%d.jpg',i); %ͼƬ����λ�ú����ͣ�ע�������ͼƬ���Ͳ�����bmp��ʽ
    img = imread(str);     %��ȡͼ��
    figure(i)
    imshow(img)
%     set(gcf,'color','w');  %���ñ���Ϊ��ɫ
%     set(gca,'units','pixels','Visible','off');
%     frame = getframe(gcf); 
%     im = frame2im(frame);     %��ӰƬ����ת��Ϊ��ַͼ��,��Ϊͼ�������index����ͼ��
%     %imshow(im);
    [I,map] = rgb2ind(img,256); %�����ɫͼ��ת��Ϊ����ͼ��
    if i==1;
        imwrite(I,map,filename,'gif','Loopcount',inf,'DelayTime',0.1);     %Loopcountֻ����i==1��ʱ�������
    else
        imwrite(I,map,filename,'gif','WriteMode','append','DelayTime',0.1);%DelayTime:֡��֮֡���ʱ����
    end
end
end

