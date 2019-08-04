import Data.Char

{-
  Caesar Cipher (for lowercases only)
-}

-- 주어진 Int만큼, String의 각 Char를 Shift한 결과를 내보냄
encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]
-- 주어진 Int만큼, 해당 Char를 shift (alphabet domain)
shift :: Int -> Char -> Char
shift n c | isLower c = int2alpha (((alpha2int c) + n) `mod` 26)
          | otherwise = c
-- map 'a'~'z' to 0~25
alpha2int :: Char -> Int
alpha2int c | isLower c = ord c - ord 'a'
            | otherwise = 0
-- check if Int is Lower alphabet (in 0~25)
isLowerAlpha :: Int -> Bool
isLowerAlpha n = 0 <= n && n < 26
-- map 0~25 to 'a'~'z'
int2alpha :: Int -> Char
int2alpha n | isLowerAlpha n = chr (n + ord 'a')
            | otherwise = '_'

-- Decode Caesar Cipher with brute-force
-- Input: String
--   cipher text
-- Output: String
--   candidates (for plain text)
decode :: String -> [String]
decode ct = [decipher n ct | n <- [0..25] ]
-- decipher cipher text with given Int
decipher :: Int -> String -> String
decipher n ct = encode n ct


-- Decode Caesar Cipher with probability
-- table contains frequency of each alphabet in order
table :: [Float]
table = [8.2, 1.5, 2.8, 4.3, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.1, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]
-- 주어진 List에 대해, 주어진 원소와 같은 요소의 개수를 셈
count :: Eq a => a -> [a] -> Int
count x xs = length [x' | x' <- xs, x == x']
-- count Lowercase letters
lowers :: String -> Int
lowers cs = length [c | c <- cs, isLower c]
-- returns percentage with given integers
percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100
-- 주어진 문자열에 대해, 해당 문자열의 lowercase letter들의 빈도율 계산
freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x <- ['a'..'z']]
           where n = lowers xs
-- o(observed)와 e(expected==table)의 차이가 가장 작은 애를 선정 --> by 카이제곱분포
chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [(o-e)^2 / e | (o, e) <- zip os es]
-- shift n times in xs
rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs
-- List에 주어진 값이 있는 index를 반환
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0..n], x' == x]
  where n = (length xs) - 1
-- 실제로 푸는 함수
crack :: String -> String
crack xs = encode (-factor) xs
  where
    factor = head (positions (minimum chiTab) chiTab)
    chiTab = [chisqr (rotate n table') table | n <- [0..25]]
    table' = freqs xs
