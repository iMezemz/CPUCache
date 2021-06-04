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

%-----------------------------------------------------------

%splitEvery(N, List, Res).

splitEvery(_, [], []).
splitEvery(N, List,[H|T]):- append(H, L2, List), 
							length(H, N),
							splitEvery(N, L2, T).
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


%getDataFromCache(StringAddress, Cache, Data, HopsNum, setAssoc, SetsNum)



																	
getDataFromCache(StringAddress, [item(tag(Tag), data(D), VB, Order)|T], Data, HopsNum, setAssoc, SetsNum):-

%- index indicates the set number 
% hops represtent set we are standing in when retrieving data
%when removing index bits from the StringAddress we must save the index bits to indicate the set that is data should be found in

%1) remove index and save idx, save tag as is, and split the list every "SetNum"th element 2) according to index go to the subset, 3) Hops = Idx number											
																													
																													%comments as to show values in example 1, all helper methods were trailed and resulted in the values below.
																													
																													%
																													
																													
																													
																													logBase2(SetsNum, IdxBits), %IdxBits = 1 bit
																													
																													
																													string_length(StringAddress, L), % 6
																													L1 is L-IdxBits, %L1 = 5,
																													
																													
																													sub_string(StringAddress, L1 , IdxBits, _ , IdxString), %IdxString = "1"
																													sub_string(StringAddress, 0, L1, _, StringTag), %StringTag = "00000"
																													number_string(Idx, IdxString),
																													
																													splitEvery(SetsNum, [item(tag(Tag), data(Data), VB, Order)|T], ResList), % split the list to different sets
																													nth0(Idx, ResList, Set), %- we are now standing in the correct set that should contain the data
																													
																													
																													
																													
																													
																													
	
																													
																													tagCompareHelper(StringTag, Set, Data), %Data = 11000
																													
																													
																													number_string(HopsNum, IdxString). %convert the idx string to number and this nuber should be equal to Hops
																													
																													
																													
																											
%-----------------------------------------------------------
%tagCompareHelper(Tag, List, Data).

%this method compares the TagString to every tag in a cache list and returns data if tag was found and data was valid(valid bit = 1).


tagCompareHelper(H, [item(tag(H), data(Data), 1, _)|T], Data).
tagCompareHelper(X, [item(tag(H), _, _, _)|T], Data):- X\= H, tagCompareHelper(X, T, Data).


								
%-----------------------------------------------------------

%convertAddress(Bin, SetsNum, Tag, Idx, setAssoc).

convertAddress(Bin, SetsNum, Tag, Idx, setAssoc):-  logBase2(SetsNum, IdxBits),
													DivR is (1 * (10 ^ IdxBits)),
													Idx is Bin mod DivR,
													Tag is div(Bin, DivR).
													

%-----------------------------------------------------------																	
																	

%getDataFromCache("000000",[item(tag("00000"),data("10000"),1,1), item(tag("00001"),data("11000"),1,0),item(tag("00010"),data("11100"),0,3),item(tag("00000"),data("11110"),1,0)],Data,HopsNum,setAssoc,2).

