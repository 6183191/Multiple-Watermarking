clear
clc
addpath(genpath('JPEG_Toolbox'));

Data = round(rand(1,1000000)*1);%�������01���أ���ΪǶ�������
water = imread('shuiyintuxiang.jpg');
water = rgb2gray(water);




payload =1000000;
I = imread('zaitituxiang2.jpg');
imwrite(I,'zaiti4.jpg','jpeg','quality',100);%������������Ϊ70��JPEGͼ��
imwrite(I,'Ori_zaiti4.jpg','jpeg','quality',100);%������������Ϊ70��JPEGͼ��
%% ����JPEG�ļ�
jpeg_info = jpeg_read('zaiti4.jpg');%����JPEGͼ��
ori_jpeg_80 = imread('zaiti4.jpg');%��ȡԭʼjpegͼ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
[num1,num_1] = jpeg_hist(dct_coef);%���Ʒ���acϵ��ֱ��ͼ
%% ����Ƕ��
[emdData,numData,jpeg_info_stego] = jpeg_emdding(Data,dct_coef,jpeg_info,payload);
jpeg_write(jpeg_info_stego,'stego_zaiti4.jpg');%��������jpegͼ��
stego_jpeg_80 = imread('stego_zaiti4.jpg');%��ȡ����jpegͼ��
%% �ֿ���ȡhashֵ
for row=1:64
    for col=1:64
        BLOCK_1=stego_jpeg_80((row-1)*8+1:row*8,(col-1)*8+1:col*8);
        hash=sha256(BLOCK_1);
        dechash=reshape(hex2dec(reshape(dec2hex(hash),[64,1])),[8,8]);
        shahash((row-1)*8+1:row*8,(col-1)*8+1:col*8)=dechash;
    end
end

%% ����ͼ��ֲ�
msb=224;
lsb=31;
for p=1:512
    for q=1:512
        LSB(p,q)=bitand(stego_jpeg_80(p,q),lsb);
    end
end
for p=1:512
    for q=1:512
        MSB(p,q)=bitand(stego_jpeg_80(p,q),msb);
    end
end
subplot(1,2,1)
imshow(LSB)
title('LSB  plane')
subplot(1,2,2)
imshow(MSB)
title('MSB plane')
imwrite(LSB,'LSB_plane.jpg')
imwrite(MSB,'MSB_plane.jpg')
%% ͼ����ϢǶ��
shahash = uint8(shahash)
MSB_stego = MSB+shahash;

imshow(MSB_stego)
title('MSB Stego')
imwrite(MSB_stego,'MSB_stego.jpg')

%% �������
Log_MSB=Logistic(MSB_stego);



imshow(Log_MSB)
title('MSB���ܺ�ͼ��')
Log_LSB=Logistic(LSB);

%% ������ȡ
stego_jpeg_info = jpeg_read('stego_zaiti4.jpg');%����JPEGͼ��
[numData2,stego_jpeg_info,extData] = jpeg_extract(stego_jpeg_info,payload);
jpeg_write(stego_jpeg_info,'re_zaiti4.jpg');%����ָ�jpegͼ��
re_jpeg_80 = imread('re_zaiti4.jpg');%��ȡ�ָ�jpegͼ��
%% ��ʾ
figure;
subplot(221);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(222);imshow(ori_jpeg_80);title('ԭʼͼ��');%��ʾJPEGѹ��ͼ��
subplot(223);imshow(stego_jpeg_80);title('����ͼ��');%��ʾstego_jpeg_80
subplot(224);imshow(re_jpeg_80);title('�ָ�ͼ��');%��ʾ�ָ�ͼ��
%% ͼ�������Ƚ�
psnrvalue1 = psnr(ori_jpeg_80,stego_jpeg_80);
psnrvalue2 = psnr(ori_jpeg_80,re_jpeg_80);
v = isequal(emdData,extData);
if psnrvalue2 == -1
    disp('�ָ�ͼ����ԭʼͼ����ȫһ�¡�');
elseif psnrvalue2 ~= -1
    disp('warning���ָ�ͼ����ԭʼͼ��һ�£�');
end
if v == 1
    disp('��ȡ������Ƕ��������ȫһ�¡�');
elseif v ~= 1
    disp('warning����ȡ������Ƕ�����ݲ�һ��');
end
ori_filesize = imfinfo('stego_zaiti4.jpg');