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
repHelper(Item, [_|T], I, [Item|Ta]):-  I == 0,I1 is I-1, repHelper(Item, T, I1, Ta).


replaceIthItem(Item, List, Index, Result):- repHelper(Item, List, Index, Result).

%-------------------------------------------------------------

%splitEvery(N, List, Res).

splitEvery(_, [], []).
splitEvery(N, List,[H|T]):- append(H, L2, List), 
							length(H, N),
							splitEvery(N, L2, T).
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%Replacing Blocks

%replaceInCache/8

%Direct Mapping
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,directMap,BitsNum):- 
    atom_number(TagString,Tag),atom_number(IdxString,Idx),
    string_concat(TagString,IdxString,StringAddress),
    atom_number(StringAddress,Address),
    convertBinToDec(Address,AddressDecimal),
    replaceIthItem(ItemData,Mem,AddressDecimal,Mem),
    string_length(TagString,ActualTagLength),
    string_length(ItemData,AddressLength),
    AddedZeros is AddressLength - ActualTagLength - BitsNum,
    fillZeros(TagString,AddedZeros,TagInsert),
    convertBinToDec(Idx,IdxDecimal),            
    replaceIthItem(item(tag(TagInsert),data(ItemData),1,0),OldCache,IdxDecimal,NewCache).

%Fully Associative
replaceInCache(Tag,_,Mem,OldCache,NewCache,ItemData,fullyAssoc,_):-
    atom_number(TagString,Tag),
    convertBinToDec(Tag,AddressDecimal),
    replaceIthItem(ItemData,Mem,AddressDecimal,Mem),
    string_length(TagString,ActualTagLength),
    string_length(ItemData,AddressLength),
    AddedZeros is AddressLength - ActualTagLength,
    fillZeros(TagString,AddedZeros,TagInsert),
    incrementAll(OldCache,IncrementedCache),
    firstOccurence(item(_,_,0,_),Index,IncrementedCache),
    replaceIthItem(item(tag(TagInsert),data(ItemData),1,0),IncrementedCache,Index,NewCache).


replaceInCache(Tag,_,Mem,OldCache,NewCache,ItemData,fullyAssoc,_):-
    \+firstOccurence(item(_,_,0,_),_,OldCache),
    atom_number(TagString,Tag),
    convertBinToDec(Tag,AddressDecimal),
    replaceIthItem(ItemData,Mem,AddressDecimal,Mem),
    string_length(TagString,ActualTagLength),
    string_length(ItemData,AddressLength),
    AddedZeros is AddressLength - ActualTagLength,
    fillZeros(TagString,AddedZeros,TagInsert),
    highestOrder(OldCache,MaxOrder),
    incrementAll(OldCache,IncrementedCache),
    firstOccurence(item(_,_,1,MaxOrder),Index,OldCache),
    replaceIthItem(item(tag(TagInsert),data(ItemData),1,0),IncrementedCache,Index,NewCache).
%Set Associative
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,setAssoc,SetsNum):-
    %Obtained Data from Memory, Tag and index are now available as strings as well as binary numbers
    atom_number(TagString,Tag),atom_number(IdxString,Idx),
    string_concat(TagString,IdxString,StringAddress),atom_number(StringAddress,Address),
    convertBinToDec(Address,AddressDecimal),replaceIthItem(ItemData,Mem,AddressDecimal,Mem),
    %Split the Old Cache to Select a certain set in the cache
    splitEvery(SetsNum,OldCache,OldSplittedCache),
    %find the set on which to apply the fully associative poilicy on
    convertBinToDec(Idx,SetIndex),
    replaceIthItem(WorkingSet,OldSplittedCache,SetIndex,OldSplittedCache),
    %Find the first empty slot inside the working set
    firstOccurence(item(_,_,0,_),ReplacingIndex,WorkingSet),
    %Make the tag ready for insertion(by adding zeros)
    string_length(ItemData,AddressLength),string_length(TagString,ActualTagLength),
    getNumBits(SetsNum,setAssoc,OldCache,IndexLength), AddedZeros is AddressLength - IndexLength - ActualTagLength,
    fillZeros(TagString,AddedZeros,TagInsert),incrementAll(WorkingSet,IncrementedSet),
    replaceIthItem(item(tag(TagInsert),data(ItemData),1,0),IncrementedSet,ReplacingIndex,SetInsert),
    replaceIthItem(SetInsert,OldSplittedCache,SetIndex,NewSplittedCache),flatten(NewSplittedCache,NewCache).

replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,setAssoc,SetsNum):-
    %Obtained Data from Memory, Tag and index are now available as strings as well as binary numbers
    atom_number(TagString,Tag),atom_number(IdxString,Idx),
    string_concat(TagString,IdxString,StringAddress),atom_number(StringAddress,Address),
    convertBinToDec(Address,AddressDecimal),replaceIthItem(ItemData,Mem,AddressDecimal,Mem),
    %Split the Old Cache to Select a certain set in the cache
    splitEvery(SetsNum,OldCache,OldSplittedCache),
    %find the set on which to apply the fully associative poilicy on
    convertBinToDec(Idx,SetIndex),
    replaceIthItem(WorkingSet,OldSplittedCache,SetIndex,OldSplittedCache),
    %Find the first empty slot inside the working set
    \+firstOccurence(item(_,_,0,_),_,WorkingSet),
    highestOrder(WorkingSet,MaxOrder),
    firstOccurence(item(_,_,1,MaxOrder),ReplacingIndex,WorkingSet),
    %Make the tag ready for insertion(by adding zeros)
    string_length(ItemData,AddressLength),string_length(TagString,ActualTagLength),
    getNumBits(SetsNum,setAssoc,OldCache,IndexLength), AddedZeros is AddressLength - IndexLength - ActualTagLength,
    fillZeros(TagString,AddedZeros,TagInsert),incrementAll(WorkingSet,IncrementedSet),
    replaceIthItem(item(tag(TagInsert),data(ItemData),1,0),IncrementedSet,ReplacingIndex,SetInsert),
    replaceIthItem(SetInsert,OldSplittedCache,SetIndex,NewSplittedCache),flatten(NewSplittedCache,NewCache).




%Helper Methods for Fully Associative ReplaceInCache
%------------------------------------------------------------------------
%incrementAll(OldList,IncrementedList)                                  %\  
incrementAll([],[]).                                                    %\ 
incrementAll([item(A,B,C,O)|T],Result):-                                %\
                    C == 1,                                             %\
                    Onew is O + 1,                                      %\  
                    incrementAll(T,RestResult),                         %\  
                    append([item(A,B,C,Onew)],RestResult,Result).       %\
incrementAll([item(A,B,C,O)|T],Result):-                                %\
                    C \= 1,                                             %\
                    incrementAll(T,RestResult),                         %\
                    append([item(A,B,C,O)],RestResult,Result).          %\  
%firstOccurence(Item,Index,List)                                        %\  
firstOccurence(Item,0,[Item|_]).                                        %\
firstOccurence(Item,Index,[H|T]):-                                      %\
                    H\=Item,                                            %\
                    firstOccurence(Item,RestIndex,T),                   %\
                    Index is RestIndex + 1.                             %\
%highestOrder(List,MaxOrder)                                            %\
highestOrder([H|T],MaxOrder):- highestOrderHelp([H|T],0,MaxOrder).      %\
highestOrderHelp([],Max,Max).                                           %\
highestOrderHelp([item(_,_,1,O)|T],Acc,Max):-                           %\
                        Acc>=O,                                         %\
                        highestOrderHelp(T,Acc,Max).                    %\
highestOrderHelp([item(_,_,1,O)|T],Acc,Max):-                           %\
                        Acc<O,                                          %\
                        NewAcc = O,                                     %\
                        highestOrderHelp(T,NewAcc,Max).                 %\          
%------------------------------------------------------------------------
%//////////////////////////////////////////////////////////////////////////////

%convertAddress(Bin, SetsNum, Tag, Idx, setAssoc).

convertAddress(Bin, SetsNum, Tag, Idx, setAssoc):-  logBase2(SetsNum, IdxBits),
													DivR is (1 * (10 ^ IdxBits)),
													Idx is Bin mod DivR,
													Tag is div(Bin, DivR).
													

%------------------------------------------------------------																
%getDataFromCache(StringAddress,Cache,Data,Data,setAssoc,SetsNum).

getDataFromCache(StringAddress,Cache,Data,Idx,setAssoc,SetsNum):-
    getNumBits(SetsNum,setAssoc,Cache,IdxBits),																											
    string_length(StringAddress, L),
    L1 is L-IdxBits,
    sub_string(StringAddress, L1 , IdxBits, _ , IdxString),
    sub_string(StringAddress, 0, L1, _, StringTag),
    number_string(Idx, IdxString),
    splitEvery(SetsNum, Cache, SplittedCache),
    nth0(Idx,SplittedCache,WorkingSet),
    nth0(_,WorkingSet,item(tag(StringTag),data(Data),1,_)).																	
%///////////////////////////////////////////////////////////////////////////////