Function::pipe = (f) -> f(@())
Function::comp = (f) -> return => @(f())

moveLeft  = -> @x++
moveRight = -> @x--
moveUp    = -> @y++
moveDown  = -> @y--

moveNE    = -> moveLeft . moveDown

make2 = -> 2
add3 = (v) -> v + 3

get5 = -> make2.comp add3

get8 = ->
  make2
  .compose add3
  .compose add3

get6 = ->
  make2
  .comp(add3)
  .comp(add3)

