-- Parser
{-
  Parser는 텍스트 조각을 분석하여 syntactic structure를 만들어내는 프로그램
  Haskell은 GHC가 분석.
-}

-- Parser Type
{-
  type Parser = String -> Tree

  때떄로 입력된 문자열이 이상하면, 파서가 제대로 동작하지 않을 수 있음.
  이 때, 분석되지 않은 문자열을 돌려주려면..
  type Parser = String -> (Tree, String)
  
  어떤 문자열은 여러 가지로 해석 가능..
  type Parser = String -> [(Tree, String)]

  트리를 만들지 않고, 계산한 결과를 돌려주기
  type Parser a = String -> [(a, String)]
-}

module Chapter4 where
  import Prelude hiding ((>>=))

  type Parser a = String -> [(a, String)]
  -- 간단한 item Parser. 문자열에서 첫 번째 원소를 소비하고, 나머지를 돌려줌
  item :: Parser Char
  item = \xs -> case xs of 
                  [] -> []
                  (x:xs) -> [(x, xs)]
  -- item "Hello world" --> [('H', "ello world")]
  -- item "" --> []

  -- 항상 []만 돌려주는 failure 파서, a -> Parser a 타입의 return
  failure :: Parser a
  failure = \xs -> []
  
  returns :: a -> Parser a
  returns v = \xs -> [(v, xs)]
  -- failure는 항상 실패, return은 항상 성공하는 파서
  
  (+++) :: Parser a -> Parser a -> Parser a
  p +++ q = \xs -> case p xs of 
                    [] -> parse q xs
                    [(y, ys)] -> [(y, ys)]
  
  -- parse는 그냥 주어진 text에 파서를 적용한 결과를 돌려 줌
  parse :: Parser a -> String -> [(a, String)]
  parse p xs = p xs
  
{-
  여기서 parser가 하는 일이 뭐지?
  parser의 타입은, String을 받아서, 어떤 부가적인 작업을 해서 a타입을 만들고, 다시 본래 타입인 String을 더해 튜플로 내어 줌
  즉, parser는 한 타입을 받아 부가적인 정보를 만들어 본래 타입에 붙여주는 역할을 함.
  (+++) 함수는 parser를 합성해주는 역할 (지금 만든 건 p가 실패하면 q를 적용하지만, 여러 parser t, u, v를 받아 모두 적용한 뒤 결과를 주는 것도 가능.. 만들기 나름)
  
  요약: 부가적인 정보를 만들어 주는 parser & parser 간의 합성을 해주는 +++
  --> 이 parser가 바로 monad
-}

-- Sequencing
{-
  위에서 +++는 두 개의 parser를 받기는 했지만, 둘 중 하나만 사용
  then, 둘 이상의 parser를 엮어서 하나의 parser를 만들려면?
  일단 타입이 다름..

  Parser a -- String -> [(a, String)]
  Parser b -- String -> [(b, String)]

  즉, 한 parser를 거치면, 다른 parser의 input이 바로 될 수는 없음
  또한 parser a에서 얻은 정보를 parser b에 손실 없이 넘겨줘야 함. 이래야 의미가 있지

  이번에 만들 것은 Parser a를 받아 Parser b를 돌려주는 parser 조합함수를 만들 것
  이 때, 부가정보인 a의 보존을 위해, 이 함수에서 (a -> Parser b)타입의 중간 함수가 필요
  --> 이 중간 함수가 가장 중요함
  이 함수의 이름은 >>=라고 지을 것. bind라고 읽음
  (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  p >>= q = \xs -> case p xs of 
                    [] -> []
                    (y, ys):_ -> parse (q y) ys
-}

{-
  실패하면 []를 반환
  성공하면 Parser a의 결과로 얻어진 a타입의 부가정보를 (a -> Parser b) 타입의 함수인 q에게 넘겨주어서
  Parser b를 받고, 결과적으로 (\xs parse k ys (k :: Parser b)) 를 돌려줌
  --> 결국 Parser a를 통해 Parser b를 만들어 냄
  아래는 예시들
-}

  (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  p >>= q = \xs -> case p xs of 
                        [] -> []
                        (y, ys):_ -> parse (q y) ys
                        
  -- consume only head of String
  parseTwice :: Parser (Char, Char)
  parseTwice = item >>= (\x -> returns (x, x)) -- item과 return 두 parser를 조합

  ignore2 :: Parser (Char, Char)
  ignore2 = item >>= (\x -> item >>= (\y -> item >>= (\z -> returns (x, z)))) -- 부가 정보를 계속 가져가는 중(x, y, z...)

  {-
    위처럼, 같은 원본타입 String을 가지는 같은 종류의 parser(monad)는 계속 연결 가능
    p1, ..., pn을 parser, v1, ..., vn을 parser가 만드는 부가정보라 할 때, 일반화
    p1 >>= \v1 ->
      p2 >>= \v2 ->
        p3 >>= \v3 ->
          ...
            pn >>= \vn ->
              return (f v1 v2 ... vn)
    
    이런 것을 위해, 더 편한 문법 do 지원
    do { v1 <- p1
       v2 <- p2
       ...
       vn <- pn
       return (f v1 v2 ... vn)
  -}

  -- Monadic Axioms
  {-
    이 때 do 구문을 활용하는 parser(monad) pn에 대해서는 미리 >>=(binder 함수)와 return이 구현되어야 함
    return은 a를 받아서 parser를 돌려주고, >>=는 parser(monad)를 결합
    다양한 parser(monad)가 있는 만큼, return과 >>=를 구현할 때 필요한 최소한의 공리가 있음
      1. m >>= return == m (right unit)
      2. return x >>= f == f x (left unit)
      3. (m >> f) >>= g == m >>= (\x -> f x >> g) (associativity)
  -}
  
  -- Why Monad?
  {-
    모나드가 중요한 이유는, 부가정보를 만들면서 본래의 타입을 유지하기 때문.
    본래 순수 함수형 언어에서는 콘솔 출력과 같은 side-effect를 만들 수 없음.
    but, 모나드를 이용하면 side-effect(부가정보)와 연산 부분(purely functional)을 분리할 수 있음
    실제로 IO Monad를 통해 입출력 가능
  -}
  
  -- 실제 모나드 사용 --> monad.hs 파일