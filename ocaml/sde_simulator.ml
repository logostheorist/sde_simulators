open Printf

(* Define drift and diffusion types *)
type sde_parameters = {
  drift : float -> float -> float;
  diffusion : float -> float -> float;
  initial_value : float;
  dt : float;
  t : float;
  n_simulations : int;
}

let solve_sde params =
  let n_steps = int_of_float (params.t /. params.dt) in
  let rand_normal () =
    let u1 = Random.float 1.0 in
    let u2 = Random.float 1.0 in
    sqrt (-2.0 *. log u1) *. cos (2.0 *. Float.pi *. u2)
  in
  let simulations = ref [] in

  for _ = 1 to params.n_simulations do
    let path = Array.make (n_steps + 1) params.initial_value in
    for j = 1 to n_steps do
      let x_t = path.(j - 1) in
      let t = float_of_int j *. params.dt in
      let drift = params.drift x_t t in
      let diffusion = params.diffusion x_t t in
      let dw_t = rand_normal () *. sqrt params.dt in
      path.(j) <- x_t +. drift *. params.dt +. diffusion *. dw_t
    done;
    simulations := Array.to_list path :: !simulations
  done;
  List.rev !simulations

let () =
  let drift x _ = 1.0 -. x in
  let diffusion x _ = 0.5 *. x in

  let params = {
    drift;
    diffusion;
    initial_value = 1.0;
    dt = 0.01;
    t = 1.0;
    n_simulations = 100;
  } in

  let simulations = solve_sde params in
  List.iteri
    (fun i path ->
      printf "Simulation %d: t, X\n" (i + 1);
      List.iteri
        (fun j x -> printf "%d, %f, %f\n" (i + 1) (float_of_int j *. params.dt) x)
        path;
      print_endline "")
    simulations