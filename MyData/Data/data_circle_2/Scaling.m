function [us, sigmas, B, Ts] = Scaling(ui, sigmao, s, dt)
% function [us, bate] = Scaling(ui, s, k, dt)
% INPUT 
% ui: n*m���󣬷ֶ��Ժ�Ŀ��Ʋο��ź�
% sigmao: j*k���󣬳�ʼ�׶ε���ĸ��
% s: һ����������ui����ÿһ��ʵ���еĲ��������
% dt: ����ʱ����
% m: ui��m
% k: sigmao��k
% 
% OUTPUT
% us: n*max(m,k)����
% sigmas: j*max(j,k)����
% bate: 1*n����չ����
% Ts: ����֮��ÿһ��segment��ʱ��T

% ������󳤶�
[n,m]=size(ui);
[j,k]=size(sigmao);

% ���ȼ����m��k�Ľϴ�ֵ,�Լ�һ��segment�µ���ʱ��T
mk = max(m, k);
Ts = dt*(mk-1);

% ����Bs����,���bate����
for i=1:n
    Bs(i) = (mk-1)/(s(i)-1);
    B(i) = (s(i)-1)/(mk-1);
end

% �������us����
for i=1:mk
    x1(i)=dt*(i-1);
end
for i=1:n
    for p=1:s(i)
        x(p)=Bs(i)*dt*(p-1);
    end
    y = ui(i,1:s(i)); 
    if length(x) == 1
        for ii = 1:1:length(x1)
            us(i,ii) = y;
        end
    else
        us(i,:) = interp1(x, y, x1, 'PCHIP');
    end        
    clear x;
    clear y;
end

% �������sigmas����
BBs = (mk-1)/(k-1);
for p=1:mk
    xx1(p)=dt*(p-1);
end
for i=1:j
    for p=1:k
        xx(p)=BBs*dt*(p-1);
    end
    sigmas(i,:) = interp1(xx, sigmao(i,:), xx1, 'PCHIP');
    clear xx;
end

