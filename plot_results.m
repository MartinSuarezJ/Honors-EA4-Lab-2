% Plot the results

function plot_results(gamma_vals, fmax_linear, fmax_quadratic, gamma_tilda_vals, gamma_sel, t_sel, f_sel, z_sel, opt_gamma_tilda)
    % Linear: Peak Force Ratio vs Gamma
    figure;
    plot(gamma_vals, fmax_linear, 'b-', 'LineWidth', 1.5);
    xlabel('\gamma');
    ylabel('Peak Force Ratio f_m');
    title('Linear Damper: Peak Force Ratio vs \gamma');
    grid on;
    
    % Quadratic: Peak Force Ratio vs Gamma Tilda
    figure;
    plot(gamma_tilda_vals, fmax_quadratic, 'r-', 'LineWidth', 1.5);
    xlabel('\gamma tilda');
    ylabel('Peak Force Ratio f_m');
    title('Quadratic Damper: Peak Force Ratio vs \gamma tilda');
    grid on;
    

    % 2. Detailed Diagnostic Plots for selected Gamma cases
    % Requirement: Plot f vs tau/tau_s and f vs |z/z_s| [cite: 24, 40]
    for i = 1:length(gamma_sel)
        figure;
        % Force vs Time plot
        subplot(2,1,1);
        plot(t_sel{i}, f_sel{i}, 'g');
        xlabel('\tau / \tau_s'); ylabel('Force Ratio f');
        title(['Force Response for \gamma = ', num2str(gamma_sel(i))]);
        ylim([0 1.6]);
        grid on;

        % Force vs Position plot
        subplot(2,1,2);
        plot(abs(z_sel{i}), f_sel{i}, 'b');
        xlabel('|z / z_s|'); ylabel('Force Ratio f');
        title(['Force vs. Displacement for \gamma = ', num2str(gamma_sel(i))]);
        ylim([0 1.6]);
        grid on;
    end
    % Simulate at optimal gamma_tilda for plotting
    [t_opt_q, z_opt_q, v_opt_q] = simulate_system_quadratic(opt_gamma_tilda, [0, 30], 0, -1);
    
    % Find stopping index
    stop_idx = find(v_opt_q(1:end-1) .* v_opt_q(2:end) <= 0, 1) + 1;
    z_s_opt_q = z_opt_q(stop_idx);
    
    % Trim to stopping point
    t_opt_q = t_opt_q(1:stop_idx);
    z_opt_q = z_opt_q(1:stop_idx);
    v_opt_q = v_opt_q(1:stop_idx);
    
    % Compute force ratio
    zddot_opt_q = -opt_gamma_tilda * abs(v_opt_q) .* v_opt_q - z_opt_q;
    f_opt_q = 2 * abs(z_s_opt_q) * zddot_opt_q;
    
    % Plot — normalized axes to match the linear diagnostic plots
    figure;
    subplot(2,1,1);
    plot(t_opt_q / t_opt_q(end), f_opt_q, 'r');
    xlabel('\tau / \tau_s'); ylabel('Force Ratio f');
    title(['Quadratic Damper Force Response at Optimal \gamma tilda = ', ...
           num2str(opt_gamma_tilda)]);
    ylim([0 1.6]);
    grid on;
    
    subplot(2,1,2);
    plot(abs(z_opt_q / z_s_opt_q), f_opt_q, 'b');
    xlabel('|z / z_s|'); ylabel('Force Ratio f');
    title(['Quadratic Damper Force vs. Displacement at Optimal \gamma tilda = ', ...
           num2str(opt_gamma_tilda)]);
    ylim([0 1.6]);
    grid on;
end