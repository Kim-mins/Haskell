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