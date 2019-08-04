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
  
  return :: a -> Parser a
  return v = \xs -> [(v, xs)]
  -- failure는 항상 실패, return은 항상 성공하는 파서
