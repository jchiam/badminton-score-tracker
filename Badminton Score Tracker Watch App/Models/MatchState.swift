import Observation

@Observable
final class MatchState {
    private(set) var myScore: Int = 0
    private(set) var opponentScore: Int = 0
    private(set) var server: Player
    private(set) var gameStatus: GameStatus = .inProgress
    private var history: [MatchEvent] = []

    init(firstServer: Player) {
        self.server = firstServer
    }

    // Derived from server's current score — no separate state needed.
    var serviceCourtSide: CourtSide {
        let serverScore = server == .me ? myScore : opponentScore
        return serverScore % 2 == 0 ? .right : .left
    }

    var canUndo: Bool { !history.isEmpty }

    func scorePoint(for player: Player) {
        guard gameStatus == .inProgress else { return }
        history.append(MatchEvent(myScore: myScore, opponentScore: opponentScore, server: server))
        if player == .me {
            myScore += 1
        } else {
            opponentScore += 1
        }
        server = player
        checkWinCondition()
    }

    func undo() {
        guard let last = history.popLast() else { return }
        myScore = last.myScore
        opponentScore = last.opponentScore
        server = last.server
        gameStatus = .inProgress
    }

    // BWF singles win conditions:
    //   • First to 21 with a 2-point lead
    //   • At 20-all: first to gain a 2-point lead
    //   • At 29-all: next point wins (cap at 30)
    private func checkWinCondition() {
        let maxScore = max(myScore, opponentScore)
        let minScore = min(myScore, opponentScore)
        guard maxScore >= 21 else { return }
        guard maxScore >= 30 || maxScore - minScore >= 2 else { return }
        gameStatus = myScore > opponentScore ? .won : .lost
    }
}
