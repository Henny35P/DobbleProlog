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
