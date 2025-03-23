enum PieceType { General, Minister, King, Soldier, Marquis }

class GamePiece {
  PieceType type;
  int owner; // 1 또는 2

  GamePiece({required this.type, required this.owner});

  // 말에 따라 상대적인 이동 오프셋을 정의합니다.
  List<List<int>> get allowedMoves {
    switch (type) {
      case PieceType.General:
        return [
          [0, 1],
          [0, -1],
          [1, 0],
          [-1, 0],
        ];
      case PieceType.Minister:
        return [
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
      case PieceType.King:
        return [
          [0, 1],
          [0, -1],
          [1, 0],
          [-1, 0],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
      case PieceType.Soldier:
        // 자는 앞으로만 이동 (플레이어에 따라 방향이 다름)
        return owner == 1
            ? [
                [-1, 0]
              ]
            : [
                [1, 0]
              ];
      case PieceType.Marquis:
        // 후: 대각선 뒤쪽 방향만 제외한 전 방향 이동
        return owner == 1
            ? [
                [0, 1],
                [0, -1],
                [-1, 0],
                [1, 0],
                [-1, 1],
                [-1, -1]
              ]
            : [
                [0, 1],
                [0, -1],
                [-1, 0],
                [1, 0],
                [1, 1],
                [1, -1]
              ];
      default:
        return [];
    }
  }
}
