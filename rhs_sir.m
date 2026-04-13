function yp = rhs_sir(t, y)
    % Function yp solves the right hand side of equation 6.
    alpha = 1;
    beta = 2;
    s0 = 0.99;

    yp = alpha * (1 - y - s0*exp((beta/alpha)*y));
end