-- unary decimal to character
dec2char :: Int -> Char
dec2char n = head [c | (i, c) <- zip [0..9] ['0'..'9'], n==i]
-- tokenize number 1 by 1 into list
tokenizeNum :: Int -> [Int]
tokenizeNum n = [((n `mod` 10^d) - (n `mod` 10^(d-1))) `quot` 10^(d-1) | d <- [l, l-1..1]]
                where l = numLength n
-- convert integer to string
int2string :: Int -> [Char]
int2string n = [c | c <- [dec2char m | m <- tokenizeNum n]]