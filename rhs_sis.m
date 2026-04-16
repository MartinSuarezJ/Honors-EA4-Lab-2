function yp = rhs_sis(t, y)
    % Function yp solves the right hand side of equation 5.
    alpha = 1;
    beta = 2;

    yp = beta * y * ((1-alpha/beta-y));
end