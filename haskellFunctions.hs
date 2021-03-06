data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)
data Output a = Out (a, Int) | NoOutput deriving (Show, Eq)

--------------------------------- General Predicates -------------------------------------------

convertBinToDec :: Integral a => a -> a
convertBinToDec 0 = 0
convertBinToDec n = 2 * convertBinToDec (div n 10) + (mod n 10)

logBase2 :: Floating a => a -> a
logBase2 x = log x / log 2

-- getNumBits :: (Integral a, RealFloat a1) => a1 -> [Char] -> [c] -> a
getNumBits numOfSets cacheType cache | (cacheType == "fullyAssoc") = 0
                                     | (cacheType == "setAssoc") = logBase2 numOfSets
                                     | (cacheType == "directMap") = logBase2 (fromIntegral(length cache)) 
                                     | otherwise = error "Not a valid mapping type"  

fillZeros :: [Char] -> Int -> [Char]
fillZeros s 0 = s
fillZeros s n = "0" ++ (fillZeros s (n-1))


replaceIthItem _ [] _ = error "Empty List"
replaceIthItem item (h:t) index = if index == 0 then (item:t) else h:(replaceIthItem item t (index-1))


splitEvery _ [] = []
--splitEvery 0 (x:xs) = (x:xs)
splitEvery n list = (first : (splitEvery n rest)) where (first,rest) = (splitAt n list)


--------------------------------- Cache Mapping -------------------------------------------
--getDataFromCache :: (Integral b, Eq a) => [Char] -> [Item a] -> [Char] -> b -> Output a
-- the index inidcates which set ,,,,, 

getIndexFromAddress stringAddress idxBits = read  (reverse((take idxBits (reverse stringAddress)))) :: Int
checkValidity (It (T tag) (D dataString) validity order) = if validity == True then True else False
checkSameTagAndReturnData [] _ = ""
checkSameTagAndReturnData ((It (T tag) (D dataString) validity order): cs) tagToCheck | tagToCheck == tag = dataString
																					  | otherwise = checkSameTagAndReturnData cs tagToCheck
returnData 	(It (T tag) (D dataString) validity order) = dataString

checkSameTag (It (T tag) (D dataString) validity order) tagToCheck = if tagToCheck == tag then True else False

getDataFromCache address ((It (T tag) (D dataString) validity order ): cs ) mappingType idxBits | mappingType == "setAssoc" && checkSameTagAndReturnData 
																						 (  filter checkValidity ( 
																						 (splitEvery (2^idxBits) (It (T tag) (D dataString) validity order:cs) )!!(convertBinToDec idx) ))  (read (take ((length address) - idxBits) address) :: Int)
																						   == "" = NoOutput
			
																						  
																						 |  mappingType == "setAssoc" && checkSameTagAndReturnData 
																						 (  filter checkValidity ( 
																						 (splitEvery (2^idxBits) (It (T tag) (D dataString) validity order:cs) )!!(convertBinToDec idx) ))  (read (take ((length address) - idxBits) address) :: Int)
																						   /= ""  = Out( 
																						 checkSameTagAndReturnData 
																						 (  filter checkValidity ( 
																						 (splitEvery (2^idxBits) (It (T tag) (D dataString) validity order:cs) )!!(convertBinToDec idx) ))  (read (take ((length address) - idxBits) address) :: Int)
																						  ,(convertBinToDec idx))
																						  --where idx = (getIndexFromAddress address idxBits)
																						  
																						 | mappingType == "directMap"  && checkValidity ( (It (T tag) (D dataString) validity order:cs)!!(convertBinToDec idx) ) == True && checkSameTag (It (T tag) (D dataString) validity order) (read (take ((length address) - idxBits) address) :: Int) 
																						   = Out (returnData((It (T tag) (D dataString) validity order : cs)!!(convertBinToDec idx)), 0)
																                          
																						   | mappingType == "directMap"  && checkValidity ( (It (T tag) (D dataString) validity order:cs)!!(convertBinToDec idx) ) == False
																						   = NoOutput
																						     
																						   |otherwise = NoOutput
																							where idx = (getIndexFromAddress address idxBits)

--convertAddress :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
convertAddress stringAddress bitsNum typeOfMapping | typeOfMapping == "setAssoc"  || typeOfMapping == "directMap"
											  = ( (div stringAddress (10^bitsNum)), (mod stringAddress (10^bitsNum)) )
											  
											  
											  