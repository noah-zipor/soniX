import SwiftUI
import Combine

struct SongDetailView: View {
    @EnvironmentObject var audio: AudioManager
    var song: Song
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(Circle())
                }
                Spacer()
                
                Text("Now Playing")
                    .font(.headline.bold())
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                Spacer().frame(width: 40)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    
                    // MARK: - Song Header
                    HStack(spacing: 20) {
                        Image(song.artwork)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .cornerRadius(22)
                            .shadow(color: Color.blue.opacity(0.3), radius: 14, x: 0, y: 6)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(song.title)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            Text(song.artist)
                                .foregroundColor(.white.opacity(0.7))
                                .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: - Play Button
                    Button {
                        audio.currentSong = song
                        audio.prepareCurrentSong()
                        audio.play()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.headline.bold())
                            Text("Play")
                                .font(.headline.bold())
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [Color.blue, Color.cyan],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(18)
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: - Suggested Songs
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Songs Like This")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        VStack(spacing: 14) {
                            ForEach(audio.songs) { s in
                                SongListCard(song: s)
                                    .environmentObject(audio)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 160)
            }
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}
