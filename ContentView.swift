import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audio: AudioManager   // REQUIRED
    @State private var selectedSong: Song? = nil
    @State private var showFullPlayer = false


    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // ----------------------------
                        // RECENTLY PLAYED SECTION
                        // ----------------------------
                        RecentlyPlayedLoaderView()
                            .environmentObject(audio)

                        
                        // ----------------------------
                        // ORIGINAL CONTENT
                        // ----------------------------
                        HStack {
                            Text("Recommended Songs")
                                .font(.title3.bold())
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(audio.songs) { song in
                                NavigationLink(destination: SongDetailView(song: song)) {
                                    SongListCard(song: song)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.bottom, 120) // space for miniplayer
                }
                
                // MINI PLAYER BAR
                if let current = audio.currentSong {
                    MiniPlayerBar(song: current)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
