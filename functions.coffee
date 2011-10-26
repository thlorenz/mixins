class FunctionWrapper
  constructor: (fn) -> @fn = fn
  fwd: (f) -> _f (params) => f.fn(@fn(params))
  times: (count) =>
    f = null
    for i in [1..count]
      do => f = if not f then this else f.fwd this
    f
_f = (fn) -> new FunctionWrapper fn

# ChessGame

sq = [1..8]

moveLeft  = _f (x) -> x.x--; x
moveRight = _f (x) -> x.x++; x
moveDown  = _f (x) -> x.y--; x
moveUp    = _f (x) -> x.y++; x

moveNE    = moveUp.fwd moveRight
moveSE    = moveDown.fwd moveRight
moveNW    = moveUp.fwd moveLeft
moveSW    = moveDown.fwd moveLeft

allLeft   = sq.map((x) -> moveLeft.times x)
allRight  = sq.map((x) -> moveRight.times x)
allDown   = sq.map((x) -> moveDown.times x)
allUp     = sq.map((x) -> moveUp.times x)

allNE     = sq.map((x) -> moveNE.times x)
allSE     = sq.map((x) -> moveSE.times x)
allNW     = sq.map((x) -> moveNW.times x)
allSW     = sq.map((x) -> moveSW.times x)

knightNE  = moveUp.fwd    moveNE
knightSE  = moveDown.fwd  moveSE
knightNW  = moveUp.fwd    moveNW
knightSW  = moveDown.fwd  moveSW
knightMoves = [ knightNE, knightSE, knightNW, knightSW ]

bishopMoves =
  allNE
    .concat allSE
    .concat allNW
    .concat allSW

rookMoves =
  allLeft
    .concat allRight
    .concat allDown
    .concat allUp

queenMoves = bishopMoves.concat rookMoves

kingMoves = [ moveLeft, moveRight, moveUp, moveDown, moveNE, moveSE, moveNW, moveSW ]

whitePawnMoves = [ moveUp, moveUp.times(2), moveNE, moveNW ]

blackPawnMoves = [ moveDown, moveDown.times(2), moveSE, moveSW ]

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
      .map((x) => x.fn({ @x, @y }))
      .filter(isLegalPosition)
      .map(prettyPosition)

class Knight extends ChessPiece
  moves: knightMoves

class Bishop extends ChessPiece
  moves: bishopMoves

class Rook extends ChessPiece
  moves: rookMoves

class Queen extends ChessPiece
  moves: queenMoves

class King extends ChessPiece
  moves: kingMoves

class Pawn extends ChessPiece
  constructor: (x, y, color) ->
    super(x, y)
    @moves = if color is 'white' then whitePawnMoves else blackPawnMoves

knight = new Knight('B', 4)
bishop = new Bishop('D', 5)
rook = new Rook('A', 1)
queen = new Queen('D', 1)
king = new King('E', 1)
pawn = new Pawn('E', 2, 'white')

