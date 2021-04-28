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
  @State private var target: Preview = Preview();
  
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
                NavigationLink(
                  destination: DetailsView(id: item.id, mediaType: item.mediaType)
                ){
                  RemoteImage(url: item.posterPath)
                    .aspectRatio(contentMode: .fit)
                    .onDrag({
                      self.target = item;
                      return NSItemProvider(
                        contentsOf: URL(string: "\(item.id)")!
                      )!
                    })
                    .onDrop(
                      of: [.url],
                      delegate:
                        DropViewDelegate(
                          target: self.target,
                          destination: item,
                          watchList: $watchList
                        )
                    )
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
    .onChange(of: watchList, perform: { value in
      do {
        let encoder = JSONEncoder();
        let data = try encoder.encode(self.watchList)
        UserDefaults.standard.set(data, forKey: "watchList")
      } catch {
        print("Unable to Encode Array of Notes (\(error))")
      }
      
    })
  }
}
