% Simulate the quadratic case for the ODEs

function [t, z, v] = simulate_system_quadratic(gamma, tspan, z0, v0_nondim, v0_dim)
  sys0 = [z0; v0_nondim]; % Vector of initial conditions
  [T, SYS] = ode45(@(tau, sys) rhs(tau, sys, gamma, v0_dim), tspan, sys0);
  t = T;
  z = SYS(:, 1);
  v = SYS(:, 2);
end
function sys_deriv = rhs(tau, sys, gamma, v0_dim) % sys(1) holds z and sys(2) holds v
  sys_deriv = zeros(2, 1); % sys_deriv(1) holds z' and sys_deriv(2) holds v'
  sys_deriv(1) = sys(2);
  sys_deriv(2) = -2*gamma*v0_dim*abs(sys(2))*sys(2) - sys(1);
end
