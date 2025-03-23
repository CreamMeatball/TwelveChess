# Twelve Chess

Twelve Chess is modern chess played on a small board with only 12 squares.  
It's known by names like Let's Catch the Lion! or どуぶつしょуぎ or Animal Janggi.  
Also, It was featured on the Korean brain survival TV show “The Genius” under the name “십이장기”.  
[십이장기](https://namu.wiki/w/%EC%8B%AD%EC%9D%B4%EC%9E%A5%EA%B8%B0)  

## Game Rule

### English

1. 'Twelve Chess' is played on a game board with 12 squares, four horizontal and three vertical, and the three squares directly in front of the players are their respective factions.
2. 2 players are given 1 of each of the 4 types of pieces, and each piece starts the game in its designated position.
3. Each piece can only move in the direction indicated on the piece, and their roles are as follows
1) General (G): This piece is placed on the right side of your faction and can move forward, backward, left, and right.
2) Minister (M). This piece is placed to the left of your faction and can move in four diagonal directions.
3) King (K). Located in the center of your faction and can move forward, backward, left, right, and diagonally in all directions.
4) Soldier (S). Positioned in front of the King and can only move forward.
However, Soldier (S) flips over to become Marquis (Q) when it enters the opposing faction. The Marquis (Q) can move in all directions except diagonally backward.
4. At the beginning of the game, each player may move 1 piece 1 space. If you move a piece to capture an opponent's piece, you capture that piece, and you can use the captured piece as your own piece on your next turn.
5. Placing a captured piece on the board also costs a turn, and it cannot be placed on a piece already on the board or in an opponent's camp.
6. If a player captures an opponent's Marquis (Q) and uses it as a piece, it is flipped to Soldier (S).
7. The game ends when a player captures an opponent's King (K), and that player wins.
8. If a player's King (K) enters his opponent's camp and survives one turn until it is his turn again, the game ends with that player winning.
* All pieces cannot be turned in any direction.
* When using a captured piece, you are free to use it on any turn you want, and you do not have to use it if you do not want to.

### Korean

1. 'Twelve Chess'는 가로 4칸, 세로 3칸 총 12칸으로 이루어진 게임 판에서 진행되며 플레이어들의 바로 앞쪽 3칸이 각자의 진영이 된다.
2. 플레이어 2명에게는 4가지 종류의 말이 1개씩 주어지며 각 말은 지정된 위치에 놓인 상태로 게임을 시작한다.
3. 각 말들은 말에 표시된 방향으로만 이동할 수 있으며 각각의 역할은 다음과 같다.
4) General(G) 자신의 진영 오른쪽에 놓이는 말로 앞, 뒤와 좌, 우로 이동이 가능하다.
5) Minister(M). 자신의 진영 왼쪽에 놓이며 대각선 4방향으로 이동할 수 있다.
6) King(K). 자신의 진영 중앙에 위치하며 앞, 뒤, 좌, 우, 대각선 방향까지 모든 방향으로 이동이 가능하다.
7) Soldier(S). 왕의 앞에 놓이며 오로지 앞으로만 이동할 수 있다.
하지만, Soldier(S)는 상대 진영에 들어가면 뒤집어서 Marquis(Q)로 사용된다. Marquis(Q)는 대각선 뒤쪽 방향을 제외한 전 방향으로 이동할 수 있다.
1. 게임이 시작되면 선 플레이어부터 말 1개를 1칸 이동시킬 수 있다. 말을 이동시켜 상대방의 말을 잡은 경우, 해당 말을 포로로 잡게 되며 포로로 잡은 말은 다음 턴부터 자신의 말로 사용할 수 있다.
2. 게임 판에 포로로 잡은 말을 내려놓는 행동도 턴을 소모하는 것이며 이미 말이 놓여진 곳이나 상대의 진영에는 말을 내려놓을 수 없다.
3. 상대방의 Marquis(Q)를 잡아 자신의 말로 사용할 경우에는 Soldier(S)로 뒤집어서 사용하게 된다.
4. 게임은 한 플레이어가 상대방의 King(K)을 잡으면 해당 플레이어의 승리로 종료된다.
5. 만약 자신의 King(K)이 상대방의 진영에 들어가 자신의 턴이 다시 돌아올 때까지 한 턴을 버틸 경우 해당 플레이어의 승리로 게임이 종료된다.
* 모든 말의 방향 회전은 불가능하다.
* 잡은 말을 사용할 땐 자신이 원하는 턴에 자유롭게 사용가능 하며 원하지 않으면 사용하지 않아도 무관하다.

## Features (to be updated)

- Cross-platform support (iOS, Android, macOS, Windows, Linux, Web)
- Modern and intuitive user interface
- Customizable game settings
- Single-player mode against AI
- Multi-player mode for local and online play
- Game history and statistics tracking
- Responsive design that works across various device sizes

## Screenshots

![Image](https://github.com/user-attachments/assets/d801bd6e-c240-4101-8732-54d4e716cbae)

## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart](https://dart.dev/get-dart) (installed with Flutter)
- An IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- For iOS development: Xcode (Mac only)
- For Android development: Android Studio and Android SDK
- For web development: Chrome browser

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/twelvechess.git
   cd twelvechess
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the application
   ```bash
   flutter run
   ```

## Building for Different Platforms

### Android

```bash
flutter build apk --release
```

The built APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

Open the iOS project in Xcode to archive and distribute:
```bash
open ios/Runner.xcworkspace
```

### Web

```bash
flutter build web --release
```

The built web app will be located at `build/web`

### macOS

```bash
flutter build macos --release
```

### Windows

```bash
flutter build windows --release
```

### Linux

```bash
flutter build linux --release
```

## Architecture

This project follows the [describe your architecture pattern here] architecture pattern, organizing code into the following directories:

- `lib/models/`: Data models
- `lib/screens/`: UI screens
- `lib/widgets/`: Reusable UI components
- `lib/services/`: Business logic and services
- `lib/utils/`: Utility functions and constants

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- As a fan of 'The Genius', I implemente a game of '십이장기' with Flutter. Thanks to Jung Jong-yeon PD.

## Contact

CreamMeatball - pch5445@gmail.com

Project Link: [TwelveChess](https://github.com/CreamMeatball/TwelveChess)
