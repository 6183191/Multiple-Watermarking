img = dicomread('000003');%��ȡͼƬ         
img=double(img); %���Ҷȼ�ӳ�䵽0~255        
low=min(min(img));        
high=max(max(img));        
maxgray=high-low;%���㴰��        
rate=256/maxgray;        
img=img*rate;        
img=img+abs(min(min(img)));%�Ӵ�        
img=uint8(img);%ת��Ϊ8λ��λͼ���ݸ�        
imshow(img)