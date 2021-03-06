//
//  Poster.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Poster: View {
  @Environment(\.colorScheme) var colorScheme;
  @Environment(\.openURL) var openURL
  
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
              HStack{
                Text(self.isInWatchList ? "Remove from watchList" : "Add to watchList")
                Image(systemName: self.isInWatchList ? "bookmark.fill" : "bookmark")
              }
            }
          )
          .buttonStyle(PlainButtonStyle())
          
          Button(
            action: {
              AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.item.mediaType)/\(self.item.id)/video")
                .validate()
                .responseJSON { (response) in
                  switch response.result {
                  case .success(let value):
                    let json = JSON(value);
                    let videoID = json["data"][0]["key"].stringValue;
                    openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.youtube.com/watch?v=\(videoID)")!)
                  case .failure(let error):
                    print(error)
                  }
                }
            },
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
            action: {
              openURL(URL(string: "https://twitter.com/intent/tweet?hashtags=CSCI571USCFilms&text=Check%20out%20this%20link%3A%0Ahttps%3A%2F%2Fwww.themoviedb.org%2F\(self.item.mediaType)%2F\(self.item.id)")!)
            },
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
    .onChange(of: self.toastController.displayToaster, perform: { value in
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            if savedWatchList.contains(where: { $0.id == item.id }) {
              self.isInWatchList = true;
            } else {
              self.isInWatchList = false;
            }
          } catch {
            print("Unable to Encode Array of Notes (\(error))")
          }
        }
      }
    })
  }
}

