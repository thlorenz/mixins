make = (val) -> val
add3 = (v) -> v + 3
sub2 = (v) -> v - 2

Object::pipe = (fn) -> fn @
Function::fwd  = (fn) -> (params) => fn(@(params))

get6 = ->
  make(2)
  .pipe(add3)
  .pipe(add3)
  .pipe(sub2)

add4 =
  make
  .fwd(add3)
  .fwd(add3)
  .fwd(sub2)

moveLeft  = (x) -> x.x--; x
moveRight = (x) -> x.x++; x
moveDown  = (x) -> x.y--; x
moveUp    = (x) -> x.y++; x

moveNE    = moveUp.fwd moveRight
moveSE    = moveDown.fwd moveRight
moveNW    = moveUp.fwd moveLeft
moveSW    = moveDown.fwd moveLeft

knightNE  = moveUp.fwd moveNE
knightSE  = moveDown.fwd moveSE
knightNW  = moveUp.fwd moveNW
knightSW  = moveDown.fwd moveSW
knightMoves = [ knightNE, knightSE, knightNW, knightSW ]

bishopMoves = [
  moveNE, moveSE

]

charCodeOffset  = 'A'.charCodeAt(0) - 1
prettyPosition  = (p) -> [ String.fromCharCode(p.x + charCodeOffset), p.y ]
isLegalPosition = (p) -> p.x > 0 and p.x < 9 and p.y > 0 and p.y < 9

class ChessPiece
  constructor: (x, y) ->
    @x = x.charCodeAt(0) - charCodeOffset
    @y = y
  position: -> prettyPosition({ @x, @y })
  legalMoves: ->
    @moves
      .map((x) => x({ @x, @y }))
      .filter(isLegalPosition)
      .map(prettyPosition)

class Knight extends ChessPiece
  moves: knightMoves

knight = new Knight('B', 4)

a = 0
myFun = -> a++; a
funTimes = (fn, times) ->
  combined = null
  for i in [1..times]
    do ->
      combined = if not combined then fn else combined.fwd fn
  combined
fun = funTimes myFun, 5




