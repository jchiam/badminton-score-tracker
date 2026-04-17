import SwiftUI
import WatchKit

struct GameOverView: View {
    let match: MatchState
    let onNewGame: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(match.gameStatus == .won ? "You won!" : "You lost")
                .font(.headline)

            Text("\(match.myScore) – \(match.opponentScore)")
                .font(.title3.bold())
                .foregroundStyle(.secondary)

            Button("New Game", action: onNewGame)
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
        }
        .padding()
        .onAppear {
            WKInterfaceDevice.current().play(match.gameStatus == .won ? .success : .failure)
        }
    }
}

#Preview {
    GameOverView(match: MatchState(firstServer: .me), onNewGame: {})
}
