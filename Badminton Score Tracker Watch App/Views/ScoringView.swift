import SwiftUI
import WatchKit

struct ScoringView: View {
    let match: MatchState

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                HStack(spacing: 1) {
                    scoreButton(for: .me, width: (geo.size.width - 1) / 2, height: geo.size.height)
                    scoreButton(for: .opponent, width: (geo.size.width - 1) / 2, height: geo.size.height)
                }

                if match.canUndo {
                    Button(action: match.undo) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 4)
                }
            }
        }
    }

    @ViewBuilder
    private func scoreButton(for player: Player, width: CGFloat, height: CGFloat) -> some View {
        let isServer = match.server == player
        let score = player == .me ? match.myScore : match.opponentScore
        let label = player == .me ? "YOU" : "OPP"

        Button {
            WKInterfaceDevice.current().play(.click)
            match.scorePoint(for: player)
        } label: {
            VStack(spacing: 2) {
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                Spacer()

                Text("\(score)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)

                Spacer()

                // Court side indicator — keeps layout stable when not serving
                Group {
                    if isServer {
                        Text(match.serviceCourtSide == .right ? "● R" : "L ●")
                            .foregroundStyle(.yellow)
                    } else {
                        Text("●").foregroundStyle(.clear)
                    }
                }
                .font(.system(size: 10, weight: .medium))
                .padding(.bottom, 6)
            }
            .frame(width: width, height: height)
            .background(isServer ? Color.white.opacity(0.07) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScoringView(match: MatchState(firstServer: .me))
}
