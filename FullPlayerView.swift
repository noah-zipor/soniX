import SwiftUI

struct FullPlayerView: View {
    var song: Song
    var namespace: Namespace.ID
    @Binding var showFullPlayer: Bool
    @EnvironmentObject var audio: AudioManager

    @State private var offsetY: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Blurred background
            VisualEffectBlur(blurStyle: .systemMaterialDark)
                .ignoresSafeArea()
                .opacity(0.95)

            VStack(spacing: 20) {
                // Drag handle
                Capsule()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 5)

                Spacer()

                // Artwork
                Image(song.artwork)
                    .resizable()
                    .matchedGeometryEffect(id: "artwork\(song.id)", in: namespace)
                    .frame(width: 300, height: 300)
                    .cornerRadius(15)
                    .shadow(color: Color.green.opacity(0.6), radius: 15, x: 0, y: 10)

                // Title & Artist
                VStack(spacing: 6) {
                    Text(song.title)
                        .font(.title)
                        .bold()
                        .matchedGeometryEffect(id: "title\(song.id)", in: namespace)
                    Text(song.artist)
                        .font(.title3)
                        .foregroundColor(.green)
                        .matchedGeometryEffect(id: "artist\(song.id)", in: namespace)
                }

                // Slider
                Slider(value: $audio.progress, in: 0...audio.duration, onEditingChanged: { editing in
                    if !editing { audio.seek(to: audio.progress) }
                })
                .accentColor(.green)
                .padding(.horizontal)

                // Time labels
                HStack {
                    Text(timeString(from: audio.progress))
                    Spacer()
                    Text(timeString(from: audio.duration))
                }
                .font(.caption)
                .padding(.horizontal)

                // Controls
                HStack(spacing: 50) {
                    Button(action: audio.previousSong) {
                        Image(systemName: "backward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }

                    Button(action: audio.togglePlayPause) {
                        Image(systemName: audio.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                    }

                    Button(action: audio.nextSong) {
                        Image(systemName: "forward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }
                }

                Spacer()
            }
            .padding()
            .offset(y: offsetY + dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        if value.translation.height > 0 { state = value.translation.height }
                    }
                    .onEnded { value in
                        if value.translation.height > 150 {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showFullPlayer = false
                                offsetY = 0
                            }
                        } else {
                            withAnimation(.spring()) {
                                offsetY = 0
                            }
                        }
                    }
            )
            .transition(.move(edge: .bottom))
        }
    }

    private func timeString(from seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
