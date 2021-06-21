convertBinToDec :: Integral a => a -> a


convertHelper x mult = ((x div 10) * 1*10^^mult)) + convertHelper(mod x 10) (mult +1)