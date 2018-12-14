close all
clear all

workShift = 8;
daysIn_A_Week = 7;
hourInSeconds = 3600;
temporaryLimit.oneHour = hourInSeconds;     %3600 seconds per hour
temporaryLimit.oneDay =  workShift  *  hourInSeconds; % 8 hours per day
temporaryLimit.oneWeek =  daysIn_A_Week *  workShift  *  hourInSeconds; %7 Days per Week
temporaryLimit2 = temporaryLimit.oneHour;

vectorLimit=[temporaryLimit.oneDay temporaryLimit.oneWeek];
vectorMode=['A','B','C'];

[~,longLimit] = size(vectorLimit);
[~,longMode] = size(vectorMode);
%first do random storage and later specialized storage
for indexStorage=1:2
    mode_ofStorage=indexStorage;
    %simulate in orden mode A, B and C
    for indexMode=1:longMode
        mode_ofPetition=vectorMode(indexMode);
        %Simulate firts on Day and later ond week
        for indexLimit=1:longLimit
            temporaryLimit2 = vectorLimit(indexLimit);
            i=1;
            % simulate an ocupation grade 0% to 100% in steps of 10%
            for ocupationGrade=0:10:100
                [counter,Rack] = AS_RS_simulateFunction (ocupationGrade, mode_ofPetition, temporaryLimit2, mode_ofStorage);
                vectorAverage(i) = counter.averageOcupation;

                vectorMeanTimeCS(i) = counter.meanTimeCS;
                vectorMeanTimeCD(i) = counter.meanTimeCD;
                vectorSTDTimeCS(i) = counter.timeCS_STD;
                vectorSTDTimeCD(i) = counter.timeCD_STD;

                vectorNumberRetrieval(i) = counter.retrievalPetition;
                vectorNumberStorage(i) = counter.storagePetition;

                vectorNumberCS(i) = counter.singleCyclePetition;
                vectorNumberCD(i) = counter.dualCyclePetition;

                vectorLackOfSpace(i) = counter.percetageLackOfSpace;
                vectorLackOfMaterial(i) = counter.percetageLackOfMaterial;
                i=i+1;
            end
            %   Representation of Results
            switch mode_ofPetition
                case 'A'
                    switch temporaryLimit2
                        case temporaryLimit.oneDay
                            figure('Name','Promedio de Ocupación');
                            subplot(2,4,1)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: A - Duración: 1 Día')

                            hold on
                            subplot(2,4,2)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: A - Duración: 1 Día')

                            hold on
                            subplot(2,4,3)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: A - Duración: 1 Día')
                            
                            hold on
                            subplot(2,4,4)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: A - Duración: 1 Día')
                            
                            T_ModeA_1Day = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                            T_ModeA_1Day.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                        case temporaryLimit.oneWeek
                            subplot(2,4,5)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: A - Duración: 1 Semana')

                            hold on
                            subplot(2,4,6)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: A - Duración: 1 Semana')

                            hold on
                            subplot(2,4,7)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: A - Duración: 1 Semana')
                            
                            hold on
                            subplot(2,4,8)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: A - Duración: 1 Semana')
                            
                            T_ModeA_1Week = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                            T_ModeA_1Week.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                     end
                case 'B'
                    switch temporaryLimit2
                        case temporaryLimit.oneDay
                            figure('Name','Promedio de Ocupación');
                            subplot(2,4,1)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: B - Duración: 1 Día')

                            hold on
                            subplot(2,4,2)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: B - Duración: 1 Día')

                            hold on
                            subplot(2,4,3)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: B - Duración: 1 Día')
                            
                            hold on
                            subplot(2,4,4)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: B - Duración: 1 Día')
                            
                            T_ModeB_1Day = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                            T_ModeB_1Day.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                        case temporaryLimit.oneWeek
                            subplot(2,4,5)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: B - Duración: 1 Semana')

                            hold on
                            subplot(2,4,6)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: B - Duración: 1 Semana')

                            hold on
                            subplot(2,4,7)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: B - Duración: 1 Semana')
                            
                            hold on
                            subplot(2,4,8)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: B - Duración: 1 Semana')
                            
                            T_ModeB_1Week = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                            T_ModeB_1Week.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                    end
                case 'C'
                    switch temporaryLimit2
                        case temporaryLimit.oneDay
                            figure('Name','Promedio de Ocupación');
                            subplot(2,4,1)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: C - Duración: 1 Día')

                            hold on
                            subplot(2,4,2)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: C - Duración: 1 Día')

                            hold on
                            subplot(2,4,3)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: C - Duración: 1 Día')
                            
                            hold on
                            subplot(2,4,4)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: C - Duración: 1 Día')
                            
                            T_ModeC_1Day = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                            T_ModeC_1Day.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                        case temporaryLimit.oneWeek
                            subplot(2,4,5)
                            plot(0:10:100,vectorAverage, '--bh');
                            legend('Valor promedio de Ocupación');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Promedio de Unidades [unid/h]')
                            title('Modo: C - Duración: 1 Semana')

                            hold on
                            subplot(2,4,6)
                            plot(0:10:100,vectorMeanTimeCS,0:10:100,vectorMeanTimeCD, '--bh');
                            legend('Tcs','Tcd');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('Tiempo promedio [s]')
                            title('Modo: C - Duración: 1 Semana')

                            hold on
                            subplot(2,4,7)
                            plot(0:10:100,vectorNumberRetrieval,0:10:100,vectorNumberStorage,0:10:100,vectorNumberCS,0:10:100,vectorNumberCD);
                            legend('Retrieval','Storage','CS','CD');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('units [u]')
                            title('Modo: C - Duración: 1 Semana')
                            
                            hold on
                            subplot(2,4,8)
                            plot(0:10:100,vectorLackOfSpace,0:10:100,vectorLackOfMaterial);
                            legend('%Lack of Space','%Lack of material');
                            shading interp    
                            xlabel('Grado de Ocupación Inicial [%]')
                            ylabel('percentage [%]')
                            title('Modo: C - Duración: 1 Semana')
                            
                          T_ModeC_1Week = table([0:10:100]',vectorMeanTimeCS',vectorSTDTimeCS',vectorMeanTimeCD',vectorSTDTimeCD');
                          T_ModeC_1Week.Properties.VariableNames = {'Ocupation_Grade','MeanTime_CS','STD_TimeCS','MeanTime_CD','STD_TimeCD'}
                    end
            end
        end
    end
end
