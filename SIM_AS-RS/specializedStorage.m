%%%%%
% [newRack,zyr_timeVector,enable] = specializedStorage (objetiveSKU,originalRack);
% ===
% Generate a specialized storage for one petition. If you need make more than one
% repeate this function
% ===
% Input:  SKU     : Integer. Identificator of type of product 
%         rack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%
% Output:           z     :  Integer. Indicated z axis
%      newrack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%  zyr_timeVector : Vector of 3 elem. Indicate coordenates of
%                   time Matrix for an update.
%        enable   : Boolean. Indicate if found an free space for storage 
% Example:     rack=zeros(12,60,8);
%              SKU=1;
%              [rack,zyr_timeVector,enable]=randomStorage (SKU,rack);
%
%%%%%
function [newRack,zyr_timeVector,enable] = specializedStorage (objetiveSKU,originalRack)
    
    newRack=originalRack;
    enable = false;
    zyr_timeVector=[1 1 3];
    %declaramos la matriz de zonas
    zonesMatrix = originalRack(:,:,9);
    auxiliarRack = zeros(12,60,2);

    %buscamos todas las posiciones del tipo objetiveSKU
    vectorIndex_SKU = find ( zonesMatrix == objetiveSKU );  
    [~,LongVector] = size ( vectorIndex_SKU' );
    for i=1:LongVector
         auxiliarRack(vectorIndex_SKU(i))=  originalRack(vectorIndex_SKU(i));
         auxiliarRack(720+vectorIndex_SKU(i)) = originalRack(720+vectorIndex_SKU(i)) ;
    end
    % Search if find any storage place free for objetiveSKU
    Empty1= isempty(find(~auxiliarRack(:,:,1)));
    Empty2= isempty(find(~auxiliarRack(:,:,2)));
    if ~Empty1 || ~Empty2
        %Exist any storage place free
        for i=1:LongVector 
            %   Evaluate if we dont found any place yet
            if ~enable
            [i_row,i_col]=ind2sub(size(zonesMatrix),vectorIndex_SKU(i));
                % Evaluate if Rack 1 has a place free for this coordenates
                if originalRack(i_row,i_col,1) == 0 
                    % Store objetve SKU at RACK 1
                    newRack(i_row,i_col,1)=objetiveSKU;
                    % Store coordenates for update time
                    zyr_timeVector=[i_row,i_col,1+2];
                    % Update Enable
                    enable=true;
                    
                % Evaluate if Rack 2 has a place free for this coordenates
                elseif originalRack(i_row,i_col,2) == 0 
                    % Store objetve SKU at RACK 1
                    newRack(i_row,i_col,2)=objetiveSKU;
                    % Store coordenates for update time
                    zyr_timeVector=[i_row,i_col,2+2];
                    % Update Enable
                    enable=true;
                end
            else
                %We found a place for storage so quit of loop.
                break;
            end
        end
    end
end