

%convertBinToDec(Bin, Dec).
conHelper(0, _ , 0).
conHelper(Bin, Multi, Dec):- X is (Bin mod 10),
							 D1 is (X * 2^Multi) ,
							 Multi1 is (Multi + 1),
							 Bin1 is div(Bin, 10),
							 Dec is (D1 + Dec1),
							 conHelper(Bin1, Multi1, Dec1).



convertBinToDec(Bin, Dec):- conHelper(Bin, 0, Dec).