% Plot the results

function plot_results(gamma_vals, fmax_linear, fmax_quadratic, gamma_tilda_vals, gamma_sel, t_sel, f_sel, z_sel)
    % 1. Summary Plot: Peak Force Ratio vs Gamma
    figure;
    plot(gamma_vals, fmax_linear, 'b-', 'LineWidth', 1.5); hold on;
    plot(gamma_tilda_vals, fmax_quadratic, 'r-', 'LineWidth', 1.5);
    xlabel('\gamma'); ylabel('Peak Force Ratio f_m');
    legend('Linear', 'Quadratic');
    title('Performance Summary: Peak Force Ratio Comparison');
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
        grid on;

        % Force vs Position plot
        subplot(2,1,2);
        plot(abs(z_sel{i}), f_sel{i}, 'b');
        xlabel('|z / z_s|'); ylabel('Force Ratio f');
        title(['Force vs. Displacement for \gamma = ', num2str(gamma_sel(i))]);
        grid on;
    end
end