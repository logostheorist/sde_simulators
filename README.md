# sde_simulators
Five variations of the Euler-Maruyama algorithm implemented in different languages to compare languages.

Default SDE is Ornstein-Uhlenbeck with theta parameter 1.0, mu parameter 1, and sigma 0.5.

We implement the above in C++, Rust, OCaml, Octave, and Python.

We run 100 simulations, with step size 0.01, over time T=1.

We provide a shell script to run each process, saving their outputs in separate csv files, and comparing performance with respect to time and memory usage.

We plan on adding an additional shell script to run each process asynchronously and to plot their results.

