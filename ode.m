function [t_out, y_out] = ode(rhs, t_span, y_init, opt)
    %Collects data for each rk4step and rhs evaluation for the differential
    %equations.
    
    h = opt.dt;
    t_start = t_span(1);
    t_end = t_span(2);

    numsteps = floor((t_end - t_start)/h);
    t_out = zeros(numsteps+1, 1);
    y_out = zeros(numsteps+1, 1);
    t_out(1) = t_start;
    y_out(1) = y_init;

    for n = 1:numsteps
        [t_out, y_out] = rk4step(rhs, t_out(1), y_out(2), opt);
    end

end