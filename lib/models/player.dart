import 'game_piece.dart';

class Player {
  int id;
  // 포획한 말을 저장 (추후 사용)
  List<GamePiece> capturedPieces = [];

  Player({required this.id});
}
