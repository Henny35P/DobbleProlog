%% TDA CARDSET

crearPrimera(N, L):-
  findall(I, between(1, N, I), L).

nCartas_i(L, H, J) :-
   between(L, H, I),
   Z is I * H + (J+1),
   write(Z), nl.

nCartas(N,L):-
    write(1),nl,
    count_down(1,N,N).
