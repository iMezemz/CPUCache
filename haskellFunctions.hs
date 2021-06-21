data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)


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
replaceIthItem :: (Eq a, Num a) => t -> [t] -> a -> [t]
replaceIthItem item (h:t) index | (index == 0)  = [item] ++ t
                                | (index < 0 && h==[]) = error "Invalid Index"
                                | otherwise = [h] ++ replaceIthItem item t (index-1)

