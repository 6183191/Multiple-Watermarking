clc 
clear
x =[1000:1000:15000];
psnr1=[56.4339,51.5677,49.3426,47.6382,46.0232,44.6027,43.8004,43.0282,42.2747,41.7202,41.2528,40.8201,40.4500,40.1491,39.9183];
plot(x(1,:),psnr1(1,:),'r-*');%�ҵ�
legend('propose');
xlabel('Payload(bpp)');
ylabel('PSNR(dB)');