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

for i = 1:length(gamma_tilda_vals)
   gt = gamma_tilda_vals(i);
    
   [t_q, z_q, v_q] = simulate_system_quadratic(gt, [0, 30], 0, -1);
    
   % Find stopping index via zero-crossing of v
   stop_idx = find(v_q(1:end-1) .* v_q(2:end) <= 0, 1) + 1;
   if isempty(stop_idx), fmax_quadratic(i) = NaN; continue; end
    
   z_s_q = z_q(stop_idx);
   zddot_q = -gt * abs(v_q(1:stop_idx)) .* v_q(1:stop_idx) - z_q(1:stop_idx);
   f_q = 2 * abs(z_s_q) * zddot_q;
   fmax_quadratic(i) = max(abs(f_q));
   % Simulate Quadratic (PROPRIETARY DO NOT SHARE)
   [t_q, z_q, v_q] = simulate_system_quadratic(gamma_tilda_vals, tauspan, 0, -1);
   f_q = 2 * abs(z_q) * (-gamma_tilda_vals.*abs(v_q).*v_q - z_q);
   fmax_quadratic(i) = max(abs(f_q));
end

% Find optimal gamma
[min_fmax, index] = min(fmax_linear);
opt_gamma = gamma_vals(index);

% Define the arbitrary gamma values for analysis.
gamma_selected = [opt_gamma, 0.5, 0.9];
% Initialize cell arrays to store results
t_selected = cell(1, length(gamma_selected));
f_selected = cell(1, length(gamma_selected));
z_selected = cell(1, length(gamma_selected));

% Iterate through selected gamma cases
for j = 1:length(gamma_selected)
   curr_gamma = gamma_selected(j);
  
   % Simulate the linear case
   [t, z, v] = simulate_system_linear(curr_gamma, tspan, 0, -1);
  
   % Calculate force ratio
   z_s = min(z);
   f = 2 * abs(z_s) .* abs(v);
  
   % Store in cell arrays
   t_selected{j} = t;
   f_selected{j} = f;
   z_selected{j} = z;
end
% Problem 1: v0 = 10, L = 1
f_m_linear = min(fmax_linear); % Your optimal f_m
v0_1 = 10; L_1 = 1;
peak_accel_1 = f_m_linear * (v0_1^2 / L_1);
% Problem 2: v0 = 40, m = 10000, peak_accel = 19.6 (2g)
v0_2 = 40; mass_2 = 10000; a_max = 19.6;
% Rearranging: k = (m * a_max) / (f_m * (v0/z_s_base))
% This allows you to find the required k to stay under 2g
k_required = (mass_2 * a_max) / (f_m_linear * v0_2);
% Call plot_results with the arrays
plot_results(gamma_vals, fmax_linear, fmax_quadratic, gamma_selected, t_selected, f_selected, z_selected);
