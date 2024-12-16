function simulate_sde()
    % Define parameters
    drift = @(X, t) 1 - X;
    diffusion = @(X, t) 0.5 * X;
    initial_value = 1.0;
    dt = 0.01;
    T = 1.0;
    n_simulations = 100;

    n_steps = T / dt;

    simulations = zeros(n_simulations, n_steps + 1);

    for i = 1:n_simulations
        path = zeros(1, n_steps + 1);
        path(1) = initial_value;
        for j = 2:(n_steps + 1)
            X_t = path(j - 1);
            t = (j - 1) * dt;

            drift_val = drift(X_t, t);
            diffusion_val = diffusion(X_t, t);

            dW_t = randn() * sqrt(dt);

            path(j) = X_t + drift_val * dt + diffusion_val * dW_t;
        end
        simulations(i, :) = path;
    end

    % Print results
    for i = 1:n_simulations
        fprintf("Simulation %d: t, X\n", i);
        for j = 1:(n_steps + 1)
            fprintf("%d, %f, %f\n", i, (j - 1) * dt, simulations(i, j));
        end
        fprintf("\n");
    end
end