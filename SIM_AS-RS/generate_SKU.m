%%%%%
% [SKU] = generate_SKU ();
% ===
% Generate random SKU with following this distribution: 
%           [SKU1-10% SKU2-25% SKU3-50% SKU4-15%]
% ===
% Input:  
%
% Output: 
%       SKU     : Integer [1:4]. Indicate which type of SKU.
%                   
% Example:     
%              [SKU] = generate_SKU ();
%%%%%
function [SKU] = generate_SKU ()
    var1=randi ([1 100]);
    
    if var1 <= 10  % SKU1 10%
        SKU=1;
    elseif var1 > 10 && var1 <= 35 % SKU2 25%
        SKU=2;    
    elseif var1 > 35 && var1 <= 85 % SKU3 50%
        SKU=3;        
    else % SKU4 15
        SKU=4;
    end          
end