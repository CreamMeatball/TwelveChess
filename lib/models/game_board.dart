import 'game_piece.dart';

class GameBoard {
  static const int rows = 4;
  static const int cols = 3;
  List<List<GamePiece?>> grid =
      List.generate(rows, (_) => List.filled(cols, null));

  void setupBoard() {
    // Player1 (하단, row 3)
    grid[3][0] = GamePiece(type: PieceType.Minister, owner: 1);
    grid[3][1] = GamePiece(type: PieceType.King, owner: 1);
    grid[3][2] = GamePiece(type: PieceType.General, owner: 1);
    // Soldier: row 2, col 2
    grid[2][1] = GamePiece(type: PieceType.Soldier, owner: 1);

    // Player2 (상단, row 0)
    grid[0][0] = GamePiece(type: PieceType.General, owner: 2);
    grid[0][1] = GamePiece(type: PieceType.King, owner: 2);
    grid[0][2] = GamePiece(type: PieceType.Minister, owner: 2);
    // Soldier: row 1, col 1
    grid[1][1] = GamePiece(type: PieceType.Soldier, owner: 2);
  }

  void movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    grid[toRow][toCol] = grid[fromRow][fromCol];
    grid[fromRow][fromCol] = null;
  }
}
