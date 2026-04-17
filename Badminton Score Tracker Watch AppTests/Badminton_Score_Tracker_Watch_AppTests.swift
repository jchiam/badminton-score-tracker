import Testing
@testable import Badminton_Score_Tracker_Watch_App

// MatchState is @MainActor (SWIFT_DEFAULT_ACTOR_ISOLATION=MainActor in the app target).
// Annotate the suite so all tests run on the main actor without async boilerplate.
@MainActor
struct Badminton_Score_Tracker_Watch_AppTests {

    // Scores toward myTarget/oppTarget while keeping the difference <= 1 at each
    // step, so no premature win is triggered while building up to deuce scores.
    private func scoreToTarget(match: MatchState, myTarget: Int, oppTarget: Int) {
        while match.myScore < myTarget || match.opponentScore < oppTarget {
            guard match.gameStatus == .inProgress else { return }
            let myRemaining = myTarget - match.myScore
            let oppRemaining = oppTarget - match.opponentScore
            match.scorePoint(for: myRemaining >= oppRemaining ? .me : .opponent)
        }
    }

    // MARK: - Service Court Side

    @Test func scoreZeroServesFromRight() {
        let match = MatchState(firstServer: .me)
        #expect(match.serviceCourtSide == .right)
    }

    @Test func scoreOneServesFromLeft() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)
        #expect(match.serviceCourtSide == .left)
    }

    @Test func scoreTwoServesFromRight() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)
        match.scorePoint(for: .me)
        #expect(match.serviceCourtSide == .right)
    }

    // MARK: - Service Transfer

    @Test func receiverWinTransfersServe() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .opponent)
        #expect(match.server == .opponent)
    }

    @Test func serverWinRetainsServe() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)
        #expect(match.server == .me)
    }

    // MARK: - Win Conditions

    @Test func winAt21With0() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 21, oppTarget: 0)
        #expect(match.gameStatus == .won)
    }

    @Test func noWinAtDeuce20_20() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 20, oppTarget: 20)
        #expect(match.gameStatus == .inProgress)
    }

    @Test func noWinAt21_20() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 21, oppTarget: 20)
        #expect(match.gameStatus == .inProgress)
    }

    @Test func winAt22_20Deuce() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 22, oppTarget: 20)
        #expect(match.gameStatus == .won)
    }

    @Test func noWinAt29_29() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 29, oppTarget: 29)
        #expect(match.gameStatus == .inProgress)
    }

    @Test func winAt30_29Cap() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 30, oppTarget: 29)
        #expect(match.gameStatus == .won)
    }

    @Test func opponentWinDetected() {
        let match = MatchState(firstServer: .opponent)
        scoreToTarget(match: match, myTarget: 0, oppTarget: 21)
        #expect(match.gameStatus == .lost)
    }

    // MARK: - Undo

    @Test func cannotUndoAtStart() {
        let match = MatchState(firstServer: .me)
        #expect(match.canUndo == false)
    }

    @Test func canUndoAfterPoint() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)
        #expect(match.canUndo == true)
    }

    @Test func undoRestoresScore() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .opponent)
        match.undo()
        #expect(match.myScore == 0)
        #expect(match.opponentScore == 0)
    }

    @Test func undoRestoresServer() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .opponent)
        match.undo()
        #expect(match.server == .me)
    }

    @Test func undoAcrossServiceTransfer() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)       // me: 1, server=me
        match.scorePoint(for: .opponent) // opp: 1, server=opponent
        match.undo()
        #expect(match.server == .me)
        #expect(match.myScore == 1)
        #expect(match.opponentScore == 0)
    }

    @Test func undoResetsGameOver() {
        let match = MatchState(firstServer: .me)
        scoreToTarget(match: match, myTarget: 21, oppTarget: 0)
        #expect(match.gameStatus == .won)
        match.undo()
        #expect(match.gameStatus == .inProgress)
    }

    @Test func multipleUndosWork() {
        let match = MatchState(firstServer: .me)
        match.scorePoint(for: .me)
        match.scorePoint(for: .me)
        match.scorePoint(for: .me)
        match.undo()
        match.undo()
        match.undo()
        #expect(match.myScore == 0)
        #expect(match.canUndo == false)
    }
}
