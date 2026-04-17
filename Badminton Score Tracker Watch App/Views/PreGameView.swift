import SwiftUI

struct PreGameView: View {
    let onStart: (Player) -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Who serves first?")
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Button("Me") { onStart(.me) }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                Button("Them") { onStart(.opponent) }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    PreGameView { _ in }
}
