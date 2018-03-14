function MDL_ABB_write()
   disp('Program started');
   % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
   vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
   vrep.simxFinish(-1); % just in case, close all opened connections
   clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
  
   %read the joint angle data from 'angle.txt'
      jointValue=load('MDL_angle.txt');   %A matrix of 7 x 150.Each column vector recorded the changes of each joint Angle  
      [m n]=size(jointValue);
      
      
   if (clientID>-1)
      disp('Connected to remote API server');
       % get handle for Baxter_rightArm_joint1 
      [res,handle_ABBjoint1] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint1',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint2] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint2',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint3] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint3',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint4] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint4',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint5] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint5',vrep.simx_opmode_oneshot_wait); 
      [res,handle_ABBjoint6] = vrep.simxGetObjectHandle(clientID,'IRB4600_joint6',vrep.simx_opmode_oneshot_wait); 
     
    
      %Set the position of every joint
        while(vrep.simxGetConnectionId(clientID) ~= -1),  % while v-rep connection is still active
          for i=1:m
         vrep.simxPauseCommunication(clientID,1);      
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint1,jointValue(i,1),vrep.simx_opmode_oneshot); 
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint2,jointValue(i,2),vrep.simx_opmode_oneshot); 
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint3,jointValue(i,3),vrep.simx_opmode_oneshot); 
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint4,jointValue(i,4),vrep.simx_opmode_oneshot);
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint5,jointValue(i,5),vrep.simx_opmode_oneshot);
         vrep.simxSetJointTargetPosition(clientID,handle_ABBjoint6,jointValue(i,6),vrep.simx_opmode_oneshot);
        
         disp('One step');
         vrep.simxPauseCommunication(clientID,0);
         pause(0.1);
          end
         vrep.simxGetConnectionId(clientID)=1;
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
