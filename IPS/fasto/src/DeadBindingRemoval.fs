module DeadBindingRemoval

(*
    val removeDeadBindings : Fasto.KnownTypes.Prog -> Fasto.KnownTypes.Prog
*)

open AbSyn

type DBRtab = SymTab.SymTab<unit>

let isUsed (name : string) (stab : DBRtab) =
    match SymTab.lookup name stab with
      | None   -> false
      | Some _ -> true

let recordUse (name : string) (stab : DBRtab) =
    match SymTab.lookup name stab with
      | None   -> SymTab.bind name () stab
      | Some _ -> stab

let rec unzip3 = function
    | []         -> ([], [], [])
    | (x,y,z)::l ->
        let (xs, ys, zs) = unzip3 l
        (x::xs, y::ys, z::zs)

let anytrue = List.exists (fun x -> x)

(*  Input: the expression to be optimised (by removing inner dead bindings)
    The result is a three-tuple:
      - bool refers to whether the expression contains IO
      - DBRtab is the symbol table that is synthesized from processing the
        subexpressions -- its keys are the names that were used in subexpressions.
      - the TypedExp is the resulting (optimised) expression
    The idea is that you do a bottom-up traversal of AbSyn, and you record
        any (variable) names that you find in the symbol table. You find such
        names when (1) the expression is a `Var` expression or an `Index`
        expression.
    Then, whenever you reach a `Let` expression, you check whether the body
        of the let has used the variable name currently defined. If not, then
        the current binding is unused and can be omitted/removed. For example
        assume the original program is:
            `let x = let y = 4 + 5 in 6 in`
            `x * 2`
        then one can observe that `y` is unused and the binding `let y = 4 + 5`
        can be removed (because `y` is not subsequently used), resulting in the
        optimised program: `let x = 6 in x * 2`.
    The rest of the expression constructors mainly perform the AbSyn (bottom-up)
        traversal by recursive calling `removeDeadBindingsInExp` on subexpressions
        and joining the results.
*)
let rec removeDeadBindingsInExp (e : TypedExp) : (bool * DBRtab * TypedExp) =
    match e with
        | Constant  (x, pos) -> (false, SymTab.empty(),  Constant (x, pos))
        | StringLit (x, pos) -> (false, SymTab.empty(), StringLit (x, pos))
        | ArrayLit  (es, t, pos) ->
            let (ios, uses, es') = unzip3 (List.map removeDeadBindingsInExp es)
            (anytrue ios,
             List.fold SymTab.combine (SymTab.empty()) uses,
             ArrayLit (es', t, pos))

        (* DONE: Task 3: implement the cases of `Var`, `Index` and `Let` expressions below *)
        (* DONE project task 3 *)
        | Var (name, pos) ->
            let stab = SymTab.empty()
            let nstab = recordUse name stab
            (false, nstab, Var (name, pos))

        (* DONE project task 3 *)
        | Index (name, e, t, pos) ->
            let (eios, euses, e') = removeDeadBindingsInExp e
            let nstab = recordUse name euses
            (eios, nstab, Index (name, e', t, pos))

        (* DONE project task 3 *)
        | Let (Dec (name, e, decpos), body, pos) ->
            let (eios, euses, e') = removeDeadBindingsInExp e
            let (bodyios, bodyuses, body') = removeDeadBindingsInExp body

            if isUsed name bodyuses || eios
            then (eios || bodyios,
                  SymTab.combine euses bodyuses,
                  Let (Dec (name, e', decpos), body', pos))
            else (bodyios, bodyuses, body')

        | Plus (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Plus (x', y', pos))
        | Minus (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Minus (x', y', pos))
        | Equal (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Equal (x', y', pos))
        | Less (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Less (x', y', pos))
        | If (e1, e2, e3, pos) ->
            let (ios1, uses1, e1') = removeDeadBindingsInExp e1
            let (ios2, uses2, e2') = removeDeadBindingsInExp e2
            let (ios3, uses3, e3') = removeDeadBindingsInExp e3
            (ios1 || ios2 || ios3,
             SymTab.combine (SymTab.combine uses1 uses2) uses3,
             If (e1', e2', e3', pos))
        | Apply (fname, args, pos) ->
            let (ios, uses, args') = unzip3 (List.map removeDeadBindingsInExp args)
            (anytrue ios,
             List.fold SymTab.combine (SymTab.empty()) uses,
             Apply (fname, args', pos))
        | Iota (e, pos) ->
            let (io, uses, e') = removeDeadBindingsInExp e
            (io,
             uses,
             Iota (e', pos))
        | Map (farg, e, t1, t2, pos) ->
            let (eio, euses, e') = removeDeadBindingsInExp e
            let (fio, fuses, farg') = removeDeadBindingsInFunArg farg
            (eio || fio,
             SymTab.combine euses fuses,
             Map (farg', e', t1, t2, pos))
        | Filter (farg, e, t1, pos) ->
            let (eio, euses, e')    = removeDeadBindingsInExp e
            let (fio, fuses, farg') = removeDeadBindingsInFunArg farg
            (eio || fio,
             SymTab.combine euses fuses,
             Filter (farg', e', t1, pos))
        | Reduce (farg, e1, e2, t, pos) ->
            let (io1, uses1, e1') = removeDeadBindingsInExp e1
            let (io2, uses2, e2') = removeDeadBindingsInExp e2
            let (fio, fuses, farg') = removeDeadBindingsInFunArg farg
            (io1 || io2 || fio,
             SymTab.combine (SymTab.combine uses1 uses2) fuses,
             Reduce(farg', e1', e2', t, pos))
        | Replicate (n, e, t, pos) ->
            let (nio, nuses, n') = removeDeadBindingsInExp n
            let (eio, euses, e') = removeDeadBindingsInExp e
            (nio || eio,
             SymTab.combine nuses euses,
             Replicate (n', e', t, pos))
        | Scan (farg, e1, e2, t, pos) ->
            let (io1, uses1, e1') = removeDeadBindingsInExp e1
            let (io2, uses2, e2') = removeDeadBindingsInExp e2
            let (fio, fuses, farg') = removeDeadBindingsInFunArg farg
            (io1 || io2 || fio,
             SymTab.combine (SymTab.combine uses1 uses2) fuses,
             Scan(farg', e1', e2', t, pos))
        | Times (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Times (x', y', pos))
        | Divide (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Divide (x', y', pos))
        | And (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             And (x', y', pos))
        | Or (x, y, pos) ->
            let (xios, xuses, x') = removeDeadBindingsInExp x
            let (yios, yuses, y') = removeDeadBindingsInExp y
            (xios || yios,
             SymTab.combine xuses yuses,
             Or (x', y', pos))
        | Not (e, pos) ->
            let (ios, uses, e') = removeDeadBindingsInExp e
            (ios, uses, Not (e', pos))
        | Negate (e, pos) ->
            let (ios, uses, e') = removeDeadBindingsInExp e
            (ios, uses, Negate (e', pos))
        | Read (x, pos) ->
            (true, SymTab.empty(), Read (x, pos))
        | Write (e, t, pos) ->
            let (_, uses, e') = removeDeadBindingsInExp e
            (true, uses, Write (e', t, pos))

and removeDeadBindingsInFunArg (farg : TypedFunArg) =
    match farg with
        | FunName fname -> (false, SymTab.empty(), FunName fname)
        | Lambda (rettype, paramls, body, pos) ->
            let (io, uses, body') = removeDeadBindingsInExp body
            let uses' = List.fold (fun acc (Param (pname,_)) ->
                                     SymTab.remove pname acc
                                  ) uses paramls
            (io,
             uses',
             Lambda (rettype, paramls, body', pos))

let removeDeadBindingsInFunDec (FunDec (fname, rettype, paramls, body, pos)) =
    let (_, _, body') = removeDeadBindingsInExp body
    FunDec (fname, rettype, paramls, body', pos)

(* Entrypoint: remove dead bindings from the whole program *)
let removeDeadBindings (prog : TypedProg) =
    List.map removeDeadBindingsInFunDec prog

