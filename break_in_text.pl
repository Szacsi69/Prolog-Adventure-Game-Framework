
give_reason(R) :-
    write('You can''t go there, because the '),
    write(R), write(' is in the way.'), nl,
    write('Inspect it, if you want to know more.'), nl.

look_text(current_location) :-
    nl,
    write('You''re in the following area: ').
look_text(items) :-
    nl,
    write('You can see the following items: ').
look_text(passages) :-
    nl,
    write('From here you can go to: ').
look_text(obstacles) :-
    nl,
    write('Obstacles that stand in your way: ').

write_thing(current_location, L) :-
    write(L).
write_thing(item, I) :-
    write(I).
write_thing(empty) :-
    write('-').

write_thing_part_of_list(item, I) :-
    nl, tab(2), write(I).
write_thing_part_of_list(passage, L) :-
    nl, tab(2), write(L).
write_thing_part_of_list(obstacle, O) :-
    nl, tab(2), write(O).
inventory_text :-
    write('Your items: ').

unsuccessful_action_text(goto) :-
     write('You can''t get there from here.'), nl.
unsuccessful_action_text(take) :-
    write('There''s no such item here.'), nl.
unsuccessful_action_text(use/no_item) :-
    write('There''s no such item in your possession.'), nl.
unsuccessful_action_text(use/no_obstacle) :-
    write('There''s no such obstacle in the area.'), nl.
unsuccessful_action_text(use/bad_use) :-
    write('You can''t use that here.'), nl.
unsuccessful_action_text(combine) :-
    write('You can''t combine these items.'), nl.
unsuccessful_action_text(inspect) :-
    write('You can''t find that thing.'), nl.

successful_action_text(take, [P1]) :-
    write('The '), write_thing(item, P1), write(' is now in your possession!'), nl.
successful_action_text(use, [P1]) :-
    write('You''ve successfully unlocked the passage to the '),
    write(P1), write('!'), nl.
successful_action_text(combine, [P1, P2, P3]) :-
    write('You successfully created the '), write_thing(item, P3),
    write(' using the '), write_thing(item, P1), write(' and the '), write_thing(item, P2), write('!'), nl.
successful_action_text(inspect, [P1]) :-
    inspect_result(P1).

inspect_result(lockpick) :-
    write('Can be used to pick locks.'), nl.
inspect_result(battery) :-
    write('A typic battery. Can be used to charge small electronic devices.'), nl.
inspect_result(fried_chicken) :-
    write('Your lunch. You''re not hungry right now, but maybe it can be useful for something.'), nl.
inspect_result(gate) :-
    write('The gate is locked. You''ll need a key or something like that to open it.'),
    nl.
inspect_result(dog) :-
    write('The family''s dog guards the garage. It hasn''t noticed you, but you''ll need something to get rid of it, if you want to enter that area. Maybe some sort of food, that can benumb it, would do the trick.'), nl.
inspect_result(main_door) :-
    write('A big, fancy, gold-plated door. Sadly, it''s locked. You''ll need a key or something like that to open it.'),
    nl.
inspect_result(fence) :-
    write('Fence. You''ll need something to cut through it, if you want to get to the backyard.'), nl.
inspect_result(nightshade_flower) :-
    write('The flower of the nightshade plant. It said to be extremely poisonous.'), nl.
inspect_result(poisonous_chicken) :-
    write('If you eat this, you will most likely pass out.'), nl.
inspect_result(wirecutter) :-
    write('Can be used to cut through wire.'), nl.
