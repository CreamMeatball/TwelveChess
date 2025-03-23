import 'models/game_board.dart';
import 'models/player.dart';
import 'models/game_piece.dart';

class GameController {
  GameBoard board;
  List<Player> players;
  int currentPlayerIndex = 0;
  // 추가: 각 플레이어가 잡은 말 저장 (플레이어 1, 2)
  List<GamePiece> capturedPieces1 = [];
  List<GamePiece> capturedPieces2 = [];

  // 게임 종료 상태 관리
  bool isGameOver = false;
  int? winner;

  // King이 상대방 진영에 있는지 추적
  bool kingInOpponentTerritory1 = false; // Player1의 King이 Player2 진영에 있는지
  bool kingInOpponentTerritory2 = false; // Player2의 King이 Player1 진영에 있는지

  GameController()
      : board = GameBoard(),
        players = [Player(id: 1), Player(id: 2)] {
    board.setupBoard();
  }

  Player get currentPlayer => players[currentPlayerIndex];

  void nextTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;

    // King이 상대 진영에 있는지 확인하고, 한 턴을 버텼는지 확인
    checkKingInEnemyTerritory();
  }

  // 킹이 상대 진영에 있는지 확인하고 게임 종료 여부 업데이트
  void checkKingInEnemyTerritory() {
    // 플레이어1의 킹이 상대 진영에 있고, 다시 플레이어1의 턴이 돌아왔으면 승리
    if (kingInOpponentTerritory1 && currentPlayerIndex == 0) {
      isGameOver = true;
      winner = 1;
      return;
    }

    // 플레이어2의 킹이 상대 진영에 있고, 다시 플레이어2의 턴이 돌아왔으면 승리
    if (kingInOpponentTerritory2 && currentPlayerIndex == 1) {
      isGameOver = true;
      winner = 2;
      return;
    }

    // 현재 킹 위치 확인 및 상태 업데이트
    bool foundKing1 = false;
    bool foundKing2 = false;

    for (int r = 0; r < GameBoard.rows; r++) {
      for (int c = 0; c < GameBoard.cols; c++) {
        final piece = board.grid[r][c];
        if (piece != null && piece.type == PieceType.King) {
          // Player1의 킹이 상대 진영(row 0)에 있는지 확인
          if (piece.owner == 1) {
            foundKing1 = true;
            if (r == 0) {
              kingInOpponentTerritory1 = true;
            } else {
              // 킹이 상대 진영에서 나갔으면 플래그 리셋
              kingInOpponentTerritory1 = false;
            }
          }
          // Player2의 킹이 상대 진영(row 3)에 있는지 확인
          else if (piece.owner == 2) {
            foundKing2 = true;
            if (r == 3) {
              kingInOpponentTerritory2 = true;
            } else {
              // 킹이 상대 진영에서 나갔으면 플래그 리셋
              kingInOpponentTerritory2 = false;
            }
          }
        }
      }
    }

    // 킹이 잡혔으면 해당 플래그 리셋
    if (!foundKing1) {
      kingInOpponentTerritory1 = false;
    }
    if (!foundKing2) {
      kingInOpponentTerritory2 = false;
    }
  }

  // 이동 및 캡처 로직 수정
  bool movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    // 게임이 이미 종료되었으면 이동 불가
    if (isGameOver) return false;

    final piece = board.grid[fromRow][fromCol];
    if (piece == null) return false;

    // 현재 플레이어의 말인지 확인 (추가된 부분)
    if (piece.owner != currentPlayer.id) return false;

    // 이동 규칙 검증
    final dr = toRow - fromRow;
    final dc = toCol - fromCol;
    final valid =
        piece.allowedMoves.any((offset) => offset[0] == dr && offset[1] == dc);
    if (!valid) return false;

    final target = board.grid[toRow][toCol];
    // 비어있거나 상대 말인 경우만 이동 가능
    if (target != null && target.owner == piece.owner) return false;

    // 상대 말을 잡은 경우
    if (target != null && target.owner != piece.owner) {
      // 상대 King을 잡았는지 확인
      if (target.type == PieceType.King) {
        // 킹을 잡으면 즉시 게임 종료
        isGameOver = true;
        winner = currentPlayer.id;

        // 킹이 잡혔으면 해당 플래그도 리셋 (추가)
        if (target.owner == 1) {
          kingInOpponentTerritory1 = false;
        } else {
          kingInOpponentTerritory2 = false;
        }
      }

      // Marquis를 잡으면 Soldier로 변환해서 저장 (소유권 변경)
      if (target.type == PieceType.Marquis) {
        GamePiece soldierPiece = GamePiece(
            type: PieceType.Soldier, owner: piece.owner); // 소유자를 현재 플레이어로 변경
        if (piece.owner == 1) {
          capturedPieces1.add(soldierPiece);
        } else {
          capturedPieces2.add(soldierPiece);
        }
      } else {
        // 잡은 말의 소유권을 현재 플레이어로 변경
        GamePiece capturedPiece =
            GamePiece(type: target.type, owner: piece.owner);
        if (piece.owner == 1) {
          capturedPieces1.add(capturedPiece);
        } else {
          capturedPieces2.add(capturedPiece);
        }
      }
    }

    // 말 이동
    board.movePiece(fromRow, fromCol, toRow, toCol);

    // Soldier가 상대 진영에 도달했는지 확인하여 Marquis로 변경
    if (piece.type == PieceType.Soldier) {
      if ((piece.owner == 1 && toRow == 0) ||
          (piece.owner == 2 && toRow == 3)) {
        // Soldier를 Marquis로 변경
        board.grid[toRow][toCol] =
            GamePiece(type: PieceType.Marquis, owner: piece.owner);
      }
    }

    // King이 상대 진영에 들어갔는지 확인
    if (piece.type == PieceType.King) {
      if (piece.owner == 1 && toRow == 0) {
        kingInOpponentTerritory1 = true;
      } else if (piece.owner == 2 && toRow == 3) {
        kingInOpponentTerritory2 = true;
      } else {
        // 킹이 상대 진영을 벗어나면 플래그 리셋 (추가)
        if (piece.owner == 1) {
          kingInOpponentTerritory1 = false;
        } else if (piece.owner == 2) {
          kingInOpponentTerritory2 = false;
        }
      }
    }

    nextTurn();
    return true;
  }

  // 게임 초기화 메소드
  void restartGame() {
    board = GameBoard();
    board.setupBoard();
    currentPlayerIndex = 0;
    capturedPieces1.clear();
    capturedPieces2.clear();
    isGameOver = false;
    winner = null;
    kingInOpponentTerritory1 = false;
    kingInOpponentTerritory2 = false;
  }

  // 캡처한 말을 배치할 때 사용할 함수
  bool placeCapturedPiece(int row, int col, GamePiece captured) {
    // 게임이 이미 종료되었으면 배치 불가
    if (isGameOver) return false;

    // 현재 플레이어의 캡처 목록에 있는 말인지 확인
    List<GamePiece> currentPlayerCapturedPieces =
        currentPlayer.id == 1 ? capturedPieces1 : capturedPieces2;

    // 현재 플레이어의 캡처 목록에 없는 말이면 배치할 수 없음
    if (!currentPlayerCapturedPieces.contains(captured)) return false;

    // 진영 배치 제한: 현재 플레이어에 따른 제한 (Player1은 row 0 불가, Player2는 row 3 불가)
    if (currentPlayer.id == 1 && row == 0) return false;
    if (currentPlayer.id == 2 && row == 3) return false;
    // 이미 말이 존재하는 곳은 안됨.
    if (board.grid[row][col] != null) return false;

    // 배치 시 소유자 변경 (자신의 말로 전환)
    // 추가 검증: 만약 somehow Marquis가 있다면 Soldier로 변환
    PieceType pieceType = captured.type;
    if (pieceType == PieceType.Marquis) {
      pieceType = PieceType.Soldier;
    }

    final newPiece = GamePiece(type: pieceType, owner: currentPlayer.id);
    board.grid[row][col] = newPiece;

    // 해당 캡처 목록에서 제거
    if (currentPlayer.id == 1) {
      capturedPieces1.remove(captured);
    } else {
      capturedPieces2.remove(captured);
    }
    nextTurn();
    return true;
  }

  // 가능한 이동 위치를 계산하는 메소드 추가
  List<List<int>> getPossibleMoves(int row, int col) {
    List<List<int>> possibleMoves = [];
    GamePiece? piece = board.grid[row][col];

    // 선택한 말이 없거나, 현재 플레이어의 말이 아니면 빈 리스트 반환
    if (piece == null || piece.owner != currentPlayer.id) {
      return possibleMoves;
    }

    // 말의 종류에 따라 이동 가능한 위치 계산
    switch (piece.type) {
      case PieceType.King:
        // 왕은 8방향으로 1칸씩 이동 가능
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue; // 제자리는 건너뜀
            int newRow = row + dr;
            int newCol = col + dc;
            if (_isValidMove(piece, row, col, newRow, newCol)) {
              possibleMoves.add([newRow, newCol]);
            }
          }
        }
        break;
      case PieceType.General:
        // 장군은 상하좌우로 1칸씩 이동 가능
        for (var dir in [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ]) {
          int newRow = row + dir[0];
          int newCol = col + dir[1];
          if (_isValidMove(piece, row, col, newRow, newCol)) {
            possibleMoves.add([newRow, newCol]);
          }
        }
        break;
      case PieceType.Minister:
        // 대신은 대각선으로 1칸씩 이동 가능
        for (var dir in [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ]) {
          int newRow = row + dir[0];
          int newCol = col + dir[1];
          if (_isValidMove(piece, row, col, newRow, newCol)) {
            possibleMoves.add([newRow, newCol]);
          }
        }
        break;
      case PieceType.Soldier:
        // 병사는 앞으로 1칸 이동 가능 (플레이어에 따라 방향이 다름)
        int direction = (piece.owner == 1) ? -1 : 1;
        int newRow = row + direction;
        int newCol = col;
        if (_isValidMove(piece, row, col, newRow, newCol)) {
          possibleMoves.add([newRow, newCol]);
        }
        break;
      case PieceType.Marquis:
        // 후작은 왕과 유사하게 이동하지만 대각선 뒤로는 이동 불가
        int direction = (piece.owner == 1) ? -1 : 1;
        // 앞, 좌우, 대각선 앞, 뒤
        for (var dir in [
          [direction, 0], // 앞
          [0, -1], [0, 1], // 좌우
          [direction, -1], [direction, 1], // 대각선 앞
          [-direction, 0] // 뒤
        ]) {
          int newRow = row + dir[0];
          int newCol = col + dir[1];
          if (_isValidMove(piece, row, col, newRow, newCol)) {
            possibleMoves.add([newRow, newCol]);
          }
        }
        break;
    }

    return possibleMoves;
  }

  // 주어진 위치로 이동이 가능한지 확인하는 헬퍼 메소드
  bool _isValidMove(
      GamePiece piece, int fromRow, int fromCol, int toRow, int toCol) {
    // 보드 범위 확인
    if (toRow < 0 ||
        toRow >= GameBoard.rows ||
        toCol < 0 ||
        toCol >= GameBoard.cols) {
      return false;
    }

    // 도착 위치에 자신의 말이 있는지 확인
    GamePiece? targetPiece = board.grid[toRow][toCol];
    if (targetPiece != null && targetPiece.owner == piece.owner) {
      return false;
    }

    return true;
  }
}
