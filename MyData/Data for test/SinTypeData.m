% ����һ���������ҵ����ݣ����ڲ���matlab���������
clear;
clc;

x = 0:0.01:6.28;
y = 5*sin(2*x+5);
subplot(3,3,1);
% title('ԭʼ����');
plot(x,y);

% �Զ���������ߺ������������ø������߽�����ϣ����Ƴ�ͼ��
% ֱ�����
func=@(a,x) a(1)+a(2)*x;
a = [0 0];
para = lsqcurvefit(func,a,x,y);
y1 = para(1) + para(2)*x;
subplot(3,3,2);
plot(x,y1);

% ��������
func=@(a,x) a(1) + a(2)*x + a(3)*x.^2;
a = [0 0 0];
para = lsqcurvefit(func,a,x,y);
y2 = para(1) + para(2)*x + para(3)*x.^2;
subplot(3,3,3);
plot(x,y2);

% ��������
func=@(a,x) a(1) + a(2)*x + a(3)*x.^2 + a(4)*x.^3;
a = [0 0 0 0];
para = lsqcurvefit(func,a,x,y);
y3 = para(1) + para(2)*x + para(3)*x.^2 + para(4)*x.^3;
subplot(3,3,4);
plot(x,y3);

% �Ĵ�����
func=@(a,x) a(1) + a(2)*x + a(3)*x.^2 + a(4)*x.^3 + a(5)*x.^4;
a = [0 0 0 0 0];
para = lsqcurvefit(func,a,x,y);
y4 = para(1) + para(2)*x + para(3)*x.^2 + para(4)*x.^3 + para(5)*x.^4;
subplot(3,3,5);
plot(x,y4);

% �������
func=@(a,x) a(1) + a(2)*x + a(3)*x.^2 + a(4)*x.^3 + a(5)*x.^4 +a(6)*x.^5;
a = [0 0 0 0 0 0];
para = lsqcurvefit(func,a,x,y);
y5 = para(1) + para(2)*x + para(3)*x.^2 + para(4)*x.^3 + para(5)*x.^4 + para(6)*x.^5;
subplot(3,3,6);
plot(x,y5);

% sin����
func=@(a,x) a(1) + a(2)*sin(x);
a = [0 0];
para = lsqcurvefit(func,a,x,y);
ysin = para(1) + para(2)*sin(x);
subplot(3,3,7);
plot(x,ysin);

% sin����2��Ƶ��
func=@(a,x) a(1) + a(2)*sin(2*x+a(3));
a = [0 0 0];
para = lsqcurvefit(func,a,x,y);
ysin2 = para(1) + para(2)*sin(2*x+para(3));
subplot(3,3,8);
plot(x,ysin2);

% Harmonic����
func=@(a,x) a(1)*(1-cos(pi*(x/(x(629)-x(1)))));
%yHarmonic = 0.5*(1-cos(pi*(x/(x(629)-x(1)))));
a = [0];
para = lsqcurvefit(func,a,x,y);
yHarmonic = para(1)*(1-cos(pi*(x/(x(629)-x(1)))));
subplot(3,3,9);
plot(x,yHarmonic);

