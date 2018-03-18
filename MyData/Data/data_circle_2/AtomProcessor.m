% װ������
clear;
clc;

load('data_circle.mat');

ur = [PVT5.j1p,PVT5.j2p,PVT5.j3p,PVT5.j5p];

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
    % ��ȡ��ʼ��ĸ��sigmao
    [sigmao{qi,1}, str_line] = InitSigmao(ur(:,qi),dt);
    sigmas{qi,1} = sigmao{qi,1};
    % us = ur';
    % ��������ʱ��
    t = PVT5.time;
    % ���÷ֶ��������
    eps = 0.0001;
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
        ts = t;
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
    else % ����ֱ�����������һ���ع�
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
        
        % ���ȷֶβο��źŹ켣��segment
        %[ui, s] = Segmentation(ur(:,qi), dt, eps);
        % �ع�ÿһ��ui    
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
        
        for p=1:n
            for i=1:mk
                tn(i)=B{qi,1}(p)*Ts*(i-1)/(mk-1);
            end
            if p == 1
                ts = tn;
            else
                ts = [ts,tn+ts(mk*(p-1))+dt];
            end
        end
    end
    ur_e{qi,1} = u_re'; % ����ʱ������
    ts_r{qi,1} = ts'; % �������йؽڽ�
end

%% ��ʾ�ع��ź�
for qi=1:1:4
    subplot(2,2,qi);
    plot(ts_r{qi,1},ur_e{qi,1});
    %set(1,'yticklabel',sprintf('%03.4f|',get(gca,'ytick')));
    hold;
    % ��ʾ�����ź�
    plot(t,ur(:,qi));
    grid on;
    str = ['joint ',num2str(qi)];
    title(str);
    xlabel('time(s)');% x������
    ylabel('angle(rad)'); 
end