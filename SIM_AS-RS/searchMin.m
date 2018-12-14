%%%%%
% [foundSKU_indicator, vectorAxis] = searchMin (originalRack,objetiveSKU)
% ===
% This function search which item of a determinate SKU type have got the
% minimum time in time matrix. Minimum time is the first in storage.
% ===
% Input:  
%   originalRack  : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%    objetiveSKU  : Integer. Indicate which type of SKU you want search
%
% Output: 
% foundSKU_indicator : Boolean. Indicate if we found an item of this SKU or
%                      not.
%   vectorAxis    : Vector of 3 elements. Indicate the coordenates of item
%                   found
% Example:     originalRack=zeros(12,60,8);
%              objetiveSKU = 1; %want search for an item of SKU type 1 with
%                               %minimum time in time matrix
%              [foundSKU_indicator, vectorAxis] = searchMin (originalRack,objetiveSKU)
%
%%%%%
function [foundSKU_indicator, vectorAxis] = searchMin (originalRack,objetiveSKU)
    % Search for any iitem of objetiveSKU
    vectorIndex_SKU = find ( originalRack(:,:,1:2) == objetiveSKU );
    auxiliarRack = inf ( 12,60,4 );   
    % if we found any item of this SKU
     if ~isempty(vectorIndex_SKU)
            foundSKU_indicator=true;
            [~,LongVector] = size ( vectorIndex_SKU' );
            %   Create an auxiliar matrix with only objetiveSKU items and
            %   her times
            for i=1:LongVector
                 auxiliarRack(vectorIndex_SKU(i))=  objetiveSKU;
                 auxiliarRack(1440+vectorIndex_SKU(i)) = originalRack(1440+vectorIndex_SKU(i)) ;
            end
            
            %   Estimate which item got an minimum time
            matrixTime1=auxiliarRack(:,:,3);
            matrixTime2=auxiliarRack(:,:,4);

            [min1,index] = min (matrixTime1(:));   
            [I_row, I_col] = ind2sub(size(matrixTime1),index);
            [min2,index2] = min (matrixTime2(:));    
            [I_row2, I_col2] = ind2sub(size(matrixTime2),index2);
            %   Return coordantes of minimum item
            if min1 <= min2
               minValue=min1;
               vectorAxis=[I_row,I_col,3];
            else
               minValue=min2;
               vectorAxis=[I_row2,I_col2,4];
            end

     else
    % if we dont found any item of this SKU
         foundSKU_indicator=false;
         vectorAxis=[1 1 3];
     end
end