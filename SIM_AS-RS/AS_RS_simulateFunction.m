%%%%%
% [counter,AS_RS2] = AS_RS_simulateFunction ( ocupationGrade, mode, temporaryLimit )
% ===
% Simulate in a temporary limit a store. For evaluate the flow work when have 
% new petitions and an ocupation grade for initialize this store
% ===
% Input:  
%  ocupationGrade : Integer. Indicates which will be the initial ocupation
%                   grade of the store.
%          mode   : Char. Indicates the option of petition's distribution. 
%                   Have three options:
%                   'A': percentage Storage 50% -- percentage Retrieval 95%.
%                   'B': percentage Storage 50% -- percentage Retrieval 50%.
%                   'C': percentage Storage 95% -- percentage Retrieval 50%.
%  temporaryLimit : Integer. Indicate in seconds how long you want this
%                   simulation. An Hour, A day, A week,...
%  mode_ofStorage : Integer. Indicates the option of Storage's strategy. 
%                   Have two options:
%                   1: Random Storage.
%                   2: Specialized Storage.
%
% Output: 
%    Counter      : An Structure for all counters we need
%     AS_RS2      : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
% Example:     mode='C';
%              temporaryLimit=3600; % 1 hour
%              ocupationGrade = 25; % 25% of ocupation max. 
%              [counter,Rack] = AS_RS_simulateFunction ( ocupationGrade, mode, temporaryLimit);
%
%%%%%

function [counter,AS_RS2] = AS_RS_simulateFunction ( ocupationGrade, mode, temporaryLimit, mode_ofStorage)

    AS_RS=zeros(12,60,9);
    %AS-RS Declaration option 2
    Rack.Stock1=AS_RS(:,:,1);
    Rack.Stock2=AS_RS(:,:,2);

    Rack.Time1=AS_RS(:,:,3);
    Rack.Time2=AS_RS(:,:,4);

    % Asume position (0,0) = AS_RS(12,1) 
    Rack.Dist_to_origin1=AS_RS(:,:,5);
    Rack.Dist_to_origin2=AS_RS(:,:,6);

    Rack.Time_to_ubication1=AS_RS(:,:,7);
    Rack.Time_to_ubication2=AS_RS(:,:,8);

    ny=60;
    nz=12;
    C=2*ny*nz;  %Capacity : 1440 Units

    dimension.x=1;
    dimension.y=1;
    dimension.z=1;
    dimension.a=0.15;
    dimension.b=0.20;
    dimension.c=0.25;
    dimension.W=3*(dimension.x+dimension.a);         % W
    dimension.L=ny*(dimension.y+dimension.b);       % L
    dimension.H=nz*(dimension.z+dimension.c);      % H

    counter.vectorSKU= [0 0 0 0]; %[SKU1 SKU2 SKU3 SKU4]
    counter.petitionsNotNull=0;
    counter.retrievalPetition = 0;
    counter.storagePetition = 0;
    counter.singleCyclePetition = 0;
    counter.dualCyclePetition = 0;
    counter.nullPetition = 0;
    counter.lackOfMaterial = 0;
    counter.lackOfSpace= 0;
    counter.OcupationLastHour = int64.empty(0);
    counter.timeCS=[];
    counter.timeCD=[];
    counter.meanTimeCS=0;
    counter.meanTimeCD=0;
    counter.timeCS_STD=[];
    counter.timeCD_STD=[];

    velocity.vy=2; %m/s
    velocity.vz=1; %m/s

    time.pd=15;
    time.cs= max((dimension.L)/(velocity.vy),(dimension.H)/(velocity.vz))+2*time.pd; %s 
    time.cd= max((1.5*dimension.L)/(velocity.vy),(1.5*dimension.H)/(velocity.vz))+4*time.pd; %s 
    time.current=0;
    time.vectorTimeCS=[];
    time.vectorTimeCD=[];

    %distance in axis y long
    space_per_unit.y =  dimension.L / ny ;             % 1.2 m per unit
    distance_to_center.y = space_per_unit.y / 2;    % 0.6 m to center
    % distance in axis z height
    space_per_unit.z =  dimension.H / nz ;              % 1.25 m per unit
    distance_to_center.z = space_per_unit.z / 2;    % 0.625 m to center
    
    %z--> heught H=12     y--> long L =60
    for i=12:-1:1
        for j=1:60
            AS_RS(i,j,5) = (j-1)*(space_per_unit.y)+(distance_to_center.y)+(12-i)*(space_per_unit.z);
            AS_RS(i,j,6) = (j-1)*(space_per_unit.y)+(distance_to_center.y)+(12-i)*(space_per_unit.z);
            AS_RS(i,j,7) = max(((j-1)*(space_per_unit.y)+(distance_to_center.y))/(velocity.vy),((12-i)*(space_per_unit.z))/(velocity.vz));
            AS_RS(i,j,8) = max(((j-1)*(space_per_unit.y)+(distance_to_center.y))/(velocity.vy),((12-i)*(space_per_unit.z))/(velocity.vz));
        end
    end
    
    if mode_ofStorage==2
        [AS_RS(:,:,9)] = generateSKUZones (AS_RS,C);
    end
    petition.varStorageDone = false;
    petition.varRetrievalDone = false;


    distance=0;
    updateIndicator=true;

    ocupation=round(C*(ocupationGrade)/100);
    
     %inicializamos el almacen con la ocupación especificada
    if mode_ofStorage==1
        [AS_RS2, vectorSKU] = initializeStore (ocupation, AS_RS, mode_ofStorage);
    elseif mode_ofStorage==2
        [AS_RS2, vectorSKU] = initializeStore (ocupation, AS_RS, mode_ofStorage);
    else 
        mode_ofStorage =1;
        [AS_RS2, vectorSKU] = initializeStore (ocupation, AS_RS, mode_ofStorage);
    end
    counter.vectorSKU=vectorSKU;
    counter.currentOcupation = ocupation;
    lastHour=0;

    %simulamos hatsa el limite temporal de 1 hora
    while time.current < temporaryLimit

        %Generamos pedidos con la distribución tipo 'A'
        [petition.type, petition.retrievalSKU, petition.storageSKU]= generate_petitions (mode);
        
        switch petition.type
            case 0  %Null petition
                [time] = update_time (0,time,[000],[000],AS_RS2);
                counter.nullPetition = counter.nullPetition+1;
            case 1  %Retrieval petition in single Cycle
                counter.petitionsNotNull = counter.petitionsNotNull + 1;
                % if Rack is empty - dont search
                if counter.currentOcupation ~= 0
                [foundSKU_indicator, vectorAxis] = searchMin (AS_RS2,petition.retrievalSKU);
                    %if we found an SKU to retrieval
                    if foundSKU_indicator
                        % Delete item at stock matrix  
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)-2) = 0; 
                        % Reset time ar time matrix
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)) = inf;
                        
                        [time] = update_time (1,time,vectorAxis,[0 0 0],AS_RS2);
                        [counter] = updateSKU(petition, counter);
                        
                        counter.singleCyclePetition = counter.singleCyclePetition+1;
                        counter.retrievalPetition = counter.retrievalPetition+1;

                    else
                        % Dont have any item of this SKU
                        [time] = update_time (0,time,[000],[000],AS_RS2);
                        counter.lackOfMaterial = counter.lackOfMaterial + 1;
                    end
                end

            case 2  %storage petition 
                counter.petitionsNotNull = counter.petitionsNotNull + 1;
                % Try to storage
                if mode_ofStorage==1
                    [AS_RS2,zyr_timeVector,varEnable]= randomStorage (petition.storageSKU,AS_RS2);
                elseif mode_ofStorage==2
                    [AS_RS2,zyr_timeVector,varEnable]= specializedStorage (petition.storageSKU,AS_RS2);
                else 
                    mode_ofStorage =1;
                    [AS_RS2,zyr_timeVector,varEnable]= randomStorage (petition.storageSKU,AS_RS2);
                end
                
                % if we found an free space for this item
                if varEnable
                    [time] = update_time (1,time,zyr_timeVector,[0 0 0],AS_RS2);
                    AS_RS2 (zyr_timeVector(1),zyr_timeVector(2),zyr_timeVector(3)) = time.current;

                    % update Counters
                    [counter] = updateSKU(petition, counter);
                    counter.storagePetition = counter.storagePetition+1;
                    counter.singleCyclePetition = counter.singleCyclePetition+1;

                else
                    % Rack is complete
                    [time] = update_time (0,time,[000],[000],AS_RS2); 
                    counter.lackOfSpace = counter.lackOfSpace + 1;
                end

            case 3  %dual petition
                counter.petitionsNotNull = counter.petitionsNotNull + 1;
                %Try to storage
                if mode_ofStorage==1
                    [AS_RS2,zyr_timeVector, petition.varStorageDone]= randomStorage (petition.storageSKU,AS_RS2);
                elseif mode_ofStorage==2
                    [AS_RS2,zyr_timeVector, petition.varStorageDone]= specializedStorage (petition.storageSKU,AS_RS2);
                else 
                    mode_ofStorage =1;
                    [AS_RS2,zyr_timeVector, petition.varStorageDone]= randomStorage (petition.storageSKU,AS_RS2);
                end
                %Found an free space
                if petition.varStorageDone
                    %update Time Matrix if storage is done
                    AS_RS2 (zyr_timeVector(1),zyr_timeVector(2),zyr_timeVector(3)) = time.current;
                    % Search SKU item for retrieval
                    % Search SKU with minimun time 
                    [foundSKU_indicator, vectorAxis] = searchMin (AS_RS2,petition.retrievalSKU);
                    varRetrievalDone=foundSKU_indicator;
                   if varRetrievalDone
                   %Storage Done - Retrieval Done
                        
                       %Update time for dual cycle
                        [time] = update_time (2,time,zyr_timeVector,vectorAxis,AS_RS2);
                        % Delete on Stock Matrix    
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)-2) = 0; 
                        % Reset time on Time Matrix
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)) = inf;
                        %           counters
                        counter.storagePetition = counter.storagePetition + 1;
                        counter.retrievalPetition = counter.retrievalPetition + 1;
                        counter.dualCyclePetition = counter.dualCyclePetition + 1;
                        counter.petitionsNotNull = counter.petitionsNotNull + 1;
                   
                   else
                   %Storage Done - Retrieval Not
                        % new time for storage petition
                        [time] = update_time (1,time,zyr_timeVector,[0 0 0],AS_RS2);
                        %           Storage Counters
                        counter.storagePetition = counter.storagePetition + 1;
                        counter.singleCyclePetition = counter.singleCyclePetition + 1;
                        % new time post null retireval petition
                        [time] = update_time (0,time,[000],[000],AS_RS2);    

                        %               Null Retrieval counter
                        counter.lackOfMaterial = counter.lackOfMaterial + 1;

                   end  
                else   
                   %Storage Not 
                   %               Null Storage counter
                   counter.lackOfSpace = counter.lackOfSpace + 1;
                   % Search for retrieval item
                   [foundSKU_indicator, vectorAxis] = searchMin (AS_RS2,petition.retrievalSKU);
                   petition.varRetrievalDone=foundSKU_indicator; 
                   if petition.varRetrievalDone
                   %Storage NOT - Retrieval Done
                        % New time post null sotrage petition
                        [time] = update_time (0,time,[000],[000],AS_RS2); 
                        % New time post retrieval petition
                        [time] = update_time (1,time,vectorAxis,[0 0 0],AS_RS2);
                        
                        % Delete SKU on Stock Matrix    
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)-2) = 0; 
                        % Reset time on Time Matrix
                        AS_RS2(vectorAxis(1),vectorAxis(2),vectorAxis(3)) = inf;
                    
                        %               Retrieval counter
                        counter.retrievalPetition = counter.retrievalPetition + 1;
                        counter.singleCyclePetition = counter.singleCyclePetition + 1;
                   else
                   %Storage NOT - Retrieval NOT
                   %Any petition could be done
                        
                    [time] = update_time (0,time,[000],[000],AS_RS2);
                    [time] = update_time (0,time,[000],[000],AS_RS2);
                    
                    counter.lackOfSpace = counter.lackOfSpace + 1;
                    counter.lackOfMaterial = counter.lackOfMaterial + 1;
                   end  
                end
                [counter] = updateSKU(petition, counter);
            otherwise %out of range

        end

        % Update current ocupation post petition
        [indexK1,~] = size(find(~AS_RS2(:,:,1)));
        [indexK2,~] = size(find(~AS_RS2(:,:,2)));
        
        counter.currentOcupation = C - indexK1 - indexK2;

        % Update vector of ocupation in current hour
        [~,index] = size(counter.OcupationLastHour);
        counter.OcupationLastHour(index+1) = counter.currentOcupation;
        % Estimate current hour
        residuo=mod(time.current,3600);
        var1=time.current-residuo;
        currentHour=var1/3600;
        % If we change of hour could estime average Ocupation
        if currentHour ~= lastHour
            updateIndicator = false;
            %Estimate average ocupation for current hour  
            counter.averageOcupation = round(sum(counter.OcupationLastHour)/(index+1)); 
            counter.OcupationLastHour = int64.empty(0);
        end

        if ~updateIndicator
            %store this average in a vector for all simulation 
            updateIndicator = true;
            counter.vectorOcupation (currentHour) = counter.averageOcupation; 
        end
        lastHour=currentHour;
    end
    
    %   Estimate Standard deviation of Time for Single Cycle
    [~,longTimeVector] = size(time.vectorTimeCS);
    for i=1:longTimeVector
        counter.timeCS(i) = (time.vectorTimeCS (i));
    end
    counter.meanTimeCS = mean(counter.timeCS);
    counter.timeCS_STD = std(counter.timeCS);
    
    %   Estimate Standard deviation of Time for Dual Cycle 
    [~,longTimeVector] = size(time.vectorTimeCD);
    for i=1:longTimeVector
        counter.timeCD(i) = (time.vectorTimeCD (i));
    end
    counter.meanTimeCD = mean(counter.timeCD);
    counter.timeCD_STD = std(counter.timeCD);
    
    %   Estimate Ocupation Increment each hour
    counter.difOcupation(1) = counter.vectorOcupation(1);

    for i=2:currentHour
    counter.difOcupation (i) = abs(counter.vectorOcupation (i) - counter.vectorOcupation (i-1));
    end

%     figure('Name','Promedio de Ocupación Por Hora');
%     plot(counter.vectorOcupation);
%     hold on
%     plot(counter.difOcupation);


    %   Data Analysis
    counter.percetageSKU = [round(100*(counter.vectorSKU(1)/sum(counter.vectorSKU)))  round(100*(counter.vectorSKU(2)/sum(counter.vectorSKU)))  round(100*(counter.vectorSKU(3)/sum(counter.vectorSKU)))  round(100*(counter.vectorSKU(4)/sum(counter.vectorSKU))) ];
    counter.percetageTypePetition = [ 100*(counter.retrievalPetition/counter.petitionsNotNull) 100*(counter.storagePetition/counter.petitionsNotNull)];
    counter.percetageCS = [round(100*(counter.singleCyclePetition/counter.petitionsNotNull))];
    counter.percetageCD = [round(100*(counter.dualCyclePetition/counter.petitionsNotNull))];
    counter.percetageNullPetition = [round(100*(counter.nullPetition/counter.petitionsNotNull))];
    counter.percetageLackOfMaterial= [round(100*(counter.lackOfMaterial/counter.petitionsNotNull))];
    counter.percetageLackOfSpace= [round(100*(counter.lackOfSpace/counter.petitionsNotNull))];
    
end