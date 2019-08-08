main =
  -- List basic operations
  head [2, 3, 4] -- 2
  tail [2, 3, 4] -- [3, 4]
  head [2] -- [2]
  tail [2] -- []
  -- *** Exception: Prelude.tail: empty list
  tail []
  -- *** Exception: Prelude.head: empty list
  head []
  -- init은 마지막 원소 빼고 인듯 last랑 같이 묶임
  init [2, 3, 4]  -- [2, 3]
  last [2, 3, 4]  -- 4
  -- take는 해당 인덱스 앞까지만의 리스트를 반환, drop은 해당 index값을 포함한 값부터의 리스트를 반환
  take 2 [2, 3, 4] -- [2, 3]
  drop 2 [2, 3, 4] -- [4]
  -- !!을 통해 리스트의 원소에 접근 가능
  [1, 2, 3, 4] !! 1 -- 2
  [1, 2, 3, 4] !! 2 -- 3
  [1, 2, 3, 4, 5] !! 2 -- 3
  [1, 2, 3, 4, 5] !! 0 -- 1
  -- 리스트 첫 요소부터 비교.
  -- 첫 요소가 같을 경우에만, 두 번째 요소를 비교. 아마 계속 하는 듯?
  [1, 2, 3] > [0, 1, 2] -- True
  [1, 2, 3] > [3, 2, 3] -- True --> 맞음
  -- product는 리스트의 모든 요소들을 곱함
  product [1, 2, 3, 4, 5] -- 120
  -- ++는 list concatenation (@)
  [1, 2, 3] ++ [4, 5] -- [1, 2, 3, 4, 5]
  -- :는 list를 붙임(append?)
  1:2:[] -- [1, 2]
  -- reverse는 리스트의 요소를 반대로..
  reverse [1, 2, 3, 4] -- [4, 3, 2, 1]
  -- 리스트가 비었는지 보기
  null [1, 2, 3] -- False
  null [] -- True
  -- min & max
  minimum [8, 4, 2, 1, 5, 6] -- 1
  min 2 4 -- 이건 두 수에 대한 비교 --> 2
  maximum [1, 9, 2, 3, 4] -- 9
  max 9 4 -- 이건 두 수에 대한 비교 --> 9
  -- 리스트에 특정 element가 있는지 보기
  4 `elem` [3, 4, 5, 6] -- True
  4 `notElem` [3, 4, 5, 6] -- False
  -- range
  [1..20] -- [1, 2, 3, 4, ..., 20]
  ['a'..'z'] -- abc..z
  ['K'..'Z'] -- K...Z
  [20..1] -- error
  [20, 19..1] -- [20, 19, ..., 1]
  [0.1, 0.3..1] -- [0.1, 0.3, 0.5, 0.7, 0.899999, 1.099999999]
  -- cycle
  take 10 (cycle [1, 2, 3]) -- [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]
  take 12 (cycle "LoL ") -- "LOL LOL LOL "
  -- repeat
  take 10 (repeat 5) -- [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
  
  -- 함수
  {-
    함수의 우선 순위가 다른 연산자들보다 높음
    f a + b --> f(a) + b
    --> f(a+b)를 원하면 f (a+b)로 해야 함
    
    수학적 표기
    f x -- f(x)
    f x y -- f(x, y)
    f (g x) -- f(g(x))
    f x (g y) -- f(x, g(y))
    f x * g y -- f(x) * g(x)  -- *는 그냥 곱하기인듯..

    함수 이름은 반드시 소문자로 시작해야 함.

    실습은 test.hs에..
  -}
  
  -- Boolean, Tuple
  -- or
  False || False  -- False
  False || True   -- True
  True || False   -- True
  True || True    -- True
  -- and
  False && False  -- False
  False && True   -- False
  True && False   -- False
  True && True    -- True
  -- not
  not True        -- False
  not False       -- True
  -- equal
  4 == 3          -- False
  4 == 4          -- True
  -- not equal
  True /= False   -- True
  True /= True    -- False

  fst (1, "Hello") -- 1
  snd (1, "Hello") -- "Hello"
  fst (snd (1, (2, 3))) -- 2

  -- if then else
  {-
    if x > 100
      then x
      else x*2
  -}

  -- Types
  {-
    ghci에서 :t e를 치면 e :: t라고 나옴. e라는 exp가 t라는 타입이라는 뜻

    Bool: False, True
    Char은 문자 하나.
    String은 Char의 리스트. --> [Char]
    String == [Char]
    '' 은 Char, ""은 [Char]
    Int (== Integer)
    List는 같은 타입으로만 이루어져야 함 --> [False, True, True] :: [Bool]
    [String] == [[Char]]
    Tuple은 묶이는 대로 타입을.. --> (False, 'a', True) :: (Bool, Char, Bool) --> 묶이는 애들끼리 타입이 달라도 됨

    함수의 타입? --> 한 타입의 값을 다른 타입의 값으로 매핑
    :t not --> not :: Bool -> Bool
    add :: (Int, Int) -> Int
  -}
  -- 타입 명시해서 함수 작성
  add :: (Int, Int) -> Int
  add (x, y) = x + y

  zeroto :: Int -> [Int]
  zeroto n = [0..n]

  -- Currying
  add x y = x + y
  let addThreeto = add 3 -- x = 3 + y
  addThreeto 4 -- 7

  -- Polymorphic type
  {-
    :t length --> length :: [a] -> Int
    --> a는 타입이 아니고, 아무 타입이나 와도 된다는 뜻
    a를 type variable이라고 부름. a가 아니라 b, c 등 소문자이기만 하면 됨
    Polymorphism은 generics와 sub-typing을 모두 포함
    generics는 type parameterization
    sub-typing은 type-hierarchy를 의미  

    :t fst --> fst :: (a, b) -> a
    :t head --> head :: [a] -> a
    :t take --> take :: [a] -> [a]
    :t zip --> zip :: [a] -> [b] -> [(a, b)]

    polymorphic function이 특정 타입에 제한 되어있는 것을 overloaded되었다고 부름
    ex) sum :: Num => [a] -> a
    sum은 string에 대해서는 못 씀. Int나 Float에 대해서만 가능. --> 'Num =>'의 의미. --> sum이 Num이라는 타입 클래스에 의해 제한 됨 --> oveloaded

    Overloading에 사용할 수 있는 다양한 타입 클래스.
    :t (<) -- Ordered types / 순서가 있는 타입에만 사용 가능 (대소 비교가 가능해야 함)
      (<) :: Ord a => a -> a -> Bool
    :t (==) -- Equality types / 같은 걸 비교할 수 있을 때 사용 가능
      (==) :: Eq a => a -> a -> Bool
    :t (+) -- Numeric types / 숫자일 경우에만 사용 가능
      (+) :: Num a => a -> a -> a

    palindrome xs = reverse xs == xs
    :t palindrome
    --> palindrome :: Eq a => [a] -> Bool

  -}

  -- Basic Classes
  {-
    Eq는 해당 클래스가 비교할 수 있음을, Ord는 순서가 있음을 나타냄
    Bool, Char, String, Int, Integer, Float, Tuple, List는 모두 Ord와 Eq 클래스의 인스턴스들.
    (>), (>=), (<), (<=), max, min 등이 Ord 클래스의 인스턴스에 대해 적용할 수 있는 함수. --> String, Tuple, List는 사전 순에 의해 비교
  -}

  -- Showable Type
  {-
    :t show --> Show a => a -> String
    --> Show 클래스의 인스턴스들은 show 함수를 이용하면 String 형태로 출력
    ex) show False -- "False" 출력
        show [1, 2, 3] -- "[1, 2, 3]" 출력
  -}

  -- Readable Type
  {-
    :t read --> Read a => String -> a

    read "False" :: Bool
    read "[1, 2, 3]" :: [Int] -- [1, 2, 3]
  -}

  -- Integral, Fractional, Rational
  {-
    단순히 숫자 클래스로 Num만 있는 건 아니고, 정수, 분수, 유리수 등을 나타내는 다양한 클래스 존재
    정수는 Integral, 분수는 Fractional, 유리수는 Rational
    mod나 div는 Integral에만 적용 가능, (/)는 Fractional에만 적용 가능
  -}

  -- Guarded Equations
  {-
    if 대신에 좀 더 편하게 사용할 수 있는 guarded equation
  -}
  -- 일반적인 if 문
  abs n = if n >= 0 then n else -n
  signum n = 
    if n > 0 then 1 else
      if n < 0 then -1 else 0
  -- guarded equation
  abs n | n >= 0 = n
        | otherwise = -n
  signum n | n > 0 = 1
           | n < 0 = -1
           | otherwise = 0
  
  -- Pattern Matching
  {-
    case나 switch 없이 패턴 매칭 사용
  -}
  not :: Bool -> Bool
  not False = True
  not True = False

  (&&) :: Bool -> Bool -> Bool
  True && True = True
  _ && _ = False
  {-
    또는
    True && b = b
    False && _ = False

    b는 Bool 타입의 변수
  -}

  -- List Patterns
  {-
    함수형 언어에서는 리스트가 주된 자료구조.
    --> 패턴매칭에 리스트를 사용할 수 있으면 편함
    ex)
      head (x:_) = x
      tail (_:xs) = xs

    함수의 우선순위가 높으므로, head x:_로 하면 (head x):_가 됨..
  -}
  
  -- Lambda Expression
  {-
    \를 통해 람다를 표시.
    ex)
      \x -> x + 1
      \x y -> x + y -- x, y의 2개의 parameter를 받음

    왜 람다?
    1) currying을 통해 정의된 함수를 좀 더 의미있게 표현 가능
    ex)
      add x y = x + y는
      add = \x -> (\y -> x + y)와 같음
      --> 함수를 리턴한다는 의미가 더 강함
    2) 이름을 안 지어도 됨
    ex)
      odds n = map f [0..n]
                 where
                   f x = x `mod` 2 /= 0
      odds1 n = map (\x -> x `mod` 2 /= 0) [0..n]
  -}

  -- Sections
  {-
    in-fix operator는 괄호를 더해 맨 앞으로 끌어올 수 있음
    ex)
      1 + 2 -- 3
      (+) 1 2 -- 3
    이렇게 연산자를 앞으로 옮길 수 있게 되면, 피 연산자 하나와 괄호를 엮기 가능
    ex)
      (x+) 또는 (+x)  --> 이런 걸 section이라 부름
  -}
