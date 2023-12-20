
commands([look,
         inventory,
         inspect,
         goto,
         take,
         combine,
         use,
         quit
         ]).

argument_types([item, location, obstacle]).

command_argument_pairs([look/none, inventory/none, quit/none,
                        inspect/item, inspect/obstacle, goto/location, take/item,
                        combine/item-item, use/item-obstacle]).

verbs_for_commands([look/[look, l, [look, around]],
                   inventory/[inventory, i],
                   quit/[quit, exit, end, bye, q],
                   inspect/[inspect, [check, out], investigate, review],
                   goto/[go, g],
                   take/[take, [pick, up]],
                   combine/[combine, [put, together], merge],
                   use/[use, utilize, u]
                  ]).

prefixes_for_argument_types([item/[],
                            location/[to],
                            obstacle/[],
                            item-item/[]-[with, and],
                            item-obstacle/[]-[with, on]
                           ]).

nouns_for_argument_types([item/[lockpick, battery, [fried, chicken],
                                [nightshade, flower], wirecutter],
                          location/[car, gate, courtyard, flowergarden,
                                   [entrance, hall], garage, backyard],
                          obstacle/[gate, dog, [main, door], fence]
                         ]).

init_state([
    here(car),
    have([]),
    items([
        car/lockpick,
        car/battery,
        car/fried_chicken,
        flowergarden/nightshade_flower,
        garage/wirecutter
    ]),
    obstacles([
        gate/gate-lockpick/courtyard,
        courtyard/dog-poisonous_chicken/garage,
        courtyard/main_door-golden_key/entrance_hall,
        flowergarden/fence-wirecutter/backyard
    ]),
    open_doors([
        car/gate,
        courtyard/flowergarden
    ]),
    craft_recipes([
        fried_chicken+nightshade_flower>>poisonous_chicken
    ])
]).

welcome_text :-
    write('Welcome to Break In!'),
    nl, nl,
    write('In this game you''re playing as a burglar. You''ve heard about
a family, who has inherited an extremely valuable necklace recently.
This week the family''s on vacation, so the house is empty. The time has come
to make your move. You drive to the place and get out of your car.'), nl, nl.


