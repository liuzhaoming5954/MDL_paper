function [ui,s] = Segmentation(ur, dt, eps)
% INPUT
% ur������ο��źŵĲ�������һ��������������d
% d������������
% dt���������
% eps��epsilon�ǷŴ�߽�ֵ����ʹ���߸���
% OUTPUT
% ui: ��һ��n*m�ľ�����n��segment��ÿ��segment��m������
% s: ÿһ��segment�Ĳ�������Ŀ

% ����ur�ĳ���
d=length(ur);

% ����΢��
for k = 1:d-1
    urd(k) = (ur(k+1)-ur(k))/ dt;
end

for k = 1:d-2
    urdd(k) = (urd(k+1)-urd(k))/dt;
end

% ȷ��ÿ��segment����ʼ��
endpoint(1) = 1;
i = 2;
for k = 2:d-2
    if (abs(urdd(k))-eps)*(abs(urdd(k-1))-eps) < 0
        endpoint(i) = k;
        i = i+1;
    end
end
endpoint(i) = d;
%i = i-1;
segmentnumber = i-1;

% ��ȡÿ��segment�Ĳ�������
%segmentsample(1) = endpoint(1);
for n = 1:segmentnumber
        s(n) = endpoint(n+1)-endpoint(n);
end

% ��ȡsegment��������
samplemax = 0;
for k = 1:segmentnumber
    if samplemax < s(k)
        samplemax = s(k);
    end
end

% �������ui
for n = 1:segmentnumber
    for m = 1:samplemax
        if m <= s(n)
            ui(n,m) = ur(endpoint(n)+m-1);
        else
            ui(n,m) = 0;
        end
    end
end

