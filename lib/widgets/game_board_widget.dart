import 'package:flutter/material.dart';
import '../game_controller.dart';
import '../models/game_board.dart';
import '../models/game_piece.dart';
import 'dart:math' show pi;

// 게임 색상 테마
class GameColors {
  static const Color background = Color(0xFF1C2833);
  static const Color player1Primary = Color(0xFFE74C3C);
  static const Color player1Light = Color(0xFFF5B7B1);
  static const Color player2Primary = Color(0xFF2ECC71);
  static const Color player2Light = Color(0xFFABEBC6);
  static const Color boardDark = Color(0xFF34495E);
  static const Color boardLight = Color(0xFF5D6D7E);
  static const Color textLight = Color(0xFFECF0F1);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color highlight = Color(0xFFF39C12);
}

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});
  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen>
    with TickerProviderStateMixin {
  final GameController _controller = GameController();
  int? selectedRow, selectedCol;
  late AnimationController _turnAnimController;

  @override
  void initState() {
    super.initState();
    _turnAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _turnAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 게임 종료 상태 확인 및 모달 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.isGameOver && _controller.winner != null) {
        _showGameOverDialog();
      }
    });

    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GameColors.background,
        centerTitle: true,
        // 제목 제거
        actions: [
          // 재시작 버튼 추가
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: GameColors.textLight,
              size: 28,
            ),
            tooltip: '게임 다시하기',
            onPressed: () {
              setState(() {
                _controller.restartGame();
              });
            },
          ),
          const SizedBox(width: 8), // 우측 여백 추가
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 상단: Player2 UI 패널
            _buildPlayerPanel(2),
            // Player2가 잡은 말(상대 말) 표시
            buildCapturedPieces(2),
            // 보드 영역
            Expanded(
              child: Center(
                child: buildBoard(),
              ),
            ),
            // Player1이 잡은 말(상대 말) 표시
            buildCapturedPieces(1),
            // 하단: Player1 UI 패널
            _buildPlayerPanel(1),
          ],
        ),
      ),
    );
  }

  // 개선된 플레이어 정보 패널
  Widget _buildPlayerPanel(int playerId) {
    bool isCurrentPlayer = _controller.currentPlayer.id == playerId;
    Color playerColor =
        playerId == 1 ? GameColors.player1Primary : GameColors.player2Primary;
    Color activeColor =
        playerId == 1 ? GameColors.player1Light : GameColors.player2Light;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            isCurrentPlayer ? playerColor.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Player $playerId',
            style: TextStyle(
              color: GameColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isCurrentPlayer)
            AnimatedBuilder(
                animation: _turnAnimController,
                builder: (context, child) {
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor
                          .withOpacity(0.4 + _turnAnimController.value * 0.6),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withOpacity(0.6),
                          blurRadius: 8 + _turnAnimController.value * 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                }),
        ],
      ),
    );
  }

  // 게임 종료 다이얼로그 표시 - 디자인 개선
  void _showGameOverDialog() {
    final winnerColor = _controller.winner == 1
        ? GameColors.player1Primary
        : GameColors.player2Primary;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: GameColors.background,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  GameColors.background,
                  GameColors.boardDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: winnerColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: GameColors.textLight,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: winnerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: winnerColor.withOpacity(0.5), width: 2),
                  ),
                  child: Text(
                    'Player ${_controller.winner} Wins!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: winnerColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.restartGame();
                      Navigator.of(context).pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: winnerColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 개선된 캡처된 말 표시 UI
  Widget buildCapturedPieces(int playerId) {
    final captured = (playerId == 1)
        ? _controller.capturedPieces1
        : _controller.capturedPieces2;

    Color bgColor = playerId == 1
        ? GameColors.player1Primary.withOpacity(0.1)
        : GameColors.player2Primary.withOpacity(0.1);

    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: playerId == 1
                ? GameColors.player1Primary.withOpacity(0.3)
                : GameColors.player2Primary.withOpacity(0.3),
            width: 1.5),
      ),
      child: Center(
        child: captured.isEmpty
            ? Text(
                'No captured pieces',
                style: TextStyle(
                  color: GameColors.textLight.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: captured.map((piece) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Draggable<Map>(
                        data: {'captured': piece},
                        feedback: SizedBox(
                          width: 70,
                          height: 70,
                          child: buildPieceWidget(piece),
                        ),
                        childWhenDragging: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1,
                              )),
                        ),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: buildPieceWidget(piece),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  // 개선된 게임 보드 UI
  Widget buildBoard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(GameBoard.rows, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(GameBoard.cols, (col) {
              // 진영 색상 및 게임보드 체스판 패턴 적용
              Color baseColor;
              if (row == 0) {
                baseColor = GameColors.player2Primary.withOpacity(0.3);
              } else if (row == 3) {
                baseColor = GameColors.player1Primary.withOpacity(0.3);
              } else {
                baseColor = (row + col) % 2 == 0
                    ? GameColors.boardLight
                    : GameColors.boardDark;
              }

              final piece = _controller.board.grid[row][col];

              return DragTarget<Map>(
                onWillAccept: (data) => true,
                onAccept: (data) {
                  setState(() {
                    if (data.containsKey('fromRow')) {
                      _controller.movePiece(
                          data['fromRow'], data['fromCol'], row, col);
                    } else if (data.containsKey('captured')) {
                      _controller.placeCapturedPiece(
                          row, col, data['captured']);
                    }
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  bool isHighlighted = candidateData.isNotEmpty;

                  return Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? GameColors.highlight.withOpacity(0.3)
                          : baseColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isHighlighted
                          ? [
                              BoxShadow(
                                color: GameColors.highlight.withOpacity(0.5),
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: piece != null
                        ? Draggable<Map>(
                            data: {'fromRow': row, 'fromCol': col},
                            feedback: Material(
                              // Material 위젯 추가로 정확한 렌더링 보장
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: buildPieceWidget(piece),
                              ),
                            ),
                            childWhenDragging: Container(),
                            child: buildPieceWidget(piece),
                          )
                        : Container(),
                  );
                },
              );
            }),
          );
        }),
      ),
    );
  }

  // 게임 말 디자인 개선
  Widget buildPieceWidget(GamePiece piece) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 0.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CustomPaint(
        painter: ModernPiecePainter(type: piece.type, owner: piece.owner),
        size: const Size(70, 70),
      ),
    );
  }
}

// 개선된 말 디자인 페인터
class ModernPiecePainter extends CustomPainter {
  final PieceType type;
  final int owner;

  ModernPiecePainter({required this.type, required this.owner});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 말의 배경 그리기
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: owner == 1
            ? [GameColors.player1Light, GameColors.player1Primary]
            : [GameColors.player2Light, GameColors.player2Primary],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // 테두리 그리기
    final borderPaint = Paint()
      ..color =
          owner == 1 ? GameColors.player1Primary : GameColors.player2Primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // 외부 원(말 배경)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(center, radius + 1, shadowPaint);
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius, borderPaint);

    // 내부 아이콘/텍스트 표시
    final textStyle = TextStyle(
      color: GameColors.textDark,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: _getPieceText(),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // 텍스트 중앙에 배치
    final textX = (size.width - textPainter.width) / 2;
    final textY = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textX, textY));

    // 이동 방향 화살표 그리기 (더 세련된 스타일)
    _drawModernDirectionArrows(canvas, size);
  }

  // 말 유형에 따른 텍스트
  String _getPieceText() {
    switch (type) {
      case PieceType.King:
        return "K";
      case PieceType.General:
        return "G";
      case PieceType.Minister:
        return "M";
      case PieceType.Soldier:
        return "S";
      case PieceType.Marquis:
        return "Q";
      default:
        return "";
    }
  }

  // 개선된 방향 화살표 그리기
  void _drawModernDirectionArrows(Canvas canvas, Size size) {
    List<List<int>> directions = [];

    // 각 말 종류별 이동 방향
    switch (type) {
      case PieceType.King:
        directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        break;
      case PieceType.General:
        directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ];
        break;
      case PieceType.Minister:
        directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        break;
      case PieceType.Soldier:
        directions = owner == 1
            ? [
                [-1, 0]
              ]
            : [
                [1, 0]
              ];
        break;
      case PieceType.Marquis:
        if (owner == 1) {
          directions = [
            [-1, 0],
            [0, -1],
            [0, 1],
            [-1, -1],
            [-1, 1],
            [1, 0]
          ];
        } else {
          directions = [
            [1, 0],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 1],
            [-1, 0]
          ];
        }
        break;
    }

    // 화살표 색상
    final arrowPaint = Paint()
      ..color = owner == 1
          ? GameColors.player1Primary.withOpacity(0.9)
          : GameColors.player2Primary.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // 각 방향에 화살표 그리기
    for (var dir in directions) {
      _drawModernArrow(canvas, size, arrowPaint, dir);
    }
  }

  // 화살표 그리기 개선 버전
  void _drawModernArrow(
      Canvas canvas, Size size, Paint paint, List<int> direction) {
    final center = Offset(size.width / 2, size.height / 2);
    final arrowSize = size.width * 0.08; // 화살표 크기

    // 방향에 따른 각도 및 위치 계산
    double angle = 0;
    double distance = size.width * 0.37; // 중심에서 화살표까지 거리
    Offset position;

    if (direction[0] == -1 && direction[1] == 0) {
      // 위
      angle = 0;
      position = Offset(center.dx, center.dy - distance);
    } else if (direction[0] == 1 && direction[1] == 0) {
      // 아래
      angle = pi;
      position = Offset(center.dx, center.dy + distance);
    } else if (direction[0] == 0 && direction[1] == -1) {
      // 왼쪽
      angle = -pi / 2;
      position = Offset(center.dx - distance, center.dy);
    } else if (direction[0] == 0 && direction[1] == 1) {
      // 오른쪽
      angle = pi / 2;
      position = Offset(center.dx + distance, center.dy);
    } else if (direction[0] == -1 && direction[1] == -1) {
      // 왼쪽 위
      angle = -pi / 4;
      position = Offset(center.dx - distance * 0.7, center.dy - distance * 0.7);
    } else if (direction[0] == -1 && direction[1] == 1) {
      // 오른쪽 위
      angle = pi / 4;
      position = Offset(center.dx + distance * 0.7, center.dy - distance * 0.7);
    } else if (direction[0] == 1 && direction[1] == -1) {
      // 왼쪽 아래
      angle = -3 * pi / 4;
      position = Offset(center.dx - distance * 0.7, center.dy + distance * 0.7);
    } else if (direction[0] == 1 && direction[1] == 1) {
      // 오른쪽 아래
      angle = 3 * pi / 4;
      position = Offset(center.dx + distance * 0.7, center.dy + distance * 0.7);
    } else {
      return; // 알 수 없는 방향
    }

    // 삼각형 화살표 그리기
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    final path = Path()
      ..moveTo(0, -arrowSize / 2)
      ..lineTo(-arrowSize / 2, arrowSize / 2)
      ..lineTo(arrowSize / 2, arrowSize / 2)
      ..close();

    // 그림자 효과
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ModernPiecePainter) {
      return oldDelegate.type != type || oldDelegate.owner != owner;
    }
    return true;
  }
}
