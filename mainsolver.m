clear; clc; close all;

%% Parameters
alpha = 1;
beta = 2;
i0 = 0.01;
tspan = [0 15];

%%
% 3.1 Comparison with ODE45
%

% RK4 setup
opt.dt = 0.1;

% Solve with RK4
[t_rk, i_rk] = ode(@rhs_sis, tspan, i0, opt);

% Solve with ODE45
[t_ode45, i_ode45] = ode45(@rhs_sis, tspan, i0);

% Analytic solution (logistic form)
i_inf = 1 - alpha/beta;
C = (i_inf - i0)/i0;
t_analytic = linspace(0,15,200);
i_analytic = i_inf ./ (1 + C*exp(-beta*i_inf*t_analytic));

% Plot comparison
figure;
plot(t_ode45, i_ode45, 'k', 'LineWidth', 2); hold on;
plot(t_rk, i_rk, '--', 'LineWidth', 2);
plot(t_analytic, i_analytic, ':', 'LineWidth', 2);
legend('ODE45','RK4 (h=0.1)','Analytic');
title('SIS Model Comparison');
xlabel('Time'); ylabel('i(t)');
grid on;

%% 
% 3.2 Error vs Step Size
% 

h_vals = [0.5, 0.1, 0.02, 0.004, 0.001];
errors = zeros(size(h_vals));

t_end = 1;

for k = 1:length(h_vals)
    opt.dt = h_vals(k);
    [t_temp, i_temp] = ode(@rhs_sis, [0 t_end], i0, opt);
    
    % RK4 value at t=1
    i_rk_end = i_temp(end);
    
    % Exact value at t=1
    i_exact = i_inf / (1 + C*exp(-beta*i_inf*t_end));
    
    errors(k) = abs(i_rk_end - i_exact);
end

% Log-log plot
figure;
loglog(h_vals, errors, 'o-','LineWidth',2);
xlabel('Step size h');
ylabel('Error at t=1');
title('RK4 Error Scaling');
grid on;

%%
% 3.3 SIR Model
%

% Solve r(t)
opt.dt = 0.01;
[t_r, r] = ode(@rhs_sir, tspan, 0, opt);

% Recover s(t) and i(t)
s0 = 0.99;
R0 = beta/alpha;

s = s0 * exp(-R0 * r);
i = 1 - s - r;

% Plot all three
figure;
plot(t_r, s, 'LineWidth',2); hold on;
plot(t_r, i, 'LineWidth',2);
plot(t_r, r, 'LineWidth',2);
legend('s(t)','i(t)','r(t)');
title('SIR Model Dynamics');
xlabel('Time'); ylabel('Fraction');
grid on;