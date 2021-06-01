
%convertBinToDec(Bin, Dec).
conHelper(0, _ , 0).
conHelper(Bin, Multi, Dec):- X = Bin mod 10,
							 D1 = (X * 2^Multi) ,
							 Multi1 = (Multi + 1),
							 Bin1 = (Bin // 10),
							 Dec1 = (Dec + D1),
							 conHelper(Bin1, Multi1, Dec1).



convertBinToDec(Bin, Dec):- conHelper(Bin, 0, Dec).