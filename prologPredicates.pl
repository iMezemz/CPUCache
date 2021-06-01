
%convertBinToDec(Bin, Dec).




conHelper(Bin, Multi, Dec):- X is (Bin mod 10),
							 M is 2 ** Multi,
							 D1 is (X * M) ,
							 Multi1 is (Multi + 1),
							 Bin1 is (div(Bin, 10)),
							 Dec is (D1 + Dec1),
							 conHelper(Bin1, Multi1, Dec1).

conHelper(0, _ , 0).
							 
convertBinToDec(Bin, Dec):- conHelper(Bin, 0, Dec).


%replaceIthItem(Item, List, Index, Result). 

repHelper(_, [], _, []).
repHelper(Item, [H|T], I, [H|Ta]):-  I \= 0,I1 is I-1, repHelper(Item, T, I1, Ta).
repHelper(Item, [H|T], I, [Item|Ta]):-  I == 0,I1 is I-1, repHelper(Item, T, I1, Ta).


replaceIthItem(Item, List, Index, Result):- repHelper(Item, List, Index, Result).

%splitevery(N, List, Res).

splitHelper(_, _, [], AccList, [Result|AccList]).

splitHelper(N, Na, [H|T], [H|T1], Result):- Na1 is Na - 1, 
											splitHelper(N, Na1, T, T1, Result).
											
splitHelper(N, 0, [H|T], AccList, [AccList|T1]):- 
											     splitHelper(N, N,[H|T], [], T1).
											
											
splitEvery(N, List, Result):- splitHelper(N, N, List, [], Result).
