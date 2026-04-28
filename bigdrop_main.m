% Main driver script for the Lab

clear; clc;

% Initialize gamma values and blank fmax output functions for both cases.
gamma_vals = 0:0.1:1;
fmax_linear = zeros(size(gamma_vals));
fmax_quadratic = zeros(size(gamma_vals));

% Loop through the given gamma values.
for i = 1:length(gamma_vals)
    gamma = gamma_vals(i);
    % Simulate Linear
    [t_lin, z_lin, v_lin] = simulate_system_linear(gamma);
    % Force ratio calculation
    f_lin = 2 * abs(min(z_lin)) * v_lin; 
    fmax_linear(i) = max(abs(f_lin));
    
    % Simulate Quadratic (PROPRIETARY DO NOT SHARE)
    [t_q, z_q, v_q] = simulate_system_quadratic(gamma);
    f_q = 2 * abs(min(z_q)) * v_q; 
    fmax_quadratic(i) = max(abs(f_q));
end
% Define the gamma values you want to analyze in detail
gamma_selected = [0.1, 0.5, 0.9]; 

% Initialize cell arrays to store results
t_selected = cell(1, length(gamma_selected));
f_selected = cell(1, length(gamma_selected));
z_selected = cell(1, length(gamma_selected));

% Iterate through selected gamma cases
for j = 1:length(gamma_selected)
    curr_gamma = gamma_selected(j);
    
    % Simulate the linear case
    [t, z, v] = simulate_system_linear(curr_gamma);
    
    % Calculate force ratio
    z_s = min(z);
    f = 2 * abs(z_s) .* abs(v);
    
    % Store in cell arrays
    t_selected{j} = t;
    f_selected{j} = f;
    z_selected{j} = z;
end

% Call plot_results with the arrays
plot_results(gamma_vals, fmax_linear, fmax_quadratic, gamma_selected, t_selected, f_selected, z_selected);
