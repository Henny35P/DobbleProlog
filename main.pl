%% TDA CARDSET
%% Para ver todas las cartas
%% set_prolog_flag(answer_write_options,[max_depth(0)]).
%%


 %%% -------------- Creacion de Mazo --------------
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

borrar(_, [], []).
borrar(X, [X|T], L):-
    borrar(X, T, L), !.
borrar(X, [H|T], [H|L]):-
    borrar(X, T, L ).

partir([], _, []):- !.
partir(L, X, [H|T]) :-
   length(H, X),
   append(H, LT, L),
   partir(LT, X, T).


% Remplaza en una carta por elem
reemplazo(_, _, [], []).
%% reemplazo(I, [H|T], L, []):-
%%     reemplazo()
reemplazo(I, O, [I|T], [O|T2]) :-
    reemplazo(I, O, T, T2).
reemplazo(I, O, [H|T], [H|T2]) :-
    dif(H,I), reemplazo(I, O, T, T2).


% Remplaza en todas las cartas por elem
elemIn([],_,_,Lout):-!.
elemIn(_,[],_,Lout):- !.
elemIn(CS,[H|X],I,[Lout|L1]):-
    reemplazo(I,H,CS,Lout),
    I1 is I + 1,
    elemIn(Lout,X,I1,L1).
reversar([_|X],L):-
    reverse(X,L).
cabeza([H|T],H).

agregarElementos(CS,Elements,CSout):-
    elemIn(CS,Elements,1,L),
    reversar(L,L1),
    cabeza(L1,CSout).


mazoCartas(N,L):-
    crearPrimera(N,L1),
    nCartas(N,N,L2),
    n2Cartas(N,N,L3),
    append(L1,L2,L4),
    append(L4,L3,L5),
    flatten(L5,L6),
    borrar(0,L6,L7),
    X is N + 1,
    partir(L7,X,L), !.

maximoCartas(_,_,_,[],L):-
    L = [], !.
maximoCartas(NumE,X,I,[H|T],[H|L]):-
    X < I, L = [],!.
maximoCartas(NumE,X,I,[H|T],[H|L]):-
    X >= I,
    I1 is I + 1,
    maximoCartas(NumE,X,I1,T,L).



 %%% -------------- Creacion de Mazo --------------

% Si no hay elementos y maxC -1
cardsSet([],NumE,-1,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,CS),!.

% Si no hay elementos y maxC especificado
cardsSet([],NumE,MaxC,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,L),
    maximoCartas(NumE,MaxC,2,L,CS).

% Si hay elementos y maxC -1
cardsSet(Elements,NumE,-1,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,CS1),
    flatten(CS1,CS2),
    agregarElementos(CS2,Elements,CS3),
    partir(CS3,NumE,CS).


% Si hay elementos y maxC especificado
cardsSet(Elements,NumE,MaxC,Seed,CS):-
    N is NumE - 1,
    mazoCartas(N,CS1),
    flatten(CS1,CS2),
    agregarElementos(CS2,Elements,CS3),
    partir(CS3,NumE,CS4),
    maximoCartas(NumE,MaxC,2,CS4,CS).


cardsSetNthCard(CS,X,CS1):-
    nth0(X,CS,CS1).

cardsSetFindTotalCards(C2,FTC):-
    length(C2,X),
    cardsSet(E,X,-1,Seed,CS),
    length(CS,FTC).

cardsSetMissingCards([H|CS],MS):-
    length(H,X),
    cardsSet(E,X,-1,Seed,CS1),
    subtract(CS1,[H|CS],MS).

% Parte de CardsSetToString
cardsSetToString(CS,CSout):-
    printListOfList(CS,1,L1),
    removerDup(L1,L2),
    headOut(L2,CSout).

headOut([L|X],Xout):-
    atomics_to_string(X," ",Xout).
% Fin parte cardsSetToString
removerDup(L,X):-
    flatten(L,L1),
    sort(L1,X).
printListOfList([],I,STR).
printListOfList([H|T],I,[STR4|STR]) :-
    number_string(I,Contador),
    printList(H,STR1),
    string_concat("Carta ",Contador,STR2),
    string_concat(STR2,": ",STR3),
    string_concat(STR3,STR1,STR4),
    I1 is I + 1,
    printListOfList(T,I1,STR).
printList(L,STR) :-
    atomics_to_string(L," ",STR).
%
%%%%%% TDA GAME %%%%%%%

dobbleGame(NumPlayers,CardsSet,Mode,Seed,[NumPlayers,CardsSet,Mode,Seed]).

dobbleGameRegister(User,GameIn,[[User]|GameIn]):-
    dobbleGame(INT,_,_,_,GameIn),!.


dobbleGameRegister(User,[[X|Y]|GameIn],[[User,X|Y]|GameIn]):-
    User \= X,
    numeroJugador([[X|Y]|GameIn],Int),
    cantidad([[X|Y]|GameIn],Players),
    Int > Players.

numeroJugador([Players|X],Y):-
    nth0(0,X,Y).


cantidad([X|Game],Int):-
    length(X,Int).



dobbleGamePlay(Game,null,GameOut):-
    dobbleGameRegister(_,Y,Game).

dobbleGamePlay(Game,Action,GameOut):-
