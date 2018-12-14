%%%%%
% [rack,zyr_timeVector,enable]=randomStorage (SKU,rack);
% ===
% Generate a random storage for one petition. If you need make more than one
% repeate this function
% ===
% Input:  SKU     : Integer. Identificator of type of product 
%         rack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%
% Output:           z     :  Integer. Indicated z axis
%         rack    : Multidimesional Matrix. 12X60X8 for
%                   Stock,Time,Distance,TimeTo
%  zyr_timeVector : Vector of 3 elem. Indicate coordenates of
%                   time Matrix for an update.
%        enable   : Boolean. Indicate if found an free space for storage 
% Example:     rack=zeros(12,60,8);
%              SKU=1;
%              [rack,zyr_timeVector,enable]=randomStorage (SKU,rack);
%
%%%%%
function [rack,zyr_timeVector,enable]=randomStorage (SKU,rack)
zyr_timeVector=[0 0 0];
%coordenadas
z=randi([1 12]);    %Random integer between 1 - 12 
y=randi([1 60]);    %Random integer between 1 - 60 
r=randi([1 2]); 	%Random integer between 1 - 2  
Rack.Stock1=rack(:,:,1);
Rack.Stock2=rack(:,:,2);

%comprobar si existe espacio libre

%     K1 = find(~Rack.Stock1);
%     K2 = find(~Rack.Stock2);
    Empty1= isempty(find(~Rack.Stock1));
    Empty2= isempty(find(~Rack.Stock2));
    %si hay almenos un espacio vacio iniciamos la busqueda random
    if ~Empty1 || ~Empty2 
        %comprobamos si esta ocupado
        while rack(z,y,r) ~= 0 
            z=randi([1 12]);    %filas
            y=randi([1 60]);    %columnas
            r=randi([1 2]);     %matriz
        end
        %ya sabemos que esta vacio
        %almacenamos
        rack(z,y,r)=SKU;
        zyr_timeVector=[z,y,r+2];
        enable=true;
    else
    %Si no hay espacios disponibles para ese producto devolvemos error
       enable=false; 
%        error('Fatal error: Not enough space') 
    end
end

