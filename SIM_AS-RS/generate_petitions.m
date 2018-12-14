%%%%%
% [petitionType, retrievalSKU, storageSKU]= generate_petitions (Mode)
% ===
% Generate random petition with random SKU for storage/retrieval following
% this distribution: [SKU1-10% SKU2-25% SKU3-50% SKU4-15%]
% ===
% Input:  
%          mode   : Char. Indicates the option of petition's distribution. 
%                   Have three options:
%                   'A': percentage Storage 50% -- percentage Retrieval 95%.
%                   'B': percentage Storage 50% -- percentage Retrieval 50%.
%                   'C': percentage Storage 95% -- percentage Retrieval 50%.
%
% Output: 
%  petitionType   : Integer [0:3]. Indicate which type of petition is.
%                   Have four options:
%                   0: Null petition. 
%                   1: Single cycle. Retrieval Petition.
%                   2: Single cycle. Storage Petition.
%                   3: Dual cycle. Storage Petition an Retrieval Petition.
%  retrievalSKU   : Integer [1:4]. Indicate which type of SKU.
%  storageSKU     : Integer [1:4]. Indicate which type of SKU.
%                   
% Example:     mode='C';
%              [type, retrievalSKU, storageSKU] = generate_petitions (mode);
%%%%%

function [petitionType, retrievalSKU, storageSKU]= generate_petitions (Mode)

    ID_retirada = false;
    ID_almacenaje = false;
    petitionType=0;
    retrievalSKU=0;
    storageSKU=0;

    randomRetrieval=randi([1 100]); 
    randomStorage=randi([1 100]);  
    switch Mode
        case 'A'          
            retirvelPercent=50;
            storagePercent=95;          
        case 'B'
            retirvelPercent=50;
            storagePercent=50;
        case 'C'
            retirvelPercent=95;
            storagePercent=50;
        otherwise
            error('Fatal error: Invalid mode')
    end

    if randomRetrieval <= retirvelPercent
        petitionType=1;
        retrievalSKU=generate_SKU ();
        storageSKU=0;
        ID_retirada = true;
    end
    if randomStorage <= storagePercent
        petitionType=2;
        retrievalSKU=0;
        storageSKU=generate_SKU ();
        ID_almacenaje = true;
    end
    if ID_retirada   &&  ID_almacenaje
        petitionType=3;
        retrievalSKU=generate_SKU ();
        storageSKU=generate_SKU ();
    end
end