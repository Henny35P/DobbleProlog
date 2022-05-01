%% TDA CARDSET

crearPrimera(N, L):-
  findall(I, between(1, N, I), L).

nCartas_i(N,I,J,L):-
    I = 0,L = [1].
nCartas_i(N,I,J,[Y | Xs]) :-
    I > 0,
    Y is (N * J) + (I + 1),
    I1 is I - 1,
    nCartas_i(N,I1,J,Xs).

nCartas(N,J,L):-
    J = 0, L = [1].
nCartas(N,J,L) :-
    J>0,
    J1 is J - 1,
    nCartas_i(N,N,J,L),
    nCartas(N,J1,Xs).

n2Cartas_k(N,I,J,K,L):-
    K = 0,L = [1].
n2Cartas_k(N,I,J,K,[Y | Xs]) :-
    K > 0,
    Y is (N+2+N*(K-1)+((I-1)*(K-1)+J-1)),
    K1 is K - 1,
    n2Cartas_k(N,I,J,K1,Xs).

n2Cartas_j(N,I.J,L):-
    J = 0, L = [1].
n2Cartas_j(N,I,J,L) :-
    J>0,
    J1 is J - 1 ,
    n2Cartas_k(N,N,J,N,Lout),
    n2Cartas_j(N,I,J1,[Lin|Lout]).


n2Cartas(N,I,L):-
    I = 0, L = [].
n2Cartas(N,I,L) :-
    I>0,
    I1 is I - 1,
    n2Cartas_j(N,N,N,L),
    n2Cartas(N,I1,Xs).
