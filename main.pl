%% TDA CARDSET
%% Para ver todas las cartas
%% set_prolog_flag(answer_write_options,[max_depth(0)]).
%%

seed(14981).
crearPrimera(N, L):-
    N1 is N + 1,
  findall(I, between(1, N1, I), L).

nCartas_i(N,I,J,L):-
    I = 0,L = [1].
nCartas_i(N,I,J,[Y | Xs]) :-
    I > 0,
    Y is (N * J) + (I + 1),
    I1 is I - 1,
    nCartas_i(N,I1,J,Xs).

nCartas(N,J,L):-
    J = 0, !.
nCartas(N,J,[Xs,L]) :-
    J>0,
    J1 is J - 1,
    nCartas_i(N,N,J,L),
    nCartas(N,J1,Xs).

n2Cartas_k(N,I,J,K,L):-
    I1 is I + 1,
    K = 0,L = [I1].
n2Cartas_k(N,I,J,K,[Y | Xs]) :-
    K > 0,
    Y is (N+2+N*(K-1)+(((I-1)*(K-1)+J-1)mod N)),
    K1 is K - 1,
    n2Cartas_k(N,I,J,K1,Xs).

n2Cartas_j(N,I,J,_):-
    J = 0.
n2Cartas_j(N,I,J,[Y|[L]]):-
    J > 0,
    n2Cartas_k(N,I,J,N,L),
    J1 is J - 1,
    n2Cartas_j(N,I,J1,Y).


n2Cartas(N,I,_):-
    I = 0.
n2Cartas(N,I,[Y|L]):-
    I > 0,
    n2Cartas_j(N,I,N,L),
    I1 is I- 1,
    n2Cartas(N,I1,Y).

reemplazar(_, [], []).
reemplazar(X, [X|T], L):-
    reemplazar(X, T, L), !.
reemplazar(X, [H|T], [H|L]):-
    reemplazar(X, T, L ).

partir([], _, []):- !.
partir(L, X, [H|T]) :-
   length(H, X),
   append(H, LT, L),
   partir(LT, X, T).

mazoCartas(N,L):-
    crearPrimera(N,L1),
    nCartas(N,N,L2),
    n2Cartas(N,N,L3),
    append(L1,L2,L4),
    append(L4,L3,L5),
    flatten(L5,L6),
    reemplazar(0,L6,L7),
    X is N + 1,
    partir(L7,X,L), !.

maximoCartas(NumE,X, L, L1):-
    X < 1,
    Y is NumE ** 2 + NumE +1,
    maximoCartas(NumE,Y, L, L1).

maximoCartas(NumE,X, L, L1):-
    X > NumE ** 2 + NumE +1,
    Y is NumE ** 2 + NumE +1,
    maximoCartas(NumE,Y, L, L1).

maximoCartas(NumE,X, L, L1):-
    length(L1, X),
    append(L1, _, L).


% Si no hay elementos y maxC -1
cardsSet([],NumE,-1,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,CS).

% Si no hay elementos y maxC especificado
cardsSet([],NumE,MaxC,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,L),
    maximoCartas(NumE,MaxC,L,CS).

% Si hay elementos y maxC -1
cardsSet(Elements,NumE,-1,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,CS).

% Si hay elementos y maxC especificado
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,L),
    maximoCartas(NumE,MaxC,L,CS).


%% cardsSetIsDobble(CS):-
%%     CS
%%
cardsSetNthCard(CS,X,CS1):-
    nth0(X,CS,CS1).

cardsSetFindTotalCards(C2,FTC):-
    length(C2,X),
    cardsSet(E,X,-1,Seed,CS),
    length(CS,FTC).

cardsSetMissingCards(CS,MS):-
    length(CS,X),
    cardsSet(E,X,-1,Seed,CS1),
    subtract(CS1,CS,MS).

% Parte de CardsSetToString
cardsSetToString(CS,CSout):-
    printListOfList(CS,1,L1),
    removerDup(L1,L2),
    headOut(L2,CSout).

headOut([L|X],Xout):-
    atomics_to_string(X," ",Xout).

removerDup(L,X):-
    flatten(L,L1),
    sort(L1,X).
printListOfList([],I,STR).
printListOfList([H|T],I,[STR5|STR]) :-
    number_string(I,Contador),
    printList(H,STR1),
    string_concat("Carta ",Contador,STR2),
    string_concat(STR2,": ",STR3),
    string_concat(STR3,STR1,STR4),
    string_concat(STR4, "\n",STR5),
    I1 is I + 1,
    printListOfList(T,I1,STR).
printList(L,STR) :-
    atomics_to_string(L," ",STR).
%
%%%%%% TDA GAME %%%%%%%

dobbleGame(NumPlayers,CardsSet,Mode,Seed,[NumPlayers,CardsSet,Mode,Seed]).

dobbleGameRegister(User,GameIn,[[User]|GameIn]):-
    dobbleGame(INT,_,_,_,GameIn),!.

%dobbleGameRegister(User,GameIn,[User|GameIn]):-
%existe([N,_], [[N,_]|_]):- !.
%existe(U,[_|Us]):- existe(U,U2).

dobbleGameRegister(User,[[X|Y]|GameIn],[[User,X|Y]|GameIn]):- !.

dobbleGameWhoseTurnIsIt(Game,Username).
