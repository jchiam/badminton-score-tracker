//
//  ContentView.swift
//  Badminton Score Tracker Watch App
//
//  Created by Jonathan Chiam on 17/4/26.
//

import SwiftUI

struct ContentView: View {
    @State private var match: MatchState?

    var body: some View {
        Group {
            if let match {
                if match.gameStatus == .inProgress {
                    ScoringView(match: match)
                } else {
                    GameOverView(match: match, onNewGame: { self.match = nil })
                }
            } else {
                PreGameView { firstServer in
                    match = MatchState(firstServer: firstServer)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
