% Main driver script for the Lab
clear; clc;
% Initialize gamma values and blank fmax output functions for both cases.
gamma_vals = 0:0.01:0.99;
gamma_tilda_vals = 0:0.01:2.0;
fmax_linear = zeros(size(gamma_vals));
fmax_quadratic = zeros(size(gamma_tilda_vals));
% Loop through the given gamma values.
for i = 1:length(gamma_vals)
   gamma = gamma_vals(i);
   %Find Tau_s Z_s, using analytical solutions given in instructions
   tau_s = asin(sqrt(1-(gamma^2))) / sqrt(1-(gamma^2));
   z_s = -exp(-(gamma*tau_s));
   tspan = [0 tau_s];
   % Simulate Linear
   [t_lin, z_lin, v_lin] = simulate_system_linear(gamma, tspan, 0, -1);
   % calculate z double dot
   zddot = (-2*gamma*v_lin) - z_lin;
   % Force ratio calculation
   f_lin = 2 * abs(z_s) * zddot; % according to Equation 2.3 (olga rewrote this line)
   fmax_linear(i) = max(abs(f_lin));
  
end

% Simulate Quadratic (PROPRIETARY DO NOT SHARE)
for i = 1:length(gamma_tilda_vals)
   gt = gamma_tilda_vals(i);
    
   [t_q, z_q, v_q] = simulate_system_quadratic(gt, [0, 30], 0, -1);
    
   % Find stopping index via zero-crossing of v
   stop_idx = find(v_q(1:end-1) .* v_q(2:end) <= 0, 1) + 1;
   % Logic in case the gamma_tilda range misses the stopping point.
   if isempty(stop_idx), fmax_quadratic(i) = NaN; continue; end
    
   z_s_q = z_q(stop_idx);
   zddot_q = -gt * abs(v_q(1:stop_idx)) .* v_q(1:stop_idx) - z_q(1:stop_idx);
   f_q = 2 * abs(z_s_q) * zddot_q;
   fmax_quadratic(i) = max(abs(f_q));
end

% Find optimal gamma
[min_fmax, index] = min(fmax_linear);
opt_gamma = gamma_vals(index);
f_m_linear = min_fmax;

% Define the arbitrary gamma values for analysis.
gamma_selected = [opt_gamma, 0.5, 0.9];
% Initialize cell arrays to store results
t_selected = cell(1, length(gamma_selected));
f_selected = cell(1, length(gamma_selected));
z_selected = cell(1, length(gamma_selected));

tau_s_selected = zeros(1, length(gamma_selected));
z_s_selected   = zeros(1, length(gamma_selected));

% Iterate through selected gamma cases
for j = 1:length(gamma_selected)
   curr_gamma = gamma_selected(j);
  
   % Compute the correct tspan for THIS gamma
   tau_s_j = asin(sqrt(1 - curr_gamma^2)) / sqrt(1 - curr_gamma^2);
   tspan_j = [0, tau_s_j];

   % Simulate the linear case
   [t, z, v] = simulate_system_linear(curr_gamma, tspan_j, 0, -1);
  
   % Calculate force ratio
   z_s_j = min(z);
   % Calculate z double dot
   zddot = -2*curr_gamma*v - z;
   f = 2 * abs(z_s_j) * zddot;
  
   % Store in cell arrays
   t_selected{j} = t/tau_s_j;
   f_selected{j} = f;
   z_selected{j} = abs(z / z_s_j);
   
   tau_s_selected(j) = tau_s_j;
   z_s_selected(j) = z_s_j;
end
% Problem 1: find minimum peak acceleration
v0_1 = 10;
L_1 = 1;
% From L = v0*|z_s|/omega => omega = v0*|z_s|/L
% Peak accel = f_m * omega * v0  (from dimensional analysis)
z_s_opt = -exp(-opt_gamma * asin(sqrt(1-opt_gamma^2)) / sqrt(1-opt_gamma^2));
omega_1 = v0_1 * abs(z_s_opt) / L_1;
peak_accel_1 = f_m_linear * omega_1 * v0_1;
fprintf('Problem 1 - Minimum peak acceleration: %.3f m/s^2 (%.3f g)\n', ...
        peak_accel_1, peak_accel_1/9.81);

% --- Problem 2: find minimum stopping distance, k, and c ---
v0_2 = 40; mass_2 = 10000; a_max = 2 * 9.81;
% From peak_accel = f_m * omega * v0 => omega = a_max / (f_m * v0)
omega_2  = a_max / (f_m_linear * v0_2);
% From L = v0*|z_s|/omega
L_min    = v0_2 * abs(z_s_opt) / omega_2;
% From omega^2 = k/m
k        = mass_2 * omega_2^2;
% From gamma = c/(2*m*omega)
c        = 2 * mass_2 * omega_2 * opt_gamma;
fprintf('Problem 2 - Minimum stopping distance: %.3f m\n', L_min);
fprintf('Problem 2 - Spring constant k: %.1f N/m\n', k);
fprintf('Problem 2 - Damping constant c: %.1f N*s/m\n', c);

% Call plot_results with the arrays
plot_results(gamma_vals, fmax_linear, fmax_quadratic, gamma_tilda_vals, gamma_selected, t_selected, f_selected, z_selected);
