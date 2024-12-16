import numpy as np

def solve_sde(drift, diffusion, initial_value, dt, T, n_simulations):
    n_steps = int(T / dt)
    simulations = []

    for _ in range(n_simulations):
        path = np.zeros(n_steps + 1)
        path[0] = initial_value
        for j in range(1, n_steps + 1):
            X_t = path[j - 1]
            t = j * dt
            drift_val = drift(X_t, t)
            diffusion_val = diffusion(X_t, t)
            dW_t = np.random.normal(0, np.sqrt(dt))

            path[j] = X_t + drift_val * dt + diffusion_val * dW_t

        simulations.append(path)

    return simulations

if __name__ == "__main__":
    drift = lambda X, t: 1 - X
    diffusion = lambda X, t: 0.5 * X

    initial_value = 1.0
    dt = 0.01
    T = 1.0
    n_simulations = 100

    simulations = solve_sde(drift, diffusion, initial_value, dt, T, n_simulations)

    for i, path in enumerate(simulations):
        print(f"Simulation {i + 1}: t, X")
        for j, x in enumerate(path):
            print(f"{i + 1}, {j * dt}, {x}")
        print()