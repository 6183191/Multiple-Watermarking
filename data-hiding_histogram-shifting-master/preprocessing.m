img = imread('shuiyin123.jpg');
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if img(i,j) == 0
            img(i,j) = 0;
        else
            img(i,j) = 255;
        end
    end
end


img = dicomread(filepath);%��ȡͼƬ         
img=double(img); %���Ҷȼ�ӳ�䵽0~255        
low=min(min(img));        
high=max(max(img));        
maxgray=high-low;%���㴰��        
rate=256/maxgray;        
img=img*rate;        
img=img+abs(min(min(img)));%�Ӵ�        
img=uint8(img);%ת��Ϊ8λ��λͼ���ݸ�        
imwrite(img,filepath_save);

