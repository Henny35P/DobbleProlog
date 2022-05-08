% TDA CARDSET
% Para ver todas las cartas
% set_prolog_flag(answer_write_options,[max_depth(0)]).
% Dominio:
% N,I,J,K,I,O,NumE,Seed : INT
% L, L1,LX,X,Xs,Elements : Lista
% Cabeza y Cola  : Cualquier Tipo
%
% Predicados
% seed(INT), aridad = 1
% crearPrimera(Nplano,Carta), aridad = 2
% nCartas_i(Nplano,Int,Int,Carta), aridad = 4
% n2Cartas_k(Nplano,Int,Int,Int,Carta), aridad = 5
% n2Cartas_j(Nplao,Int,Int,Carta), aridad = 4
% n2Cartas(Nplano,Int,Carta), aridad = 3
% borrar(queBorrar,ListaEntrada,ListaSalida), aridad = 3
% partir(NumE,Lista,Mazo), aridad = 3
% remplazo(Int,Element,MazoEntrada,MazoSalida), aridad = 4
% elemIn(MazoEntrada,Elements,Int,MazoSalida), aridad = 4
% reversar(ListaEntrada,ListaReverse), aridad = 2
% cabeza(Lista,cabezaLista),aridad = 2
% agregarElementos(ListaEntrada,Elemets,MazoConElements), aridad = 3
% mazoCartas(Nplano,Mazo), aridad = 2
% maximoCartas(numE,maxC,Int,Mazoentrada,MazoSalida), aridad = 5
% cardsSet(Nplano,numE,maxC,Seed,Mazo), aridad = 5
% cardsSetNthCard(Mazo,Nth,Carta),aridad = 3
% cardsSetFindTotalCards(Carta,NumeroCartas),aridad = 2
% cardsSetMissingCards(MazoIncompleto,MazoRestante),aridad = 2
% cardsSetToString(Mazo,MazoEnString), aridad 2
% headOut(CartaEntrada,SalidaString),aridad = 2
% removerDup(Carta,CartaOrdenada),aridad = 3
% printListOfList(Mazo,Int,MazoSalida),aridad = 3
% printList(Carta,String),aridad = 2
% dobbleGame(NumPlayers,Mazo,ModoJuego,Semilla,SalidaJuego),aridad = 5
% dobbleGameRegister(User,EntradaGame,salidaGame),aridad = 3
% numeroJugador(Game,Int), aridad = 2
% cantidad(Game,numPlayersActuales), aridad =2
%
% Metas Primarias: cardsSet, dobbleGame
% Metas Secundarias: cardsSetNthCard,CardsSetMissingCards,cardsSetToString,dobbleGameRegister
%
% Clausulas
% Reglas
 %%% -------------- Creacion de Mazo --------------
 %
 % Descripcion: Crea la primera carta
crearPrimera(N, L):-
    N1 is N + 1,
  findall(I, between(1, N1, I), L).

% Descripcion: Crea Carta de acuerdo a algoritmo
nCartas_i(N,I,J,L):-
    I = 0,L = [1].
nCartas_i(N,I,J,[Y | Xs]) :-
    I > 0,
    Y is (N * J) + (I + 1),
    I1 is I - 1,
    nCartas_i(N,I1,J,Xs).

% Descripcion: Llama funcion de crear carta recursivamente (Primeras cartas)
nCartas(N,J,L):-
    J = 0, !.
nCartas(N,J,[Xs,L]) :-
    J>0,
    J1 is J - 1,
    nCartas_i(N,N,J,L),
    nCartas(N,J1,Xs).

% Descripcion: Crea carta segun algoritmo
n2Cartas_k(N,I,J,K,L):-
    I1 is I + 1,
    K = 0,L = [I1].
n2Cartas_k(N,I,J,K,[Y | Xs]) :-
    K > 0,
    Y is (N+2+N*(K-1)+(((I-1)*(K-1)+J-1)mod N)),
    K1 is K - 1,
    n2Cartas_k(N,I,J,K1,Xs).

% Descripcion: Llamara recursivamente a n2Cartas_K, generando cartas
n2Cartas_j(N,I,J,_):-
    J = 0.
n2Cartas_j(N,I,J,[Y|[L]]):-
    J > 0,
    n2Cartas_k(N,I,J,N,L),
    J1 is J - 1,
    n2Cartas_j(N,I,J1,Y).



% Descripcion: Llama recursivamente a n2Cartas, generando el resto del mazo
n2Cartas(N,I,_):-
    I = 0.
n2Cartas(N,I,[Y|L]):-
    I > 0,
    n2Cartas_j(N,I,N,L),
    I1 is I- 1,
    n2Cartas(N,I1,Y).

 % Descripcion: Borrara datos basura del mazo
borrar(_, [], []).
borrar(X, [X|T], L):-
    borrar(X, T, L), !.
borrar(X, [H|T], [H|L]):-
    borrar(X, T, L ).

% Descripcion: Partira el mazo segun el numero de elementos
partir([], _, []):- !.
partir(L, X, [H|T]) :-
   length(H, X),
   append(H, LT, L),
   partir(LT, X, T).


% Descripcion: Remplaza en carta numero por elementos
reemplazo(_, _, [], []).
reemplazo(I, O, [I|T], [O|T2]) :-
    reemplazo(I, O, T, T2).
reemplazo(I, O, [H|T], [H|T2]) :-
    dif(H,I), reemplazo(I, O, T, T2).


% Descripcion: Remplaza en todas las cartas por elem
elemIn([],_,_,Lout):-!.
elemIn(_,[],_,Lout):- !.
elemIn(CS,[H|X],I,[Lout|L1]):-
    reemplazo(I,H,CS,Lout),
    I1 is I + 1,
    elemIn(Lout,X,I1,L1).

% Descripcion: Dara vuelta lista, para facilitar salida
reversar([_|X],L):-
    reverse(X,L).

% Descripcion: Saco la salida de mazo con elementos
cabeza([H|T],H).

% Descripcion: Combina los 3 predicados anteriores
agregarElementos(CS,Elements,CSout):-
    elemIn(CS,Elements,1,L),
    reversar(L,L1),
    cabeza(L1,CSout).



% Descripcion: Predicado que generara el mazo ordenado con numeros
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

% Descripcion: Reordena mazo segun numero de cartas ingresados por usuario
maximoCartas(_,_,_,[],L):-
    L = [], !.
maximoCartas(NumE,X,I,[H|T],[H|L]):-
    X < I, L = [],!.
maximoCartas(NumE,X,I,[H|T],[H|L]):-
    X >= I,
    I1 is I + 1,
    maximoCartas(NumE,X,I1,T,L).



 %%% -------------- Creacion de Mazo --------------

% Constructor
% Descripcion: Predicado que generara el mazo segun
% lo que usuario ingrese, llama a otros predicados anteriores
%
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

% Selector
% Descripcion: Buscara la nth card del mazo
cardsSetNthCard(CS,X,CS1):-
    nth0(X,CS,CS1).
% Otras Funciones
% Descripcion: Busca la cantidad de cartas totales segun una carta
cardsSetFindTotalCards(C2,FTC):-
    length(C2,X),
    cardsSet(E,X,-1,Seed,CS),
    length(CS,FTC).


% Otras Funciones
% Descripcion: Busca las cartas que faltan para un mazo valido
cardsSetMissingCards([H|CS],MS):-
    length(H,X),
    cardsSet(E,X,-1,Seed,CS1),
    subtract(CS1,[H|CS],MS).

% Parte de CardsSetToString
% Selector
% Descripcion: Transforma el mazo a strings
cardsSetToString(CS,CSout):-
    printListOfList(CS,1,L1),
    removerDup(L1,L2),
    headOut(L2,CSout).

% Descripcion: Transforma una carta  a string
headOut([L|X],Xout):-
    atomics_to_string(X," ",Xout).
% Fin parte cardsSetToString
%
% Descripcion: Remueve datos basura
removerDup(L,L2):-
    flatten(L,L1),
    sort(L1,L2).

% Descripcion: Formatera el mazo en strings segun su numero de carta
printListOfList([],I,STR).
printListOfList([H|T],I,[STR4|STR]) :-
    number_string(I,Contador),
    printList(H,STR1),
    string_concat("Carta ",Contador,STR2),
    string_concat(STR2,": ",STR3),
    string_concat(STR3,STR1,STR4),
    I1 is I + 1,
    printListOfList(T,I1,STR).

% Descripcion: Agregara un espacio a las cartas
printList(L,STR) :-
    atomics_to_string(L," ",STR).
%
%%%%%% TDA GAME %%%%%%%

%% Constructor
% Descripcion: Predicado constructor, Generara el juego
dobbleGame(NumPlayers,CardsSet,Mode,Seed,[NumPlayers,CardsSet,Mode,Seed]).


% Descripcion: Se agregara usuarios al juego
% Modificador

dobbleGameRegister(User,GameIn,[[User]|GameIn]):-
    dobbleGame(INT,_,_,_,GameIn),!.


dobbleGameRegister(User,[[X|Y]|GameIn],[[User,X|Y]|GameIn]):-
    User \= X,
    numeroJugador([[X|Y]|GameIn],Int),
    cantidad([[X|Y]|GameIn],Players),
    Int > Players.

dobbleGameRegister(User,[[X|Y]|GameIn],[[X|Y]|GameIn]):-
    User \= X,
    numeroJugador([[X|Y]|GameIn],Int),
    cantidad([[X|Y]|GameIn],Players),
    Int < Players, false.


% Selector
% Descripcion: Busca cuantos jugadores maximos pueden haber
numeroJugador([Players|X],Y):-
    nth0(0,X,Y).

% Descripcion: Cuantos usuarios hay ingresados en el momento
cantidad([X|Game],Int):-
    length(X,Int).



dobbleGamePlay(Game,null,GameOut):-
    dobbleGameRegister(_,Y,Game).

dobbleGamePlay(Game,Action,GameOut).


%%% Ejemplos Predicados %%%
%%%
%%% CardsSet
%cardsSet(A,7,-1,Seed,CS).
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS).
%cardsSet(A,7,4,Seed,CS).
%%% cardsSetNthCard
%cardsSet(A,7,-1,Seed,CS),cardsSetNthCard(CS,0,CS1).
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS),cardsSetNthCard(CS,5,CS1).
%cardsSet(A,7,4,Seed,CS),cardsSetNthCard(CS,3,CS1).
%%% cardsSetFindTotalCards
%cardsSetFindTotalCards([1,2,3,4],CS).
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS),cardsSetNthCard(CS,5,CS1),cardsSetFindTotalCards(CS1,CS2).
%cardsSet(A,7,4,Seed,CS),cardsSetNthCard(CS,3,CS1),cardsSetFindTotalCards(CS1,CS2).
%%% cardsSetMissingCards
%cardsSetMissingCards([[1,2,3,4],[7,6,5,1]],CS2).
%cardsSet(A,7,3,Seed,CS),cardsSetMissingCards(CS,CS1).
%cardsSet(A,7,-1,Seed,CS),cardsSetMissingCards(CS,CS1).
%%% cardsSetToString
%cardsSet(A,7,-1,Seed,CS),cardsSetToString(CS,CS1).
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS),cardsSetToString(CS,CS1).
%cardsSet(A,7,4,Seed,CS),cardsSetToString(CS,CS1).
%%% dobbleGame
%cardsSet(A,7,-1,Seed,CS),dobbleGame(4,CS,"STACK",Seed,G).
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS),dobbleGame(2,CS,"STACK",Seed,G).
%cardsSet(A,7,4,Seed,CS),dobbleGame(3,CS,"STACK",Seed,G).
%%%
%%%
%cardsSet(["A","B","C","D","E","F","G","H","I"],3,-1,Seed,CS),dobbleGame(2,CS,"STACK",Seed,G),dobbleGameRegister("DIINF",G,G1),dobbleGameRegister("Prolog",G1,G2).
% Falso ya que se repiten usuarios
%cardsSet(A,7,-1,Seed,CS),dobbleGame(4,CS,"STACK",Seed,G),dobbleGameRegister("DIINF",G,G1),dobbleGameRegister("DIINF",G1,G2).
%Regresa Falso ya que no pueden haber mas jugadores
%dobbleGame(3,CS,"STACK",Seed,G),dobbleGameRegister("DIINF",G,G1),dobbleGameRegister("Prolog",G1,G2),dobbleGameRegister("USACH",G2,G3),dobbleGameRegister("LLENO",G3,G4).
