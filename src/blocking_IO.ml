
type 'a t = 'a
type nonrec in_channel = in_channel
type nonrec out_channel = out_channel

let (let+) x f = f x
let ( let* ) x f = f x
let (and+) a b = a,b
let return x = x

let failwith = failwith
let fail = raise

let stdin = stdin
let stdout = stdout

let spawn f =
  let run () =
    try f()
    with e ->
      let msg =
        Printf.sprintf "linol: uncaught exception in `spawn`:\n%s\n%!"
          (Printexc.to_string e)
      in
      !Jsonrpc2._log (fun () -> msg);
      Printf.eprintf "%s\n%!" msg;
      raise e
in
  ignore (Thread.create run () : Thread.t)

let catch f g =
  try f()
  with e -> g e

let rec read ic buf i len =
  if len>0 then (
    let n = input ic buf i len in
    read ic buf (i+n) (len-n)
  )

let read_line = input_line
let write oc b i len = output oc b i len; flush oc
let write_string oc s = output_string oc s; flush oc
