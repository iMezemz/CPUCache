%General predicates

%convertBinToDec/2
convertBinToDec(Bin,Dec):-
                            binToDecHelp(Bin,0,Dec).
binToDecHelp(0,_,0).
binToDecHelp(Bin,Multiplier,Dec):-
                                    Bin\=0,
                                    Dig1 is Bin mod 10,
                                    Rest is div(Bin,10),
                                    NewMult is Multiplier + 1,
                                    binToDecHelp(Rest,NewMult,RestDec),
                                    Dec is RestDec + Dig1*(2^Multiplier).

%-----------------------------------------------------------                                    

%logBase2/2
logBaseHelp(Num,Acc,Acc):- Num is 2^Acc.
logBaseHelp(Num,Acc,Res):- Pow2 is 2^Acc,
                    Num > Pow2,
                    Acc1 is Acc+1,
                    logBaseHelp(Num,Acc1,Res).
logBase2(Num,Res):- logBaseHelp(Num,0,Res).   

%-----------------------------------------------------------

%getNumBits/4
getNumBits(_,fullyAssoc,[_|_],0).
getNumBits(NumOfSets,setAssoc,Cache,Res):-
                                    length(Cache,L),
                                    L1 is div(L,NumOfSets),
                                    logBase2(L1,Res).
getNumBits(_,directMap,Cache,Res):-
                                    length(Cache,L),
                                    logBase2(L,Res).

%-----------------------------------------------------------

%fillZeros/3
fillHelp(String,0,Acc,R):-
                        string_concat(Acc,String,R).

fillHelp(String,N,Acc,R):-
                        N\=0,
                        N1 is N-1,
                        string_concat("0",Acc,NewAcc),
                        fillHelp(String,N1,NewAcc,R).                        

fillZeros(String,N,R):- fillHelp(String,N,"",R).

%-----------------------------------------------------------

%replaceIthItem(Item, List, Index, Result). 

repHelper(_, [], _, []).
repHelper(Item, [H|T], I, [H|Ta]):-  I \= 0,I1 is I-1, repHelper(Item, T, I1, Ta).
repHelper(Item, [H|T], I, [Item|Ta]):-  I == 0,I1 is I-1, repHelper(Item, T, I1, Ta).


replaceIthItem(Item, List, Index, Result):- repHelper(Item, List, Index, Result).

%-------------------------------------------------------------

%splitEvery(N, List, Res).

splitEvery(_, [], []).
splitEvery(N, List,[H|T]):- append(H, L2, List), 
							length(H, N),
							splitEvery(N, L2, T).
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\





























































































































%-----------------------------------------------------------

%convertAddress(Bin, SetsNum, Tag, Idx, setAssoc).

convertAddress(Bin, SetsNum, Tag, Idx, setAssoc):-  logBase2(SetsNum, IdxBits),
													DivR is (1 * (10 ^ IdxBits)),
													Idx is Bin mod DivR,
													Tag is div(Bin, DivR).
													

%------------------------------------------------------------																
																	

%getDataFromCache("000000",[item(tag("00000"),data("10000"),1,1), item(tag("00001"),data("11000"),1,0),item(tag("00010"),data("11100"),0,3),item(tag("00000"),data("11110"),1,0)],Data,HopsNum,setAssoc,2).

