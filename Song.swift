//
//  Song.swift
//  SoniX
//
//  Created by Noah Zipor on 27/11/2025.
//


import Foundation

struct Song: Identifiable, Equatable {
    let id: Int
    let title: String
    let artist: String
    let fileName: String
    let artwork: String
}
