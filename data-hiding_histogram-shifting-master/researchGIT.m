% �����������

clc,clear all

%% Here are your input file 

org = imread('90.bmp');

% org = double(org);

org = org(:)';% ����ת��,���������

[row,col] = size(org);%

rs = zeros(2, 4);% 2�����еľ���

cor = zeros(1, 3);

m = floor(col / 4);% ���ȳ���4

delta = -1;

while (delta < 0 )

    M = randsrc(4, 1, [0 1]);% �����������

    tmp = zeros(4, 1);

    % ʹ��LSB��׼�������ͼ����д��Ϊ40% 

    %msg_len = floor(sample_len * 0.4);

    %msg = randsrc(msg_len, 1, [0 1; 0.5 0.5]);

    stg =org;

    for i=1:2

        for j = 1 : m

            tmp = stg((j - 1) * 4 + 1 : j * 4); %��ͼ���Ϊ�ĸ�����һ�� ȡ���⼸��

            cor(1) = SpaceCor(tmp);

            cor(2) = SpaceCor(fpos(tmp, M));

            cor(3) = SpaceCor(fneg(tmp, M));

            if cor(2) > cor(1)

        %                 Rm

                rs(i, 1) = rs(i, 1) + 1;         

            end

            if cor(2) < cor(1)

        %                 Sm

                rs(i, 2) = rs(i, 2) + 1;

            end

            if cor(3) > cor(1)

        %                 R-m

                rs(i, 3) = rs(i, 3) + 1;

            end

            if cor(3) < cor(1)

        %                 S-m

                rs(i, 4) = rs(i, 4) + 1;

            end

            if 1 == i

                stg = fpos(stg, ones(col, 1));

            end

        end

    end

    rs = rs / m;

    % J. Fridrih����������д�ʣ����жϴ����ͼ��lena.bmp�Ƿ񾭹�LSB�滻��д

    % d0 = Rm(p/2)-Sm(p/2), d1=Rm(1-p/2)-Sm(1-p/2)

    dpz = rs(1, 1) - rs(1, 2); dpo = rs(2, 1) - rs(2, 2);

    % d-0 = R-m(p/2)-S-m(p/2), d-1=R-m(1-p/2)-S-m(1-p/2)

    dnz = rs(1, 3) - rs(1, 4); dno = rs(2, 3) - rs(2, 4);

    %�ж������ͼ��lena.bmp�Ƿ񾭹�LSB�滻��д

    % P = 2.5 * 1e-2;    %�趨����ֵ������RS����һ��Ϊ2%-3%

    % if  dnz > 0 && dpo > 0 %�����ж�Rm�Ƿ����Sm��R-m�Ƿ����S-m

    %     disp('�����ͼ��lena.bmp��û�о���LSB�滻��д��');

    % end

    % if dnz - dpo > P   %�����ж�R-m - S-m > Rm - Sm

    %     disp('�����ͼ��lena.bmp����LSB�滻��д��');

    % end

    % get roots of polynomial

    C = [2 * (dpo + dpz), (dnz - dno - dpo - 3 * dpz), (dpz - dnz)];

    a = 2*(dpo + dpz);

    b = dnz - dno - dpo - 3 * dpz;

    c = dpz - dnz;

	delta = b*b-4*a*c;

    if (delta > 0)

        z = roots(C);

        p = z ./ (z - 0.5);

    else 

        delta = -1;

    end

end

fprintf(1, 'Fridrih Algorithm:expective embedding rate is  %f\n',p(2));



function v = SpaceCor(t)

    v = abs(t(2)-t(1)) + abs(t(3)-t(2)) + abs(t(4)-t(3));

end  

function r = fpos(t, m)

% ����ת t ��Ŀ�� m �����ж�Ϊ1 �ľ���

    r = t;

    MM = size(m, 2);% ����ά��

    for q = 1:MM

        if m(q) == 1

           if mod(t(q),2) == 0

               r(q) = r(q) + 1;

           else 

               r(q) = r(q) - 1;

           end

           if r(q) < 0  % ��ֹ���

               r(q) = 255;

           elseif r(q) > 255

               r(q) = 0;

           end

        end

    end

end

function r = fneg(t, m)

% ����ת

    r = t;

    for q = 1:size(m)

        if m(q) == 1

           if mod(t(q),2) == 0

               r(q) = r(q) - 1;

           else 

               r(q) = r(q) + 1;

           end

        end

        if r(q) < 0  

            r(q) = 255;

        elseif r(q) > 255

            r(q) = 0;

        end

    end

end