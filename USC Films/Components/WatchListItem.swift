//
//  WatchListItem.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//

import SwiftUI

struct WatchListItem: View {
  
  @EnvironmentObject var toastController: ToastController;
  
  var item: Preview = Preview();
  
  var body: some View {
    NavigationLink(
      destination: DetailsView(id: item.id, mediaType: item.mediaType)
    ){
      RemoteImage(url: item.posterPath)
        .aspectRatio(contentMode: .fit)
        .contextMenu{
          Button(
            action: {
              let decoder = JSONDecoder();
              let encoder = JSONEncoder();
              if let data = UserDefaults.standard.data(forKey: "watchList") {
                do {
                  var savedWatchList = try decoder.decode([Preview].self, from: data)
                  do {
                    if let i = savedWatchList.firstIndex(where: {$0.id == item.id }) {
                      savedWatchList.remove(at: i)
                    }
                    let data = try encoder.encode(savedWatchList)
                    UserDefaults.standard.set(data, forKey: "watchList")
                  } catch {
                    print("Unable to Encode Array of Notes (\(error))")
                  }
                } catch {
                  print("Unable to Decode Notes (\(error))")
                }
              }
              self.toastController.displayToaster = true;
              self.toastController.toasterMessage = "\(item.name) was removed from Watchlist"
            },
            label: {
              Text("Remove from watchList")
              Image(systemName: "bookmark.fill")
            }
          )
          .buttonStyle(PlainButtonStyle())
        }
    }
    .buttonStyle(PlainButtonStyle())
  }
}


