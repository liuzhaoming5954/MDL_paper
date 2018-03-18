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
      
      %%
      [m n]=size(jointValue);
      
      
   if (clientID>-1)
      disp('Connected to remote API server');
      vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);%这句话是用于启动仿真，相当于你点击vrep的启动仿真按钮
       % get handle for Baxter_rightArm_joint1 
      [res,handle_ABBjoint1] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint1',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint2] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint2',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint3] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint3',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint4] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint4',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint5] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint5',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint6] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint6',vrep.simx_opmode_oneshot_wait); 
    
      %Set the position of every joint
        if(vrep.simxGetConnectionId(clientID) ~= -1),  % while v-rep connection is still active
          for i=1:m
              vrep.simxPauseCommunication(clientID,1);      
              vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint1,jointValue(i,1)*3.14/180,vrep.simx_opmode_oneshot); 
              vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint2,jointValue(i,2)*3.14/180,vrep.simx_opmode_oneshot); 
              vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint3,jointValue(i,3)*3.14/180,vrep.simx_opmode_oneshot); 
              vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint4,0,vrep.simx_opmode_oneshot);
              vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint5,jointValue(i,5)*3.14/180,vrep.simx_opmode_oneshot);
              %vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint6,0,vrep.simx_opmode_oneshot);
              vrep.simxPauseCommunication(clientID,0);
              vrep.simxSynchronousTrigger(clientID);
              vrep.simxGetPingTime(clientID);
              disp(i);              
              % pause(0.1);
          end
         % vrep.simxGetConnectionId(clientID);
        end         
       
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
