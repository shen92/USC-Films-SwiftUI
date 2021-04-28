//
//  YoutubePlayer.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI
import youtube_ios_player_helper

struct YTWrapper : UIViewRepresentable {
  var videoID : String = "";
  
  func makeUIView(context: Context) -> YTPlayerView {
    let playerView = YTPlayerView()
    playerView.load(withVideoId: videoID, playerVars: ["playsinline" : 1])
    return playerView
  }
  
  func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}

struct YoutubePlayer: View {
  var videoID: String
  var body: some View {
    YTWrapper(videoID: self.videoID)
  }
}

