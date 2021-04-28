//
//  WatchListView.swift
//  USC Films
//
//  Created by Jack  on 4/20/21.
//

import SwiftUI

struct WatchListView: View {
  @EnvironmentObject var toastController: ToastController;
  
  @State private var watchList: Array<Preview> = [];
  
  let columns = [
    GridItem(.adaptive(minimum: 100))
  ]
  
  var body: some View {
    VStack {
      if(self.watchList.count != 0){
        NavigationView(){
          ScrollView(.vertical){
            LazyVGrid(columns: columns) {
              ForEach(self.watchList) { item in
                WatchListItem(item: item)
              }
            }
            .padding(.horizontal)
          }.navigationTitle("Watchlist")
        }
        .navigationViewStyle(StackNavigationViewStyle())
      } else {
        Text("Watchlist is empty")
          .foregroundColor(.gray)
      }
    }
    .onAppear{
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            self.watchList = savedWatchList;
          } catch {
            print("Unable to Encode Array of Notes (\(error))")
          }
        }
      }
    }
    .onChange(of: self.toastController.displayToaster, perform: { value in
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            self.watchList = savedWatchList;
          } catch {
            print("Unable to Encode Array of Notes (\(error))")
          }
        }
      }
    })
  }
}
