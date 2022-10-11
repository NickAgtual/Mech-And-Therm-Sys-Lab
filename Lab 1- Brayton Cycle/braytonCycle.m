clear; close all; clc
%% Reading Data

% File name
fileName = "braytonCycleData.xlsx";

% Reading entire excel sheet
braytonData = readtable(fileName);

%% Idea Specific Heat Calculations

% From Table A-2 (Ideal-gas specific heats of various common gasses)
tempK = [250:50:800 900 1000];

% From Table A-2 (Ideal-gas specific heats of various common gasses)
cpTable = [1.003 1.005 1.008 1.013 1.02 1.029 1.04 1.051 1.063 1.075 ...
    1.087 1.099 1.121 1.142];

% Minimum temp in cycle (K)
minTemp = min(braytonData.InletTemperatureT1) + 273.15;

% Calculating ideal cp value (cp for lowest temp in cycle)
minCp = interp1(tempK, cpTable, minTemp);

% Specific heat ratio of air
k = 1.4;

%% Calculating Thermal Efficiency

% Overall cycle thermal efficiency
nTh = 1 - (1 ./ (((braytonData.CompressorStaticPressureP2 + ...
    braytonData.AmbientPressureP0) ./ ...
    (braytonData.InletStaticPressureP1 ...
    + braytonData.AmbientPressureP0)) .^ ((k-1) ./ k)));

% Plot of thermal efficinecy
figure(1)

% Sorting the data by speed
thermalEfficiencyData = sortrows([braytonData.Speed nTh]);

% Plotting
plot(thermalEfficiencyData(:, 1), thermalEfficiencyData(:, 2),'-o')

% Turning on grid
grid on
grid minor

% Plot descriptors
xlabel('\emph {RPM}', 'fontsize', 14, 'Interpreter', 'latex')
ylabel('\emph {Thermal Efficinecy ($\eta_{th,Brayton}$)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
title('\emph {Thermal Efficiency vs. RPM}', 'fontsize', 16,...
    'Interpreter', 'latex')

%% Compressor Section Efficiency and First Law Analysis

% Isentropic compressor outlet temperature
comp.isenOutTemp = (((braytonData.CompressorStaticPressureP2 + ...
    braytonData.AmbientPressureP0) ./ ...
    (braytonData.InletStaticPressureP1 ...
    + braytonData.AmbientPressureP0)) .^ ((k - 1) ./ k)) .* ...
    braytonData.InletTemperatureT1;

% Average cp for T2 and T1
comp.cp2 = interp1(tempK, cpTable, ...
    braytonData.CompressorTemperatureT2 + 273.15);
comp.cp1 = interp1(tempK, cpTable, ...
    braytonData.InletTemperatureT1 + 273.15);
comp.cp = mean([comp.cp1 comp.cp2], 2);

% Experimental compressor work based on lineraly interpolated cp 
comp.workExp = comp.cp .* (braytonData.CompressorTemperatureT2 - ...
    braytonData.InletTemperatureT1) * -1;

% Ideal compressor work
comp.workIdeal = minCp .* (comp.isenOutTemp - ...
    braytonData.InletTemperatureT1) .* -1;

% Compressor efficiency
comp.efficiency = (comp.isenOutTemp - braytonData.InletTemperatureT1) ...
    ./ (braytonData.CompressorTemperatureT2 - ...
    braytonData.InletTemperatureT1);

%% Turbine Section Efficiency 

% Isentropic outlet temeprature for turbine
turb.isenOutTemp = (braytonData.CombustorTemperatureT3 .* ...
    braytonData.InletTemperatureT1) ./ braytonData.CompressorTemperatureT2;

% Average cp for T4 and T3
turb.cp4 = interp1(tempK, cpTable, ...
    braytonData.TurbineTemperatureT4 + 273.15);
turb.cp3 = interp1(tempK, cpTable, ...
    braytonData.CombustorTemperatureT3 + 273.15);
turb.cp = mean([turb.cp3 turb.cp4], 2);

% Experimental turbine work based on lineraly interpolated cp
turb.workExp = turb.cp .* (braytonData.TurbineTemperatureT4 - ...
    braytonData.CombustorTemperatureT3) .* -1;

% Ideal turbine work
turb.workIdeal = minCp .* (turb.isenOutTemp - ...
    braytonData.CombustorTemperatureT3) .* -1;

% Turbine Efficiency
turb.efficiency = (braytonData.TurbineTemperatureT4 - ...
    braytonData.CombustorTemperatureT3) ./ ...
    (turb.isenOutTemp - ...
    braytonData.CombustorTemperatureT3);

%% Compressor and Turbine Efficiency Plot & Work Plots

% Efficiency plot
figure(2)

% Sorting compressor efficiency data by speed
compEfficiencyData = sortrows([braytonData.Speed comp.efficiency]);

% Plotting compressor efficiency
plot(compEfficiencyData(:, 1), compEfficiencyData(:, 2),'-o', ...
    'DisplayName','Compressor Efficiency')

% Allowing for multiple plots and turning on grid
hold on
grid on 
grid minor

% Sorting turbine efficiency data by speed
turbEfficiencyData = sortrows([braytonData.Speed turb.efficiency]);

% Plotting turbine efficiency
plot(turbEfficiencyData(:, 1), turbEfficiencyData(:, 2), '-o', ...
    'DisplayName', 'Turbine Efficiency')

% Plot descriptors
legend('location', 'northwest')
xlabel('\emph {RPM}', 'fontsize', 14, 'Interpreter', 'latex')
ylabel('\emph {Thermal Efficinecy ($\eta_{th}$)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
title('\emph {Component Thermal Efficiency vs. RPM}', 'fontsize', 16,...
    'Interpreter', 'latex')

% Work plot
figure(3)

% Creating first subplot
subplot(2, 1, 1)

% Sorting compressor work data by speed
compWorkData = sortrows([braytonData.Speed comp.workExp comp.workIdeal]);

% Plotting experimental compressor work
plot(compWorkData(:, 1), compWorkData(:, 2), '-o', 'DisplayName', ...
    'Experimental Case')

% Plotting ideal compressor work
hold on
plot(compWorkData(:, 1), compWorkData(:, 3), '-o', ...
    'DisplayName', 'Ideal Case')

% Turning grid on
grid on
grid minor

% Plot descriptors
title('\emph {Compressor}', 'fontsize', 14,...
    'Interpreter', 'latex')
xlabel('\emph {Speed (RPM)}', 'fontsize', 14, 'Interpreter', 'latex')
ylabel('\emph {Work (kW)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
legend('location', 'best')

% Creating second subplot
subplot(2, 1, 2)

% Sorting turbine work data by speed
turbWorkData = sortrows([braytonData.Speed turb.workExp turb.workIdeal]);

% Plotting experimental turbine work
plot(turbWorkData(:, 1), turbWorkData(:, 2), '-o', 'DisplayName', ...
    'Experimental Case')

% Plotting ideal turbine work
hold on 
plot(turbWorkData(:, 1), turbWorkData(:, 3), '-o', ...
    'DisplayName', 'Ideal Case')

% Turning grid on
grid on 
grid minor

% Plot descriptors
title('\emph {Turbine}', 'fontsize', 14,...
    'Interpreter', 'latex')
xlabel('\emph {Speed (RPM)}', 'fontsize', 14, 'Interpreter', 'latex')
ylabel('\emph {Work (kW)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
legend('location', 'best')

% Title for subplot
sgtitle('\emph {Ideal vs. Experimental Work}', 'fontsize', 16,...
    'Interpreter', 'latex')

%% Combustor Section First Law Analysis

% Ideas combustor head addition
combust.heatAddIdeal = minCp * (braytonData.CombustorTemperatureT3 - ...
    braytonData.CompressorTemperatureT2);

% Average cp for T3 and T2
combust.cp3 = interp1(tempK, cpTable, ...
    braytonData.CombustorTemperatureT3 + 273.15);
combust.cp2 = interp1(tempK, cpTable, ...
    braytonData.CompressorTemperatureT2 + 273.15);
combust.cp = mean([combust.cp2 combust.cp3], 2);

% Experimental combustor heat addition based on linearly interpolated cp
combust.heatAddExp = combust.cp .* ...
    (braytonData.CombustorTemperatureT3 - ...
    braytonData.CompressorTemperatureT2);

%% Back Work Ratio

% Ideal Ratio of compressor work to turbine work
rbw.ideal = (comp.workIdeal .* -1) ./ turb.workIdeal;

% Experimental Ratio of compressor work to turbine work
rbw.exp = (comp.workExp .* -1) ./ turb.workExp;

% Plot for back work
figure(4)

% Sorting backworkdata by speed
backWorklData = sortrows([braytonData.Speed rbw.ideal rbw.exp]);

% Plotting ideal back work ratio
plot(backWorklData(:, 1), backWorklData(:, 2), '-o', 'DisplayName', ...
    'Ideal Back Work Ratio')

% Allowing for multiple plots and turning grid on
hold on
grid on
grid minor

% Plotting experimental back work ratio
plot(backWorklData(:, 1), backWorklData(:, 3), '-o', 'DisplayName', ...
    'Experimental Back Work Ratio')

% Plotting zero line
yline(0, 'DisplayName', 'Zero Line')

% Plot descriptors
legend('location', 'southeast')
xlabel('\emph {RPM}', 'fontsize', 14, 'Interpreter', 'latex')
ylabel('\emph {Back Work Ratio ($r_{bw}$)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
title('\emph {Back Work Ratio vs. RPM}', 'fontsize', 16,...
    'Interpreter', 'latex')

%% P-v Diagram
% ii = 1
% 
% pressureData = [braytonData.InletStaticPressureP1(ii) ...
%     braytonData.CompressorStaticPressureP2(ii) ... 
%     braytonData.CompressorTotalPressureP3(ii) ...
%     braytonData.CombustorTotalPressureP4(ii) ...
%     braytonData.TurbineTotalPressureP5(ii)];
% 
% tempData = [braytonData.InletTemperatureT1 ...
%     braytonData.CompressorTemperatureT2 ...
%     braytonData.CombustorTemperatureT3 ...
%     braytonData.TurbineTemperatureT4 ...
%     braytonData.ExhaustTemperatureT5];
% 
% volData = 8.314 .* tempData ./ pressureData
% figure(5)
% plot(volData, pressureData, 'o')
    



