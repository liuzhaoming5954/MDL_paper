% װ������
clear;
clc;
%load('Rb_sqtraj1.mat');
load('data_circle.mat');

for number = 1:8
PVT_1 = strcat('PVT',int2str(number),'.j1p');
PVT_2 = strcat('PVT',int2str(number),'.j2p');
PVT_3 = strcat('PVT',int2str(number),'.j3p');
PVT_4 = strcat('PVT',int2str(number),'.j5p');
PVT_time = strcat('PVT',int2str(number),'.time');

ur = [eval(PVT_1),eval(PVT_2),eval(PVT_3),eval(PVT_4)];

% ����ur��dt��
%ur = sqtraj1;
%ur = [PVT6.j1p,PVT6.j2p,PVT6.j3p,PVT6.j5p];
%ur = [PVT.j1p,PVT.j2p,PVT.j3p,PVT.j5p];

% ��ʼ������
sigmao = cell(4,1);
sigmas = cell(4,1);
A = cell(4,1);
B = cell(4,1);
G = cell(4,1);
ur_e = cell(4,1);
ts_r = cell(4,1);

for qi=1:4
    dt = 0.025; 
    % dt = 0.01; 
    % ��ȡ��ʼ��ĸ��sigmao
    [sigmao{qi,1}, str_line] = InitSigmao(ur(:,qi),dt);

    % ��������ʱ��
    t = eval(PVT_time);
    % ���÷ֶ��������
    eps = 0.0001;
    %eps1 = 0.0005;
    % �����ع��������
    eps1 = 0.01;
    % �ֶ������ź�
    [ui, s] = Segmentation(ur(:,qi), dt, eps);
    % �������źŽ�������
    [us, sigmas{qi,1}, B{qi,1}, Ts] = Scaling(ui, sigmao{qi,1}, s, dt);

    [j, mk] = size(sigmas{qi,1});
    [n, mk] = size(us);

    % ���������Ƿ�Ϊֱ�߷���������������ؽ�
    if str_line == 1
        %�����ֱ�߾�ֱ�����
        u_re = sigmas{qi,1};
        % �ع�ʱ�����ts=Ts*bate
        for p=1:n
            for i=1:mk
                tn(i)=B{qi,1}(p)*Ts*(i-1)/(mk-1);
            end
            if p == 1
                ts = tn;
            else
                ts=[ts,tn+ts(mk*(p-1))+dt];
            end
        end
     else
        % ����ֱ�����������һ���ع�
        % �������G,j*j
        for i=1:j
            for p=1:j
                G{qi,1}(i,p) = InnerProducts(sigmas{qi,1}(i,:), sigmas{qi,1}(p,:), dt);
            end
        end

        % ��������v
        %A = [];
        i=1;
        v=[];
        while (i<n+1)
            for p=1:j
                v(p,1) = InnerProducts(us(i,:), sigmas{qi,1}(p,:), dt); 
            end
            alpha = G{qi,1}\v;
            if (abs(InnerProducts(us(i,:), us(i,:), dt)-alpha'*G{qi,1}*alpha) < eps1)
                A{qi,1} = [A{qi,1};alpha']; % A��ÿһ����һ��segment��Ӧ�Ĳ�����ʾ
                i = i+1;
            else
                for p=1:mk
                    uiv(p) = us(i,p) - alpha'* sigmas{qi,1}(:,p);
                end
                sigmas{qi,1} = [sigmas{qi,1};uiv];
                % ���¼������G,j+1*j+1
                j = j+1;
                for i=1:j
                    for p=1:j
                        G{qi,1}(i,p) = InnerProducts(sigmas{qi,1}(i,:), sigmas{qi,1}(p,:), dt);
                    end
                end
                i = 1;
                clear A{qi,1};
                A{qi,1} = [];
            end
            clear uiv;
        end

%% �ع��ο������ź�
        [j, mk]=size(sigmas{qi,1});
        [n, j]=size(A{qi,1});
        % �ع�ur
        u_re = [];

        for p=1:n
            x = zeros(1,mk);
            for i=1:j   
                x = x + sigmas{qi,1}(i,:)*A{qi,1}(p,i);
                % u_re(p,:) = x;
            end
            u_re = [u_re,x];
        end
        %ur_e{qi,1} = u_re';
        % u_re = [q(1),u_re];
        % �ع�ʱ�����ts=Ts*bate
        for p=1:n
            for i=1:mk
                tn(i)=B{qi,1}(p)*Ts*(i-1)/(mk-1);
            end
            if p == 1
                ts = tn;
            else
                ts=[ts,tn+ts(mk*(p-1))+dt];
            end
        end
        %ts_r{qi,1} = ts';
        %ts = [0,ts];
    end
    ur_e{qi,1} = u_re';
    ts_r{qi,1} = ts';
end

% ��ʾ�ع��ź�
% for qi=1:4   
%     subplot(2,3,qi);
%     plot(ts_r{qi,1},ur_e{qi,1},'blue');
%     %set(1,'yticklabel',sprintf('%03.4f|',get(gca,'ytick')));
%     hold;
%     % ��ʾ�����ź�
%     plot(t,ur(:,qi),'red');
%     grid on;
%     str = ['joint ',num2str(qi)];
%     title(str);
%     xlabel('time(s)');% x������
%     ylabel('angle(rad)'); 
% end

% saveas(1,'fig1.fig');

%% ����atom��ͼ��
for i=1:4
    [m,n]=size(sigmas{i,1});
    if m>7
        figure;
        plot(t,sigmas{i,1}(8:m,:));
    end
end

clear sigmao;
clear sigmas;
end
