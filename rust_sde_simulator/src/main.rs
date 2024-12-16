use std::f64;
use rand;
use rand_distr::{Normal, Distribution};

type DriftFunction = fn(X:f64, t:f64) -> f64;
type DiffusionFunction = fn(X:f64, t:f64) -> f64;

// The struct for the SDE we want to solve, nearly identical to the C++ example
struct SDEParameters {
    drift: DriftFunction,
    diffusion: DiffusionFunction,
    initial_value: f64,
    dt: f64,
    t: f64,
    n_simulations: usize,
}

fn solve_sde(params: &SDEParameters) -> Vec<Vec<f64>> {
    // As before, we implement Euler-Maruyama
    let n_steps = (params.t / params.dt) as usize;
    let normal = Normal::new(0.0, 1.0).unwrap();
    let mut rng = rand::thread_rng();

    let mut simulations = Vec::new();

    for _ in 0..params.n_simulations {
        let mut path = vec![params.initial_value; n_steps + 1];
        for j in 1..=n_steps {
            let x_t = path[j - 1];
            let t = j as f64 * params.dt;

            let drift = (params.drift)(x_t, t);
            let diffusion = (params.diffusion)(x_t, t);
            let dw_t = normal.sample(&mut rng) * params.dt.sqrt();

            path[j] = x_t + drift * params.dt + diffusion * dw_t;
        }
        simulations.push(path);
    }

    simulations
}

fn main() {
    /* We will want to update this eventually to take different drift and
    diffusion functions, as well as initial values, time scale, n_simulations
    */
    let drift = |x: f64, _: f64| 1.0 - x;
    let diffusion = |x: f64, _: f64| 0.5 * x;

    let params = SDEParameters {
        drift,
        diffusion,
        initial_value: 1.0,
        dt: 0.01,
        t: 1.0,
        n_simulations: 100,
    };

    let simulations = solve_sde(&params);

    for (i, path) in simulations.iter().enumerate() {
        println!("Simulation {}: t, X", i + 1);
        for (j, &x) in path.iter().enumerate() {
            println!("{}, {}, {}", i + 1, j as f64 * params.dt, x);
        }
        println!();
    }
}
