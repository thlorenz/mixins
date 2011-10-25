Function::comp = (f) -> @(f())

moveLeft  = -> @x++
moveRight = -> @x--
moveUp    = -> @y++
moveDown  = -> @y--

moveNE    = -> moveLeft . moveDown

make2 = -> 2
add3 = (v) -> v + 3
sub2 = (v) -> v - 2

Object::pipe = (fn) -> fn @
get5 = -> make2().pipe add3

get8 = ->
  make2
  .compose add3
  .compose add3

get6 = ->
  make2()
  .pipe(add3)
  .pipe(add3)
  .pipe(sub2)

Function::fwd  = (fn) -> (params) => fn(@(params))
make = (val) -> val
get6 =
  make
  .fwd(add3)
  .fwd(add3)
  .fwd(sub2)
