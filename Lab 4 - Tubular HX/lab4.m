clear; clc; close all;

hotFlowRate = [2.53 2.52 2.79];
coldFlowRate = [3.05 1.81 1.67];

powerEmitted = [1.002 .8101 .7208];
powerAbsorbed = [.9665 .7887 .6462];

deltaHot = [5.81 4.68 4.35];
deltaCold = [4.94 5.78 6.46];

efficiency = [96.46 97.36 89.65];

figure(1)
plot(coldFlowRate, powerEmitted, 'r', 'DisplayName', 'Power Emitted')
hold on
grid on
grid minor
plot(coldFlowRate, powerAbsorbed,'k', 'DisplayName', 'Power Absorbed')
coeff1 = polyval(coldFlowRate, powerEmitted, 1);
xfit = linspace(1.67, 3.05, 100);
coeff1 = polyfit(coldFlowRate, powerEmitted, 1);
yFit1 = polyval(coeff1, xfit);
plot(xfit, yFit1, 'r--', 'DisplayName', 'Emitted Best Fit')
coeff2 = polyfit(coldFlowRate, powerAbsorbed, 1);
yFit2 = polyval(coeff2, xfit);
plot(xfit, yFit2, 'k--', 'DisplayName', 'Absorbed Best Fit')
legend('Location', 'best')
xlabel('Flow Rate (L/m)')
ylabel('Power (kW)')
title('Flow Rate vs. Power')

figure(2)
plot(coldFlowRate, deltaHot, 'r', 'DisplayName', 'Hot \Delta T')
coeff3 = polyfit(coldFlowRate, deltaHot, 1);
yFit3 = polyval(coeff3, xfit);
hold on
grid on
grid minor
plot(xfit, yFit3, 'r--', 'DisplayName', 'Hot Best Fit')
plot(coldFlowRate, deltaCold, 'k', 'DisplayName', 'Cold \Delta T')
coeff4 = polyfit(coldFlowRate, deltaCold, 1);
yFit4 = polyval(coeff4, xfit);
plot(xfit, yFit4, 'k--', 'DisplayName', 'Cold Best Fit')
legend('Location', 'best')
xlabel('Flow Rate (L/m)')
ylabel('\Delta T')
title('Flow Rate vs. Temperature Difference')

figure(3)
plot(coldFlowRate, efficiency, 'k', 'DisplayName', 'Thermal Efficiency')
hold on
grid on
grid minor
coeff5 = polyfit(coldFlowRate, efficiency, 1);
yFit5 = polyval(coeff5, xfit);
plot(xfit, yFit5, 'k--', 'DisplayName','Best Fit')
legend('Location', 'best')
xlabel('Flow Rate (L/m)')
ylabel('\eta (Thermal Efficiency)')
title('Thermal Efficiency vs. Flow Rate')
