







%replaceIthItem(Item, List, Index, Result). 

repHelper(_, [], _, []).
repHelper(Item, [H|T], I, [H|Ta]):-  I \= 0,I1 is I-1, repHelper(Item, T, I1, Ta).
repHelper(Item, [H|T], I, [Item|Ta]):-  I == 0,I1 is I-1, repHelper(Item, T, I1, Ta).


replaceIthItem(Item, List, Index, Result):- repHelper(Item, List, Index, Result).

%splitevery(N, List, Res).

splitEvery(_, [], []).
splitEvery(N, List,[H|T]):- append(H, L2, List), 
							length(H, N),
							splitEvery(N, L2, T).