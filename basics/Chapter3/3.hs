{-
  하스켈에서 반복은 recursion을 통해 표현
  간단한 재귀부터 해서 mutual recursion까지.
-}

-- Tail call
{-
  간단한 factorial 함수
  factorial 0 = 1
  factorial n = n * factorial (n - 1)
  --> factorial 3
      3 * factorial 2
      3 * (2 * factorial 1)
      3 * (2 * (1 * factorial 0))
      3 * (2 * (1 * 1))
      3 * (2 * 1)
      3 * 2
      6

  위와 같은 factorial 함수는 n이 매우 클 경우 마지막 단계에서 연산의 길이가 매우 길어짐
  --> stack이 많이 생김

  So, tail recurtion optimization
  필요. --> 이따 배움..
-}

-- Recursion on Lists
{-
  productC :: [Int] -> Int
  productC [] = 1
  productC (n:ns) = n * productC ns

  lengthC :: [a] -> Int
  lengthC [] = 0
  lengthC (x:xs) = 1 + length xs

  reverseC :: [a] -> [a]
  reverseC [] = []
  reverseC (x:xs) = reverseC (xs) ++ [x]

  zipC :: [a] -> [b] -> [(a, b)]
  zipC _ [] = []
  zipC [] _ = []
  zipc (x:xs) (y:ys) = (x, y) : zipC xs ys

  dropC :: Int -> [a] -> [a]
  dropC 0 xs = xs
  dropC _ [] = []
  drop n (x:xs) = drop (n-1) xs

  (++) :: [a] -> [a] -> [a]
  xs ++ [] = xs
  xs ++ (y:ys) = xs ++ y (++ ys)
-}

-- Quick sort
{-
  qsort :: Ord a => [a] -> [a]
  qsort [] = []
  qsort (x:xs) = qsort [y | y <- xs, y <= x] ++ [x] ++ qsort [z | z <- xs, x < z]
-}

-- Mutual recursion
{-
  서로 다른 두 개의 함수가 상호 간 재귀를 이용해 정의
  ex)
    evenC :: Int -> Bool
    evenC 0 = True
    evenC n = oddC (n - 1)
    oddC :: Int -> Bool
    oddC 0 = False
    oddC n = evenC (n - 1)
    -- 짝수, 홀수 번 째 원소를 돌려주는 함수
    evens :: [Int] -> [Int]
    evens [] = []
    evens (x:xs ) = x : odds xs
    odds :: [Int] -> [Int]
    odds [] = []
    odds (x:xs) = even xs
-}

-- Advice on Recursion
{-
  init 함수를 예시로..

  1. define the type
    init :: [a] -> [a]
  2. enumerate cases
    init (x:xs) 
  3. define the simple case
    init (x:xs) | null xs = []
                | otherwise = 
  4. define the other cases
    init (x:xs) | null xs = []
                | otherwise = x : init xs
  5. generalize and simplify
    init :: [a] -> [a]
    init [_] = []     -- 원소가 하나만 있을 때 인듯..
    init (x:xs) = x : init xs
-}

-- Examples
{-
  1. 곱셈 연산
    (*) :: Num a => a -> a -> a
    (*) x 0 = 0
    (*) x y = x + ((*) x (y - 1))
  2. insert 함수, insertion sort
    insert :: Ord a => a -> [a] -> [a]
    insert n [] = [n]
    insert n (x:xs) | n > x = x : insert n xs
                    | otherwise = n : x : xs
    isort :: [a] -> [a]
    isort [] = []
    isort (x:xs) = insert x (isort xs)
  3. merge sort
    merge :: Ord a => [a] -> [a] -> [a]
    merge [] ys = ys
    merge xs [] = xs
    merge (x:xs) (y:ys) | x <= y = x : merge xs (y:ys)
                        | otherwise = y : merge (x:xs) ys
    halve :: [a] -> ([a], [a])
    halve xs = splitAt (length xs `div` 2) xs

    msort :: Ord a => [a] -> [a]
    msort [] = []
    msort [x] = [x]
    msort xs = merge (msort ys) (msort zs)
               where (ys, zs) = halve xs
-}

-- Higher-order function
{-
  함수를 인자로 받아서 다시 함수를 돌려 주는 함수를 말함
  ex)
    twice :: (a -> a) -> a -> a
    twice f x = f (f x)

  이런 Higher-order function(고차함수)가 언제 유용?
    1. Common programming idioms can be encoded as functions within the language itself.
    2. Domain specific languages can be defined as collections of higher-order functions.
    3. Algebraic properties of higher-order functions can be used to reason about programs.
-}

-- map
{-
  map :: (a -> b) -> [a] -> [b]
  map (+1) [1, 3, 5, 7] -- [2, 4, 6, 8]
  or..
  map :: (a -> b) -> [a] -> [b]
  map f [] = []
  map f (x:xs) = (f x) : map f xs
-}

-- filter
{-
  predicate를 만족하는 원소만 골라 줌
  filter :: (a -> Bool) -> [a] -> [a]
  filter even [1..10] -- [2, 4, 6, 8, 10]
-}

-- foldr
{-
  f [] = v
  f (x:xs) = x pred f xs
  --> 빈 원소면 특정 값 v를 주고, 아니라면 x에 pred를 적용하고 나무지 tail xs에는 f를 적용

  -- v = 0, pred = +
  sum [] = 0
  sum (x:xs) = x + sum xs

  -- v = 1, pred = *
  product [] = 1
  product (x:xs) = x * product xs

  -- v = True, pred = &&
  and [] = True
  and (x:xs) = x && and xs

  So, 이렇게 foldr을 이용해 정의
  sum = foldr (+) 0
  product = foldr (*) 1
  or = foldr (||) False
  and = foldr (&&) True

  foldr의 정의?
  foldr :: (a -> b -> b) -> b -> [a] -> b
  foldr f v [] = v
  foldr f v (x:xs) = f x (foldr f v xs)

  length도 foldr로 정의 가능
  length = foldr (\_ n -> n + 1) 0  -- \_ n은 2개의 인자를 받는 lambda 함수

  filter :: (a -> Bool) -> [a] -> [a]
  filter p xs = foldr (\x acc -> if p x then x : acc else acc) [] xs

  map :: (a -> b) -> [a] -> [b]
  map p xs = foldr (\x acc -> p x : acc) [] xs

  foldr의 장점?
    1. list에 대한 recursive function을 더 쉽게 정의 가능 (ex. sum)
    2. Properties of functions defined using foldr can ben proved using algebraic properties of foldr, such as fusion and the banana split rule.
    3. Advanced program optimizations can be simpler if foldr is used in place of explicit recursion.
    --> fusion: foldr을 통해 얻을 수 있는 두 가지 함수
          1. 한 리스트를 traverse하고, 다른 list를 return함
          2. 그 return된 리스트에 다른 foldr을 적용하면, 중간에 새로운 리스트를 만들지 않고 바로 계산 --> optimization
-}

-- composition
{-
  (.)은 함수를 합성 해줌. (합성 함수 생각)
  (.) :: (b -> c) -> (a -> b) -> (a -> c)
  f . g = \x -> f(g x)
  ex)
    odd :: Int -> Bool
    odd = not . even
-}

-- all, any
{-
  all은 모든 원소에 대해 p를 적용한 결과가 참인지를 돌려줌
  all :: (a -> Bool) -> [a] -> Bool
  all p xs = and [p x | x <- xs]
  -- same as
  all :: (a -> Bool) -> [a] -> Bool
  all p xs = foldr (\x acc -> px && acc) True xs


  import Data.Char

  any :: (a -> Bool) -> [a] -> Bool
  any p xs = or [p x | x <- xs]
  -- same as
  any p xs = or (map p xs)
-}

-- takeWhile, dropWhile
{-
  takeWhile은 predicate가 참인 원소까지만 돌려줌
  takeWhile :: (a -> Bool) -> [a] -> [a]
  takeWhile p [] = []
  takeWhile p (x:xs) | p x = x : takeWhile p xs
                     | otherwise = []
  dropWhile은 predicate가 참인 원소까지만 버리고 나머지를 돌려줌
  dropWhile :: (a -> Bool) -> [a] -> [a]
  dropWhile p [] = []
  dropWhile p (x:xs) | p x = dropWhile p xs
                     | otherwise = (x:xs)
-}

-- church Numerals
{-
  z: zero
  s: successor function (s :: Int -> Int)

  zero = \s z -> z
  one = \s z -> s z
  two = \s z -> s (s z)

  -- same as
  two = \s z -> (s . s) z

  -- remove z
  two = \s -> s . s

  -- church to int
  c2i x = x (+1) 0

  c2i zero -- 0
  c2i one -- 1
  c2i two -- 2

  -- *의 개수로 숫자를 정의한다고 하면..
  c2s x = x ('*' :) ''

  c2s zero -- ""
  c2s one -- "*"
  c2s two -- "**"

  x' = c2i x
  y' = c2i y
  라고할 때,
  x' + y' = c2i (add x y)
  
  왜?
  x' + y'
  = c2i x + c2i y
  = x (+1) 0 + c2i y
  = x (+1) (c2i y)
  = x (+1) (y (+1) 0)
  = (\s z -> x s (y s z)) (+1) 0 -- by beta expension

  so, add는..
  add x y = \s z -> x s (y s z)
  c2i (add one two) -- 3

  곱셈은?
  two = \s -> s . s
  three = \s -> s . s . s
  
  mul = \s z -> x (y s) z

  c2i (mul two five) -- 10


  id :: a -> a
  id = \x -> x

  compose :: [a -> a] -> (a -> a)
  compose = foldr (.) id
-}

-- String Transmitter
{-
  간단한 문자열 전송을 모델링한 코드

  import Data.Char

  type Bit = Int

  bin2int :: [Bit] -> Int
  bin2int bits = sum [w * b | (w, b) <- zip weights bits]
    where weights = iterate (*2) 1
  -- or
  -- bin2int bits = foldr (\x acc -> x + acc * 2) 0

  int2bin :: Int -> [Bit]
  int2bin 0 = []
  int2bin n = n `mod` 2 : int2bin(n `div` 2)

  make8 :: [Bit] -> [Bit]
  make8 bits = take 8 (bits ++ repeat 0)

  encode :: String -> [Bit]
  encode = concat . map (make8 . int2bin . ord)

  chop8 :: [Bit] -> [[Bit]]
  chop8 [] = []
  chop8 bits = take 8 bits : chop8 (drop 8 bits)

  decode :: [Bit] -> String
  decode = map (chr . bin2int) . chop8

  channel :: [Bit] -> [Bit]
  channel = id

  transmit :: String -> String
  transmit = decode . channel . encode
-}