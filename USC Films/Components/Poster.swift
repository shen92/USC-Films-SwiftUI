//
//  Poster.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//

import SwiftUI

struct Poster: View {
  @Environment(\.colorScheme) var colorScheme;
  
  @EnvironmentObject var toastController: ToastController;
  @State private var isInWatchList = false;
  
  
  var item: Preview = Preview();
  
  var body: some View {
    NavigationLink(
      destination: DetailsView(id: item.id, mediaType: item.mediaType)
    ){
      VStack(alignment: .center){
        RemoteImage(url: item.posterPath)
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10.0)
          .frame(width: 92)
        Text("\(item.name)")
          .font(.caption)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .frame(width: 92)
        Text("(\(item.date))")
          .font(.caption)
          .multilineTextAlignment(.center)
          .frame(width: 92)
          .foregroundColor(Color.gray);
      }
      .background(colorScheme == .dark ? Color.black: Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .contentShape(RoundedRectangle(cornerRadius: 10))
      .contextMenu{
        VStack {
          Button(
            action: {
              let decoder = JSONDecoder();
              let encoder = JSONEncoder();
              if let data = UserDefaults.standard.data(forKey: "watchList") {
                do {
                  var savedWatchList = try decoder.decode([Preview].self, from: data)
                  do {
                    if !savedWatchList.contains(where: { $0.id == item.id }) {
                      //Append to tail
                      savedWatchList.append(Preview(
                        id: item.id,
                        name: item.name,
                        date: item.date,
                        posterPath: item.posterPath,
                        mediaType: item.mediaType
                      ))
                    } else {
                      //Remove from index
                      if let i = savedWatchList.firstIndex(where: {$0.id == item.id }) {
                        savedWatchList.remove(at: i)
                      }
                    }
                    let data = try encoder.encode(savedWatchList)
                    UserDefaults.standard.set(data, forKey: "watchList")
                  } catch {
                    print("Unable to Encode Array of Notes (\(error))")
                  }
                } catch {
                  print("Unable to Decode Notes (\(error))")
                }
              } else {
                //Create new watchList
                do {
                  let newWatchList = [Preview(
                    id: item.id,
                    name: item.name,
                    date: item.date,
                    posterPath: item.posterPath,
                    mediaType: item.mediaType
                  )];
                  let data = try encoder.encode(newWatchList)
                  UserDefaults.standard.set(data, forKey: "watchList")
                } catch {
                  print("Unable to Encode Array of Notes (\(error))")
                }
              }
              self.isInWatchList.toggle()
              self.toastController.displayToaster = true;
              self.toastController.toasterMessage = self.isInWatchList ?
                "\(item.name) was added to Watchlist":
                "\(item.name) was removed from Watchlist"
            },
            label: {
              Text(self.isInWatchList ? "Remove from watchList" : "Add to watchList")
              Image(systemName: self.isInWatchList ? "bookmark.fill" : "bookmark")
            }
          )
          .buttonStyle(PlainButtonStyle())
          
          Button(
            action: {},
            label: {
              HStack{
                Text("Share on Facebook")
                Image(colorScheme == .dark ? "facebook-dark" : "facebook")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              }
            }
          )
          Button(
            action: {},
            label: {
              HStack{
                Text("Share on Twitter")
                Image(colorScheme == .dark ? "twitter-dark" : "twitter")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              }
            }
          )
        }
      }
      
    }
    .buttonStyle(PlainButtonStyle())
    
    .onAppear {
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            if savedWatchList.contains(where: { $0.id == item.id }) {
              self.isInWatchList = true;
            }
          } catch {
            print("Unable to Encode Array of Notes (\(error))")
          }
        } else {
          self.isInWatchList = false;
        }
      }
    }
    
  }
}

