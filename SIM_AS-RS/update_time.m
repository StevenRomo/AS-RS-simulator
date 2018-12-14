%%%%%
% [newTime] = update_time (petitionType,time,vectorAxis1,vectorAxis2,Rack)
% ===
% Update a time counter of our store. Depends of which petition we
% pass and what's the current time.
% ===
% Input:  
%  petitionType   : Integer [0:2]. Indicate which type of petition is.
%                   Have three options:
%                   0: Null petition. 
%                   1: Single cycle. 
%                   2: Dual cycle.
%       newTime   : Integer. Indicate new current time in seconds before update.
%     vectorAxis1 : Coordenates of storage ubication
%     vectorAxis2 : Coordenates of retrieval ubication
%           Rack  : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%
% Output:  
%       newTime   : Integer. Indicate new current time in seconds after update.
%                   
% Example:     time=10; % current time = 10 seconds
%              petitionType=2 % type = dual cycle
%              vectorAxis1=[1 1 3];
%              vectorAxis2=[11 25 4];
%              [newTime] = update_time (petitionType,time,vectorAxis1,vectorAxis2,Rack)
%%%%%
function [time] = update_time (petitionType,time,vectorAxis1,vectorAxis2,Rack)

% objetiveUbication --> coordenadas de la posición objetivo
    %identify which petition arrive
    if petitionType ~= 0
    %we have any petition
        if petitionType == 1
        %my petition is single cycle
%             newTime = time.current + time.cs;
            t1=Rack(vectorAxis1(1),vectorAxis1(2),vectorAxis1(3)+2);
            time.current = time.current + t1 + 2*time.pd;
            time.vectorTimeCS = [time.vectorTimeCS t1+2*time.pd];
        elseif petitionType == 2
        %my petition is dual cycle
%             newTime =  time.current  + time.cd;
            t1=Rack(vectorAxis1(1),vectorAxis1(2),vectorAxis1(3)+2);
            t2=t1-Rack(vectorAxis2(1),vectorAxis2(2),vectorAxis2(3)+2);
            time.current  = time.current + t1 + t2 + 4*time.pd;
            time.vectorTimeCD = [time.vectorTimeCD t1+t2+4*time.pd];
        else
        %my petition is out of range
            time.current  =  time.current ;
            error('Fatal Error: Petition codification invalid. Only can asume values (0:2).')
        end
    else
    %if we dont have any petition
    randomTime=randi([5 60]);    % random time between 5s and 60s
    time.current  =  time.current  + randomTime;
    end
end

