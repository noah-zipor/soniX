import SwiftUI

struct SongListCard: View {
    var song: Song

    var body: some View {
        HStack(spacing: 16) {
            Image(song.artwork)
                .resizable()
                .frame(width: 55, height: 55)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(song.title).font(.body.bold())
                Text(song.artist).font(.caption).foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
