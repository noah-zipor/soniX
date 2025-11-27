import SwiftUI

struct RecentlyPlayedLoaderView: View {
    @EnvironmentObject var audio: AudioManager
    @State private var isLoading = true

    // Banner and placeholder colors
    private let bannerColor = Color(red: 220/255, green: 254/255, blue: 82/255)
    private let placeholderColor = Color(red: 211/255, green: 254/255, blue: 82/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // -----------------------------
            // Banner
            // -----------------------------
            ZStack {
                bannerColor
                Image("LogoBanner")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            }
            .frame(height: 80)

            // -----------------------------
            // Recently Played Section
            // -----------------------------
            Text("Recently Played")
                .font(.title2.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if isLoading {
                        // Always show 5 placeholder cards
                        ForEach(0..<5, id: \.self) { _ in
                            Image("placeholder")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(placeholderColor)
                                .frame(width: 120, height: 120)
                                .cornerRadius(12)
                        }
                    } else {
                        // Show real recently played songs (if any)
                        if audio.recentlyPlayed.isEmpty {
                            Text("No recently played songs")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(audio.recentlyPlayed) { song in
                                VStack {
                                    Image(song.artwork)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(12)
                                    Text(song.title)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .onTapGesture {
                                    audio.currentSong = song
                                    audio.prepareCurrentSong()
                                    audio.play()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 160)
        }
        .onAppear {
            // Show placeholder for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut) {
                    isLoading = false
                }
            }
        }
    }
}

// Preview
struct RecentlyPlayedLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedLoaderView()
            .environmentObject(AudioManager.shared)
    }
}
