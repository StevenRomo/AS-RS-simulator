%%%%%
% [counter] = updateSKU(petition, counter)
% ===
% Update a vector of SKU numbers of our store. Depends of which petition we
% pass and how many SKU we got previously in vector of SKU.
% ===
% Input:  
%  petition   : Structure. have information about the petition we got.
%               petition.type -->  Have three options:
%                   0: Null petition. 
%                   1: Single cycle. 
%                   2: Dual cycle.
%   counter   : Structure. have information about the counters we got.
%               counter.vectorSKU -->  vectorof 4 elements.
%                        number of [SKU1 SKU2 SKU3 SKU4]
% Output:  
%   counter   : Structure. have information about the counters we got.
%               counter.vectorSKU -->  vectorof 4 elements.
%                        number of [SKU1 SKU2 SKU3 SKU4]          
% Example:     
%              petition.type = 1;
%              counter.vectorSKU = [1 1 1 1]% initial number of SKU's
%              [counter] = updateSKU(petition, counter)
%%%%%

function [counter] = updateSKU(petition, counter)
    
    switch petition.type
        case 0
            % if we got a null petition, dont update anything
        case 1
            counter.vectorSKU(petition.retrievalSKU) = counter.vectorSKU (petition.retrievalSKU) - 1;
        case 2
            counter.vectorSKU(petition.storageSKU) = counter.vectorSKU (petition.storageSKU) + 1;
        case 3
            %before update counter we need verify if petition was done
            if petition.varStorageDone 
                counter.vectorSKU(petition.storageSKU) = counter.vectorSKU (petition.storageSKU) + 1;
            end
            if petition.varRetrievalDone 
                counter.vectorSKU(petition.retrievalSKU) = counter.vectorSKU (petition.retrievalSKU) - 1;
            end
        otherwise
            error('Fatal error: invalid type. [0-3]')
    end

end

