%%%%%
% [zoneMatrix] = generateSKUZones (rack,capacity)
% ===
% Generate a SKU Zones Matrix in ordrer to dedicate the closer places for
% the priority SKU types
% ===
% Input:  
%           rack  : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%       capacity  : Integer. Indicate how many capacity we have
% Output: 
%      zoneMatrix : Matrix. 12X60 for zones in ordrer to follow SKU
%                   priority SKU3>SKU2>SKU4>SKU1
%                   
%                   
% Example:     
%              [zoneMatrix] = generateSKUZones (rack,capacity);
%%%%%
function [zoneMatrix] = generateSKUZones (rack,capacity)
    capacity_byRack=capacity/2;
    zoneMatrix=zeros(12,60);
    timeMatrix=rack(:,:,7);
    
    quantityOfSKU = [0.10*capacity_byRack 0.25*capacity_byRack 0.50*capacity_byRack 0.15*capacity_byRack];
    prioritySKU = sort(quantityOfSKU,'descend');
    priorityTypeSKU = [3 2 4 1];
    [~,Long]=size(prioritySKU);
    
    for i=1:Long
       cuantity=1;
       while cuantity <= prioritySKU(i)
           %seach min time to origin
           [~,index] = min (timeMatrix(:));   
           [I_row, I_col] = ind2sub(size(timeMatrix),index);
           %Reset time in Time Matrix
           timeMatrix(I_row,I_col) = inf;
           %Store type of SKU in zoneMatrix
           zoneMatrix(I_row,I_col) = priorityTypeSKU(i);
           cuantity=cuantity+1;
       end  
    end
    
end