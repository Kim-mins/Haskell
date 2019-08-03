double x = x + x
quadruple x = double (double x) -- 작은 모듈로 쪼개서..
-- 1..n --> 1부터 n까지 (점 두 개)
factorial n = product [1..n]
-- `` 안의 값은 함수의 이름이고, 왼쪽과 오른쪽에 있는 것들을 파라미터로 갖는 함수라는 뜻 --> syntactic sugar
avg ns = sum ns `div` length ns   -- 변수명 뒤에 s가 붙으면 리스트라는 뜻. ss는 리스트의 리스트
-- avg ns = div (sum ns) (length ns)  -- 위 줄과 같음
