import SwiftUI

struct MiniPlayerBar: View {
    @EnvironmentObject var audio: AudioManager   // REQUIRED
    var song: Song

    var body: some View {
        HStack(spacing: 12) {
            Image(song.artwork)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.subheadline.bold())
                Text(song.artist)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: { audio.togglePlayPause() }) {
                Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)
            }

            Button(action: audio.nextSong) {
                Image(systemName: "forward.fill")
                    .font(.title3)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
