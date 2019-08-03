main =
  -- List Comprehension
  {-
    old list로부터 new list를 만드는 법
    ex)
      [x^2 | x <- [1..3]] -- [1, 4, 9]
      --> 여기서 [1..3]같은 exp를 generator라고 부름
      
    comprehension은 한 개 이상의 generator를 가질 수 있음
    ex)
      [(x, y) | x <- [1..3], y <- [4..5]]
      -- [(1,4),(1,5),(2,4),(2,5),(3,4),(3,5)]
      [(x, y) | y <- [4..5], x <- [1..3]]
      -- [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)] --> 원소 순서 바꾸기 가능
    앞의 generator를 사용 가능
    ex)
      [(x, y) | x <- [1..3], y <- [x+1]]
      -- [(1, 2), (2, 3), (3, 4)]
      --> y를 dependent generator라고 부름
    dependent generator를 통한 concat 함수 만들기
      concat :: [[a]] -> [a]
      concat xss = [x | xs <- xss, x <- xs]
      --> concat [[1,2,3], [4,5], [6]] --> [1, 2, 3, 4, 5, 6]
  -}

  -- Guards
  {-
    generator에서 변수를 걸러내기 위해 guards를 사용
    ex)
      evens = [x | x <- [1..10], even x] -- [2, 4, 6, 8, 10]
      factors n = [x | x <- [1..n], n `mod` x == 0] -- 약수 구하기
      prime n = factors n == [1, n]
      primes n = [x | x <- [2..n], prime x]
  -}
  
  -- 여러 함수
  {-
    zip 함수는 두 개의 리스트를 받아 하나의 리스트를 만듦.
    :t zip --> zip :: [a] -> [b] -> [(a, b)]
    ex)
      zip [1, 2, 3] ['a', 'b', 'c', 'd']
      --> [(1, 'a'), (2, 'b'), (3, 'c')]  -- 'd'는 사라짐
    
    pairs [] = []
    pairs xs = zip xs (tail xs)
    ex) 
      pairs [1, 2, 3] -- [(1, 2), (2, 3), (3, 4)]

    sorted :: Ord a => [a] -> Bool
    sorted xs = and [x <= y | (x, y) <- pairs xs] -- and는 리스트의 모든 Bool 값을 and연산한 결과를 줌

    리스트에서 주어진 값과 같은 값을 가지는 원소들의 리스트를 구하는 position 함수를 zip으로..
    position x xs = 
      [i | (x', i) <- zip xs [0..n], x == x']
      where n = (length xs) - 1
  -}

  -- String comprehensions
  {-
    문자열은 Char의 리스트이므로, 리스트처럼 사용 가능
    ex) 
      zip "abc" [1,2,3] -- [(a, 1), (b, 2), (c, 3)]
      take 3 "abcabc" -- "abc"
      length "adasd" -- 5
    
    So, list comprehension으로 string 조작 가능

    import Data.Char  -- isLower 사용

    lowers :: String -> Int
    lowers xs = length [x | x <- xs, isLower x]
  -}
  
  -- Caesar cipher
  {-
    import Data.Char
    
    let2int :: Char -> Int
    let2int c = ord c - ord 'a'   -- ord 함수는 캐릭터를 받아 아스키 숫자 반환

    int2let :: Int -> Char
    int2let n = chr(n + ord 'a')  -- chr 함수는 그 반대

    주어진 소문자 알파벳을 n번 이동시키는 shift 함수
    shift :: Int -> Char -> Char
    shift n c | isLower c = int2let((let2int c + n) `mod` 26)
              | otherwise = c
  
    shift (-1) 'a' -- 'z'
    shift (3) 'a' -- 'd'

    encode :: Int -> String -> String
    encode n cs = [shift n c | c <- cs]

    encode 1 "abc" -- bcd
    encode 3 "haskell is fun" -- "kdvnhoo lv ixq"
    encode (-3) "kdvnhoo lv ixq" -- "haskell is fun"
  -}

  