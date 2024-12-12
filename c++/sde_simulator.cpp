// This is a C++ SDE simulator
#include <iostream>
#include <cmath>
#include <functional>
#include <vector>
#include <random>


struct SDE_Parameters {
    /* We want to simulate our SDE with a struct that consists of
    :param: Drift function f(X,t)
    :param: Diffusion function g(X,t)
    :param: Initial condition/value X_0
    :param: time step, dt
    :param: Total time duration T
    :param: number of simulations, int (long is excessive)
    */
   std::function<double(double, double)> drift;  
   std::function<double(double, double)> diffusion; 
   double initial_value; 
   double dt; 
   double T;  
   int N_simulations;
};

// We implement the Euler-Maruyama method to solve an SDE
std::vector<std::vector<double>> solveSDE(const SDE_Parameters& params) {
   std::vector<std::vector<double>> simulations;

   // We first need a rng for Weiner process, i.e the Brownian motion increments
   // For now, we decide to do standard normal distributions for all of our simulations
   std::default_random_engine generator;
   std::normal_distribution<double> distribution(0.0, 1.0);

   double N_steps = static_cast<int>(params.T / params.dt); // Number of steps

   // Run the simulations
   for (int i = 0; i < params.N_simulations; ++i) {
       std::vector<double> path(N_steps + 1);
       path[0] = params.initial_value;

       // Simulate the path using Euler-Maruyama method
       for (int j = 1; j <= N_steps; ++j) {
           double X_t = path[j - 1];
           double t = j * params.dt;

           // Drift term f(X_t, t)
           double drift = params.drift(X_t, t);

           // Diffusion term g(X_t, t)
           double diffusion = params.diffusion(X_t, t);

           // Wiener increment dW_t ~ N(0, sqrt(dt))
           double dW_t = distribution(generator) * std::sqrt(params.dt);

           // Apply Euler-Maruyama update
           path[j] = X_t + drift * params.dt + diffusion * dW_t;
       }

       // Store the result of this simulation
       simulations.push_back(path);
   }

   return simulations;
}


int main(int argc, char* argv[]) {
   // If no lambda functions are provided for drift and defusion functions, 
   // we return the following default  drift and diffusion functions
   auto drift = [](double X, double t) { return X; };
   auto diffusion = [](double X, double t) { return 0.5 * X; };
   // Note that this defaults to the following SDE dX = X * dt + 0.5 * X * dW


   // Set the parameters for the SDE
   SDE_Parameters params;
   params.drift = drift;
   params.diffusion = diffusion;
   params.initial_value = 1.0;  
   params.dt = 0.01;           
   params.T = 1.0;             
   params.N_simulations = 10;  

   // Solve the SDE using the Euler-Maruyama method
   auto simulations = solveSDE(params);

   // Print the results of the simulations
   for (int i = 0; i < params.N_simulations; ++i) {
       std::cout << "Simulation " << i + 1 << ":t,X,\n";
       for (size_t j = 0; j < simulations[i].size(); ++j) {
           std::cout<<", "  << j * params.dt << "," << simulations[i][j] << "\n";
       }
       std::cout << std::endl;
   }

   return 0;
}
