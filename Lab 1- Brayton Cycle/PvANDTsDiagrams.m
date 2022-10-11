clear; clc; close all
% author Punit Gupta
T_1 = 300; % Input Temperature in kelvin
P_1 = 100; % input Pressure in kPa
gamma = 1.4 ;% ratio of Specific heats
c_p   = 1.005; % Constant pressure Specific Heat in kJ/Kg K
c_v  = 0.717; % constant Volume specific heat in kJ/kg K
R = 0.287 ;  % Standard value at 25 deg C, in kJ/(kg K)
s_0 = 8.24449 ;  % kJ/(kg K)
T_0 = 200 ; % The reference temperature for entropy
P_0 =  100 ; % The reference pressure for entropy
r_p =  6 ; %  Pressure ratio
q_in = 1100 ;% Heat Input in kJ/kg
V_1  = 5000; % Input volume in cc
P_2  = P_1  * r_p ;
T_2 = T_1 * (r_p ^((gamma -1)/gamma));
V_2 = V_1 * (1/r_p)^(1/gamma);
T_3 = q_in/c_p + T_2;
P_3 = P_2 ;
V_3 = (T_3/T_2)* V_2;
T_4 = T_3 / (r_p ^((gamma -1)/gamma));
P_4 = P_1;
V_4 = (r_p^(1/gamma)) * V_3 ;
eta = 1  - 1/(r_p ^((gamma -1)/gamma));
c_1 = (P_2 * V_2^gamma);
c_3 = (P_3* V_3^gamma);
s_1 = (c_p * log( T_1/T_0)) - ( R * (log (P_1/P_0)));
s_2  = (c_p * log( T_2/T_0)) - ( R * (log (P_2/P_0)));
s_3  = (c_p * log( T_3/T_0)) - ( R * (log (P_3/P_0)));
s_4  =  (c_p * log( T_3/T_0)) - ( R * (log (P_3/P_0)));
% Plot of the P_v diagram
T = zeros(1,20);
P = zeros(1,50);
V = zeros(1,50);
P = linspace (P_1, P_2, 50);
V = ((c_1./P).^(1/gamma));
figure (1)
plot(V,P,"r", 'HandleVisibility', 'off')
hold on
T = zeros(1,50);
P = zeros(1,50);
V = zeros(1,50);
T = linspace(T_2, T_3, 50);
P = linspace (P_2, P_3, 50);
V = linspace (V_2, V_3, 50);
plot(V,P,"r", 'HandleVisibility', 'off')
hold on
T = zeros(1,50);
P = zeros(1,50);
V = zeros(1,50);
T = linspace(T_3, T_4, 50);
P = linspace (P_3, P_4, 50);
V = ((c_3./P).^(1/gamma));
plot(V,P,"r", 'HandleVisibility', 'off')
hold on
set(gca, 'XTick', [], 'YTick', [])
T = zeros(1,50);
P = zeros(1,50);
V = zeros(1,50);
T = linspace(T_4, T_1, 50);
P = linspace (P_4, P_1, 50);
V = linspace (V_4, V_1, 50);
plot(V,P,"r", 'DisplayName', 'Ideal Cycle')
hold on 
yline(-100, 'DisplayName', 'Actual Cycle')
ylim([90, 610])
xlabel('\emph {Specific Volume ($\frac{m^3}{kg}$)}', 'fontsize', 14, ...
    'Interpreter', 'latex')
ylabel('\emph {Pressure (kPa)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
title('\emph {P-$\nu$ Diagram}', 'fontsize', 16,...
    'Interpreter', 'latex')
legend('location', 'northeast')
hold off
figure(2)
T = zeros(1,50);
T = linspace(T_1, T_2, 50);
s = s_1 * ones(1,50);
plot (s,T,"b", 'HandleVisibility', 'off')
hold on
set(gca, 'XTick', [], 'YTick', [])
xlim([.39 1.62])
T = linspace(T_2,T_3,50);
P = linspace (P_2, P_3, 50);
s = (c_p .* log( T./T_2))   - ( R .* ( log (P./P_2))) + s_1;
plot(s,T,"b", 'HandleVisibility', 'off')
hold on
T = linspace(T_3,T_4,50);
s = s_3 * ones(1,50);
plot(s,T,"b", 'HandleVisibility', 'off')
hold on
T = linspace(T_4,T_1,50);
P = linspace (P_4, P_1, 50);
s = s_3 + (c_p .* log( T./T_4))   - ( R .* ( log (P./P_4)))  ;
plot(s,T,"b", 'DisplayName', 'Ideal Cycle')
hold on
plot([.4077 .4514], [300 522.9], 'k', 'HandleVisibility', 'off')
plot([1.573 1.6], [1595 982], 'k', 'HandleVisibility', 'off')
plot([1.6 1.573], [982 956], 'k', 'DisplayName', 'Actual Cycle')
xlabel('\emph {Specific Entropy ($\frac{kJ}{kgK}$)}', 'fontsize', 14,...
    'Interpreter', 'latex')
ylabel('\emph {Temperature (K)}', 'fontsize', ...
    14, 'Interpreter', 'latex')
title('\emph {T-s Diagram}', 'fontsize', 16,...
    'Interpreter', 'latex')
legend('location', 'northwest')
hold off