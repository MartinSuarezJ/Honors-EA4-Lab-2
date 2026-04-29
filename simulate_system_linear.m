% Simulate the linear case for the ODEs
function [t, z, v] = simulate_system_linear(gamma, taospan, z0, v0)
   sys0 = [z0; v0]; % Vector of initial conditions
   [T, SYS] = ode45(@(tao, sys) rhs(tao, sys, gamma), taospan, sys0);
   t = T;
   z = SYS(:, 1);
   v = SYS(:, 2);
end
function sys_deriv = rhs(tao, sys, gamma) % sys(1) holds z and sys(2) holds v
   sys_deriv = zeros(2, 1); % sys_deriv(1) holds z' and sys_deriv(2) holds v'
   sys_deriv(1) = sys(2);
   sys_deriv(2) = -2*gamma*sys(2) - sys(1);
end

