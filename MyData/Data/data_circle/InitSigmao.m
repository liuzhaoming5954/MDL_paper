function [sigmao, str_line] = InitSigmao(ur, dt)
% INPUT 
% �ο������źţ�ur
% ����ʱ������dtͬ�ο�����ur
% OUTPUT
% �����ʼ����sigmao����
% ֱ�߱�־��str_line 1��ʾ�ο��ź�Ϊֱ�ߣ�0��ʾ�ο��źŲ���ֱ��
% �������ʹ�ù����䣺CFtool

% ��ʼ����ز���
L = length(ur);
ti = 0;
tf = ti+dt*(L-1);
% v0 = 0;
% v1 = 0;
q0 = ur(1);
q1 = ur(L);
%h = q1-q0;
T = tf-ti;

% ��������ʱ��
t1 = [0:dt:tf]';
i = 1; % ȷ��Sigmao�ĸ���
% �������������

% ����ֱ�߻�����
% [a_l0, a_l1] = linefuntion(q0,q1,ti,tf);
% Line trajectory function ֱ��
% sigmao(i,:) = a_l0+a_l1*t1;
P1=fit(t1,ur,'poly1','Normalize','on');
sigmao(i,:) = P1(t1);
% Calculate Frechet-distance between two function
% TODO:���ڰ������ж�ֱ�ߵ����ȥ������ֱ����Ҳ�ܽ��
frechet_value = frechet(t1,ur,t1,sigmao(i,:)');
if(frechet_value<=0.01)
    str_line = 1; %ֱ�߱�־λ����һ��ֱ��
    fprintf('%s\n','�켣��һ��ֱ��');
else
    i = i+1;
    
    % a_pa = polyfit(ur,t1,2);
    % Parabola ��������
    % sigmao(i,:) = a_pa(1)+a_pa(2)*t1+a_pa(3)*t1.^2;
    P2=fit(t1,ur,'poly2','Normalize','on');
    sigmao(i,:) = P2(t1);
    i = i+1;
    
    % a_c = polyfit(ur,t1,3);
    % Cubic trajectory function ��������
    % sigmao(i,:) = a_c(1)+a_c(2)*t1+a_c(3)*t1.^2+a_c(4)*t1.^3;
    P3=fit(t1,ur,'poly3','Normalize','on');
    sigmao(i,:) = P3(t1);
    i = i+1;
    
    % a_f = polyfit(ur,t1,4);
    % �Ĵ�����
    % sigmao(i,:) = a_f(1)+a_f(2)*t1+a_f(3)*t1.^2+a_f(4)*t1.^3+a_f(5)*t1.^4;
%     P4=fit(t1,ur,'poly4');
%     sigmao(i,:) = P4(t1);
%     i = i+1;
    
    % a_p = polyfit(ur,t1,5);
    % Polynomial_5 trajectory function �������
    % sigmao(i,:) = a_p(1)+a_p(2)*t1+a_p(3)*t1.^2+a_p(4)*t1.^3+a_p(5)*t1.^4+a_p(6)*t1.^5;
    P5=fit(t1,ur,'poly5','Normalize','on');
    sigmao(i,:) = P5(t1);
    i = i+1;
    
    % ���������������
    sin2=fit(t1,ur,'sin2','Normalize','on');
    sigmao(i,:) = sin2(t1);
    i = i+1;
    
    % ����Ҷ�������
    fourier2=fit(t1,ur,'fourier2','Normalize','on');
    sigmao(i,:) = fourier2(t1);
    
%     P6=fit(t1,ur,'poly6');
%     sigmao(i,:) = P6(t1);
    
    
    str_line = 0;% ֱ�߱�־λ������ֱ��
end
