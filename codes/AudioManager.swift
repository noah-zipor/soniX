import Foundation
import AVFoundation
import SwiftUI
import Combine

class AudioManager: ObservableObject {
    static let shared = AudioManager()

    @Published var isPlaying = false
    @Published var currentSong: Song?
    @Published var progress: Double = 0
    @Published var duration: Double = 0
    @Published var songs: [Song] = []

    @Published var recentlyPlayed: [Song] = []

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    private init() {
        loadSongs()
    }

    func loadSongs() {
        songs = [
            Song(id: 1, title: "Kids - Instrumental", artist: "MGMT", fileName: "song1", artwork: "kids"),
            Song(id: 2, title: "Spring In My Step", artist: "Silent Partner", fileName: "song2", artwork: "spring"),
            Song(id: 3, title: "Cold Heart", artist: "Elton John, Dua Lipa", fileName: "song3", artwork: "johnny"),
            Song(id: 4, title: "This is the greatest show", artist: "The Greatest Showman", fileName: "song4", artwork: "show"),
            Song(id: 5, title: "See You Again", artist: "Tyler The Creator", fileName: "song5", artwork: "tyler"),
            Song(id: 6, title: "California Gurls", artist: "Katy Perry ft. Snoop Dogg", fileName: "song6", artwork: "katy"),
            Song(id: 7, title: "Can't Stop The Feeling", artist: "Justin Timberlake", fileName: "song7", artwork: "justin")
        ]
        currentSong = songs.first
        prepareCurrentSong()
    }

    func prepareCurrentSong() {
        guard let song = currentSong,
              let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else {
            audioPlayer = nil
            duration = 0
            progress = 0
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
            progress = 0
        } catch {
            print("Audio load error:", error)
            audioPlayer = nil
            duration = 0
            progress = 0
        }
    }

    func play() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()

        // UPDATE RECENTLY PLAYED
        if let song = currentSong {
            recentlyPlayed.removeAll { $0.id == song.id }
            recentlyPlayed.insert(song, at: 0)
            if recentlyPlayed.count > 10 {
                recentlyPlayed.removeLast()
            }
        }
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }

    func togglePlayPause() {
        isPlaying ? pause() : play()
    }

    func seek(to value: Double) {
        audioPlayer?.currentTime = value
        progress = value
    }

    func nextSong() {
        guard let current = currentSong,
              let index = songs.firstIndex(of: current) else { return }
        let nextIndex = (index + 1) % songs.count
        currentSong = songs[nextIndex]
        prepareCurrentSong()
        play()
    }

    func previousSong() {
        guard let current = currentSong,
              let index = songs.firstIndex(of: current) else { return }
        let prevIndex = (index - 1 + songs.count) % songs.count
        currentSong = songs[prevIndex]
        prepareCurrentSong()
        play()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.progress = player.currentTime
            if player.currentTime >= player.duration {
                self.nextSong()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
