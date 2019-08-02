f [] = []
f (x:xs) = f ys ++ [x] ++ zs
           where
             ys = [a | a <- xs, a <= x]
             zs = [b | b <- xs, b > x]


{-
  하스켈 켜는 법: ghci
  원하는 모듈 불러오기? --> :load asd.hs
  모듈 다시 불러오기(새로고침) --> :reload
  이외의 다른 명령어를 보려면 --> :help
-}