function MDL_ABB_write()
   clear;
   clc;
   disp('Program started');
   % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
   vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
   vrep.simxFinish(-1); % just in case, close all opened connections
   % clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
   clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
   % 启动vrep的同步模式
   vrep.simxSynchronous(clientID,true);
  
   %read the joint angle data from 'angle.txt'
      % jointValue=load('MDL_angle.txt');   %A matrix of 7 x 150.Each column vector recorded the changes of each joint Angle 
      load('ur_e_angle.mat');
      load('ts_r_time');
      %% 数据预处理
      joint1 = [ts_r{1,1} ur_e{1,1}];
      joint2 = [ts_r{2,1} ur_e{2,1}];
      joint3 = [ts_r{3,1} ur_e{3,1}];
      joint5 = [ts_r{4,1} ur_e{4,1}];
      % 去三位小数，精确到1ms
      joint1 = roundn(joint1, -3);
      joint2 = roundn(joint2, -3);
      joint3 = roundn(joint3, -3);
      joint5 = roundn(joint5, -3);
      % 由于精度只有四位，所以要删除重复的时间
      joint1 = unique(joint1,'rows');
      joint2 = unique(joint2,'rows');
      joint3 = unique(joint3,'rows');
      joint5 = unique(joint5,'rows');
%       joint1(:,1)=joint1(:,1)*1000;
%       joint2(:,1)=joint2(:,1)*1000;
%       joint3(:,1)=joint3(:,1)*1000;
%       joint5(:,1)=joint5(:,1)*1000;
      % 找出时间总长度
      [x , ~]=size(joint1);
      t = joint1(x,1); % t为总时长 
      
      %% 开始仿真
      [m1,~]=size(joint1);
      [m2,~]=size(joint2);
      [m3,~]=size(joint3);
      [m5,~]=size(joint5);
           
   if (clientID>-1)
      disp('Connected to remote API server');
      vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);%这句话是用于启动仿真，相当于你点击vrep的启动仿真按钮
       % get handle for ABB IRB4600_joint
      [res,handle_ABBjoint1] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint1',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint2] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint2',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint3] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint3',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint4] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint4',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint5] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint5',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint6] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint6',vrep.simx_opmode_oneshot_wait); 
    
      i1=1;i2=1;i3=1;i5=1;
      
      %Set the position of every joint
      if(vrep.simxGetConnectionId(clientID) ~= -1)  % if v-rep connection is still active
          for i=0:0.001:t   
              vrep.simxPauseCommunication(clientID,1); 
              if(abs(joint1(i1,1)-i)<0.0000001)
                  vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint1,joint1(i1,2)*3.14/180,vrep.simx_opmode_oneshot);
                  i1=i1+1;
              end
              if(abs(joint2(i2,1)-i)<0.0000001)
                  vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint2,joint2(i2,2)*3.14/180,vrep.simx_opmode_oneshot);
                  i2=i2+1;
              end
              if(abs(joint3(i3,1)-i)<0.0000001)
                  vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint3,joint3(i3,2)*3.14/180,vrep.simx_opmode_oneshot);
                  i3=i3+1;
              end
              if(abs(joint5(i5,1)-i)<0.0000001)
                  vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint5,joint5(i5,2)*3.14/180,vrep.simx_opmode_oneshot);
                  i5=i5+1;
              end
%               vrep.simxPauseCommunication(clientID,1); 
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint1,joint1(i1,2)*3.14/180,vrep.simx_opmode_oneshot);
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint2,joint2(i2,2)*3.14/180,vrep.simx_opmode_oneshot);
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint3,joint3(i3,2)*3.14/180,vrep.simx_opmode_oneshot);
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint5,joint5(i5,2)*3.14/180,vrep.simx_opmode_oneshot);
              vrep.simxPauseCommunication(clientID,0);
              vrep.simxSynchronousTrigger(clientID);
              vrep.simxGetPingTime(clientID);
              disp(i);              
              %pause(0.01);
          end

%         if(vrep.simxGetConnectionId(clientID) ~= -1),  % while v-rep connection is still active
%           for i=1:m
%               vrep.simxPauseCommunication(clientID,1);      
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint1,jointValue(i,1)*3.14/180,vrep.simx_opmode_oneshot); 
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint2,jointValue(i,2)*3.14/180,vrep.simx_opmode_oneshot); 
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint3,jointValue(i,3)*3.14/180,vrep.simx_opmode_oneshot); 
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint4,0,vrep.simx_opmode_oneshot);
%               vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint5,jointValue(i,5)*3.14/180,vrep.simx_opmode_oneshot);
%               %vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint6,0,vrep.simx_opmode_oneshot);
%               vrep.simxPauseCommunication(clientID,0);
%               vrep.simxSynchronousTrigger(clientID);
%               vrep.simxGetPingTime(clientID);
%               disp(i);              
%               % pause(0.1);
%           end
%          % vrep.simxGetConnectionId(clientID);
%         end         
       
     % Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
     vrep.simxGetPingTime(clientID);
     % Now close the connection to V-REP:
     vrep.simxFinish(clientID);
   else
      disp('Failed connecting to remote API server');
   end
   vrep.delete(); % call the destructor!
   
   disp('Program ended');
end
