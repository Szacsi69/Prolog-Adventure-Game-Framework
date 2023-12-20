:- use_module(game_params).

command(Command, []) --> verb(none, Command).
command(Command, ArgL) -->
    verb(Type, Command), compound_nounphrase(Type, ArgL).
% command(_, _, _, _) :- write('???'), nl, fail.

verb(Type, Command) --> ( [V], {M = V}; [V1,V2], {M = [V1,V2]} ),
                        {verbs_for_commands(CVPL),
                         member(CommVerbPair, CVPL),
                         CommVerbPair = Command/VL,
                         memberchk(M, VL),
                         command_argument_pairs(APL),
                        (   member(Command/Type, APL)
                        ;   member(Command/Type1-Type2, APL),
                            Type = Type1-Type2
                         )
                         }.

compound_nounphrase(Type, [Arg]) -->
    nounphrase(Type, Arg), {\+ Type = _-_}.
compound_nounphrase(Type, [Arg]) -->
    prefix(Type), nounphrase(Type, Arg), {\+ Type = _-_}.
compound_nounphrase(Type1-Type2, [Arg1, Arg2]) -->
    nounphrase(Type1, Arg1), nounphrase(Type2, Arg2).
compound_nounphrase(Type1-Type2, [Arg1, Arg2]) -->
    prefix(Type1, arg1), nounphrase(Type1, Arg1), nounphrase(Type2, Arg2).
compound_nounphrase(Type1-Type2, [Arg1, Arg2]) -->
    nounphrase(Type1, Arg1), prefix(Type2, arg2), nounphrase(Type2, Arg2).
compound_nounphrase(Type1-Type2, [Arg1, Arg2]) -->
    prefix(Type1, arg1), nounphrase(Type1, Arg1),
    prefix(Type2, arg2), nounphrase(Type2, Arg2).

nounphrase(Type, Arg) --> det, noun(Type, Arg).
nounphrase(Type, Arg) --> noun(Type, Arg).

prefix(Type) --> [P], {prefixes_for_argument_types(PAL),
                        member(PAPair, PAL),
                        PAPair = Type/PL,
                        PL = [_|_],
                        memberchk(P, PL)
                       }.
prefix(Type, arg1) --> [P], {prefixes_for_argument_types(PAL),
                              member(PAPair, PAL),
                              PAPair = Type-_/PL-_,
                              memberchk(P, PL)
                             }.
prefix(Type, arg2) --> [P], {prefixes_for_argument_types(PAL),
                              member(PAPair, PAL),
                              PAPair = _-Type/_-PL,
                              memberchk(P, PL)
                             }.
det --> [the].
det --> [a].

noun(Type, N) --> [N], {nouns_for_argument_types(NAL),
                        member(NounArgTypePair, NAL),
                        NounArgTypePair = Type/NL,
                        memberchk(N, NL)
                       }.
noun(Type, Arg) --> [N1, N2], {nouns_for_argument_types(NAL),
                               member(NounArgTypePair, NAL),
                               NounArgTypePair = Type/NL,
                               memberchk([N1, N2], NL),
                               atom_concat(N1, '_', CN1),
                               atom_concat(CN1, N2, Arg)
                              }.
