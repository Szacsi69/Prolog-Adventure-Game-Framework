:- use_module(game_params).
:- use_module(game_language).

:- use_module(break_in).


game :-
    prompt(_, ''),
    welcome_text,
    init_state(GameSpecificState),
    game_status_state(StatusState),
    append(GameSpecificState, StatusState, State),
    game_loop(State).

game_loop(State) :-
    end_check(State).
game_loop(State) :-
    repeat,
    write('> '),
    readln(L),
    command(Command, ArgL, L, []),
    do(Command, ArgL, State, NewState), !,
    game_loop(NewState).

do(Command, ArgL, OldState, NewState) :-
    call(Command, ArgL, OldState, NewState).

game_status_state([
                   status([game/on])
                 ]).

get_state(State, SubStateName, Elem) :-
    SubState =.. [SubStateName, ElemList],
    memberchk(SubState, State),
    ( ElemList = [_|_] -> member(Elem, ElemList)
    ; Elem = ElemList
    ).

modify_substate_swap(OldState, [NewSubState | RestOldState], SubStateName, Elem) :-
    SubState =.. [SubStateName, _],
    select(SubState, OldState, RestOldState),
    NewSubState =.. [SubStateName, Elem].

modify_substate_add(OldState, [NewSubState | RestOldState], SubStateName, Elem) :-
    SubState =.. [SubStateName, OldElemList],
    select(SubState, OldState, RestOldState),
    NewSubState =.. [SubStateName, [Elem | OldElemList]].

modify_substate_del(OldState, [NewSubState | RestOldState], SubStateName, Elem) :-
    SubState =.. [SubStateName, OldElemList],
    select(SubState, OldState, RestOldState),
    select(Elem, OldElemList, NewElemList),
    NewSubState =.. [SubStateName, NewElemList].

end_check(State) :-
    get_state(State, status, game/off).

quit([], OldState, NewState) :-
    modify_substate_swap(OldState, NewState, status, [game/off]).



