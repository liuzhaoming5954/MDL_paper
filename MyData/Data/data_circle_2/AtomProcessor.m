% 装载数据
clear;
clc;

load('data_circle.mat');

ur = [PVT1.j1p,PVT1.j2p,PVT1.j3p,PVT1.j5p];

% 初始化数组
sigmao = cell(4,1);
sigmas = cell(4,1);
A = cell(4,1);
B = cell(4,1);
G = cell(4,1);
ur_e = cell(4,1);
ts_r = cell(4,1);

for qi=1:4
    dt = 0.025; 
    % 获取初始字母表sigmao
    [sigmao{qi,1}, str_line] = InitSigmao(ur(:,qi),dt);
    sigmas{qi,1} = sigmao{qi,1};
    us = ur';
    % 设置运行时间
    t = PVT1.time;
    % 设置分段允许误差
    eps = 0.0001;
    % 设置重构允许误差
    eps1 = 0.01;

    [j, mk] = size(sigmas{qi,1});
    [n, mk] = size(us);
    % 根据输入是否为直线分两种情况构建和重建
    if str_line == 1
        %如果是直线就直接输出
        u_re = sigmas{qi,1};
        % 重构时间变量ts=Ts*bate
        ts = t;
%         for p=1:n
%             for i=1:mk
%                 tn(i)=B{qi,1}(p)*Ts*(i-1)/(mk-1);
%             end
%             if p == 1
%                 ts = tn;
%             else
%                 ts=[ts,tn+ts(mk*(p-1))+dt];
%             end
%         end
    else % 不是直线则有下面的一堆重构
        % 计算矩阵G,j*j
        for i=1:j
            for p=1:j
                G{qi,1}(i,p) = InnerProducts(sigmas{qi,1}(i,:), sigmas{qi,1}(p,:), dt);
            end
        end
        % 计算向量v
        %A = [];
        i=1;
        v=[];
        while (i<n+1)
            for p=1:j
                v(p,1) = InnerProducts(us(i,:), sigmas{qi,1}(p,:), dt); 
            end
            alpha = G{qi,1}\v;
            if (abs(InnerProducts(us(i,:), us(i,:), dt)-alpha'*G{qi,1}*alpha) < eps1)
                A{qi,1} = [A{qi,1};alpha']; % A的每一行是一个segment对应的参数表示
                i = i+1;
            else
                for p=1:mk
                    uiv(p) = us(i,p) - alpha'* sigmas{qi,1}(:,p);
                end
                sigmas{qi,1} = [sigmas{qi,1};uiv];
                % 重新计算矩阵G,j+1*j+1
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
        %% 重构参考输入信号
        
%         % 首先分段参考信号轨迹：segment
%         [ui, s] = Segmentation(ur(:,qi), dt, eps);
%         % 重构每一段ui
%     
%         [j, mk]=size(sigmas{qi,1});
%         [n, j]=size(A{qi,1});
%         % 重构ur
%         u_re = [];
% 
%         for p=1:n
%             x = zeros(1,mk);
%             for i=1:j   
%                 x = x + sigmas{qi,1}(i,:)*A{qi,1}(p,i);
%                 % u_re(p,:) = x;
%             end
%             u_re = [u_re,x];
%         end
%         for p=1:n
%             for i=1:mk
%                 tn(i)=B{qi,1}(p)*Ts*(i-1)/(mk-1);
%             end
%             if p == 1
%                 ts = tn;
%             else
%                 ts=[ts,tn+ts(mk*(p-1))+dt];
%             end
%         end

    end
end