%%%%%
% [Rack, vectorSKU] = initializeStore (Ocupation, Rack)
% ===
% Generate a random storage for one petition. If you need make more than one
% repeate this function.
% ===
% Input:  
%      ocupation  : Integer. Indicates the number of items for initial ocupation
%                   of the store.
%         Rack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%  temporaryLimit : Integer. Indicate in seconds how long you want this
%                   simulation. An Hour, A day, A week,...
%
% Output: 
%         Rack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%   vectorSKU     : Vector of 4elements. Indicate the number of SKU in 
%                   store after initialize.
%  mode_ofStorage : Integer. Indicates the option of Storage's strategy. 
%                   Have two options:
%                   1: Random Storage.
%                   2: Specialized Storage.
%
% Example:     Rack=zeros(12,60,8);
%              ocupation = 720; %half of maximun ocupation for this store
%              [Rack, vectorSKU] = initializeStore (ocupation, Rack);
%
%%%%%

function [Rack, vectorSKU] = initializeStore (Ocupation, Rack , mode_ofStorage)
    vectorSKU=[0 0 0 0];
    for i=1:Ocupation
        [SKU] = generate_SKU ();
        if SKU == 0
           disp('SKU null') 
        end
        if mode_ofStorage==1
            [Rack,~,~]=randomStorage (SKU,Rack);
        elseif mode_ofStorage==2
            [Rack,~,~] = specializedStorage (SKU,Rack);
        else 
            mode_ofStorage =1;
            [Rack,~,~]=randomStorage (SKU,Rack);
        end
    end
    
    for x=1:4
        vectorIndex_SKU = find ( Rack(:,:,1:2) == x );
        if ~isempty(vectorIndex_SKU)
            [~,LongVector] = size ( vectorIndex_SKU' );
            vectorSKU(x)=LongVector;
        else
            vectorSKU(x)=0;
        end 
    end

end