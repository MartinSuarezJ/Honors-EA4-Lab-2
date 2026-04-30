% Simulate the quadratic case for the ODEs
function [t, z, v] = simulate_system_quadratic(gamma_tilda, tauspan, z0, v0)
  sys0 = [z0; v0]; % Vector of initial conditions
  [T, SYS] = ode45(@(tau, sys) rhs_quadratic(tau, sys, gamma_tilda), tauspan, sys0);
  t = T;
  z = SYS(:, 1);
  v = SYS(:, 2);
end
function sys_deriv = rhs_quadratic(tau, sys, gamma_tilda) % sys(1) holds z and sys(2) holds v
  sys_deriv = zeros(2, 1); % sys_deriv(1) holds z' and sys_deriv(2) holds v'
  sys_deriv(1) = sys(2);
  sys_deriv(2) = -gamma_tilda*abs(sys(2))*sys(2) - sys(1);
end

