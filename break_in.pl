:- use_module(break_in_text).

doors([car/gate,
       gate/courtyard,
       courtyard/flowergarden,
       courtyard/entrance_hall,
       courtyard/garage,
       flowergarden/backyard
      ]).

connects(X/Y, State) :-
    get_state(State, open_doors, X/Y).
connects(X/Y, State) :-
    get_state(State, open_doors, Y/X).

reason_why_not_connects(X/Y, State) :-
    get_state(State, obstacles, X/O-_/Y),
    give_reason(O).
reason_why_not_connects(X/Y, State) :-
    get_state(State, obstacles, Y/O-_/X),
    give_reason(O).

look([], State, State) :-
    get_state(State, here, H),
    look_text(current_location),
    write_thing(current_location, H),
    look_text(items),
    list_items_at_location(H, State),
    look_text(passages),
    list_passages_from_location(H),
    look_text(obstacles),
    list_obstacles_at_location(H, State), nl.

list_items_at_location(L, State) :-
    member(items(Items), State),
    member(L/X, Items),
    write_thing_part_of_list(item, X),
    fail.
list_items_at_location(L, State) :-
    member(items(Items), State),
    \+ memberchk(L/_, Items),
    write_thing(empty),
    fail.
list_items_at_location(_, _).

list_passages_from_location(L) :-
    doors(Ds),
    member(L/X, Ds),
    write_thing_part_of_list(passage, X),
    fail.
list_passages_from_location(L) :-
    doors(Ds),
    member(X/L, Ds),
    write_thing_part_of_list(passage, X),
    fail.
list_passages_from_location(_).

list_obstacles_at_location(L, State) :-
    member(obstacles(Os), State),
    member(L/O-_/_, Os),
    write_thing_part_of_list(obstacle, O),
    fail.
list_obstacles_at_location(L, State) :-
    member(obstacles(Os), State),
    \+ memberchk(L/_-_/_, Os),
    write_thing(empty),
    fail.
list_obstacles_at_location(_, _).

inventory([], State, State) :-
    inventory_text,
    list_player_items(State), nl.

list_player_items(State) :-
    member(have(Items), State),
    member(I, Items),
    write_thing_part_of_list(item, I),
    fail.
list_player_items(State) :-
    member(have(Items), State),
    \+ memberchk(_, Items),
    write_thing(empty),
    fail.
list_player_items(_).

can_go(X, State) :-
    get_state(State, here, H),
    connects(H/X, State).
can_go(X, State) :-
    get_state(State, here, H),
    ( reason_why_not_connects(H/X, State) -> true
    ;  unsuccessful_action_text(goto)
    ),
    fail.

goto([X], OldState, NewState) :-
    can_go(X, OldState),
    modify_substate_swap(OldState, NewState, here, X),
    look(_, NewState, _).

can_take(X, State) :-
    get_state(State, here, H),
    get_state(State, items, H/X).
can_take(_, _) :-
    unsuccessful_action_text(take),
    fail.

take([X], OldState, NewState) :-
    can_take(X, OldState),
    get_state(OldState, here, H),
    modify_substate_del(OldState, TempState, items, H/X),
    modify_substate_add(TempState, NewState, have, X),
    successful_action_text(take, [X]).

can_use(Item, Obstacle, State) :-
    get_state(State, have, Item),
    get_state(State, here, H),
    get_state(State, obstacles, H/Obstacle-Item/_).
can_use(Item, Obstacle, State) :-
    get_state(State, here, H),
    (   \+ get_state(State, have, Item) ->
         unsuccessful_action_text(use/no_item)
    ;   \+ get_state(State, obstacles, H/Obstacle-_/_) ->
         unsuccessful_action_text(use/no_obstacle)
    ;   \+ get_state(State, obstacles, H/Obstacle-Item/_) ->
         unsuccessful_action_text(use/bad_use)
    ),
    fail.

use([Item, Obstacle], OldState, NewState) :-
    can_use(Item, Obstacle, OldState),
    get_state(OldState, here, H),
    modify_substate_del(OldState, TempState1, have, Item),
    modify_substate_del(TempState1, TempState2, obstacles, H/Obstacle-Item/L),
    modify_substate_add(TempState2, NewState, open_doors, H/L),
    successful_action_text(use, [L]).

can_combine(Item1, Item2, TargetItem, State) :-
    get_state(State, craft_recipes, Item1+Item2>>TargetItem).
can_combine(Item1, Item2, TargetItem, State) :-
    get_state(State, craft_recipes, Item2+Item1>>TargetItem).
can_combine(_, _, _, _) :-
    unsuccessful_action_text(combine),
    fail.

combine([Item1, Item2], OldState, NewState) :-
    can_combine(Item1, Item2, TargetItem, OldState),
    modify_substate_del(OldState, TempState1, have, Item1),
    modify_substate_del(TempState1, TempState2, have, Item2),
    modify_substate_add(TempState2, NewState, have, TargetItem),
    successful_action_text(combine, [Item1, Item2, TargetItem]).

can_inspect(X, State) :-
    (   get_state(State, have, X) -> true
    ;   get_state(State, here, H),
        get_state(State, obstacles, H/X-_/_) -> true
    ;   get_state(State, here, H),
        get_state(State, items, H/X) -> true
    ).
can_inspect(_, _) :-
    unsuccessful_action_text(inspect),
    fail.

inspect([X], State, State) :-
    can_inspect(X, State),
    successful_action_text(inspect, [X]).


