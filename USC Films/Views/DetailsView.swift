//
//  DetailsView.swift
//  USC Films
//
//  Created by Jack  on 4/21/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct DetailsView: View {
  @Environment(\.colorScheme) var colorScheme;
  @Environment(\.openURL) var openURL;
  @EnvironmentObject var toastController: ToastController;
  
  var id: String = "";
  var mediaType: String = "";
  
  @State private var mediaDetails = MediaDetails();
  @State private var videoID: String = "";
  @State private var casts: Array<Cast> = [];
  @State private var reviews: Array<Review> = [];
  @State private var recommendations: Array<Preview> = [];
  
  @State private var showFullDescription: Bool = false;
  @State private var isInWatchList: Bool = false;
  
  func fetchDetails() {
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.mediaType)/\(self.id)/details")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          let title = json["data"]["title"].stringValue;
          let rawDate = self.mediaType == "movie" ?
            json["data"]["release_date"].stringValue :
            json["data"]["first_air_date"].stringValue;
          let dateString = String(rawDate.prefix(4));
          let numGenres = json["data"]["genres"].array?.count ?? 0;
          var genres = ""
          for i in 0..<numGenres - 1 {
            let genre = json["data"]["genres"][i]["name"].stringValue;
            genres += "\(genre), "
          }
          genres += json["data"]["genres"][numGenres - 1]["name"].stringValue;
          let description = json["data"]["overview"].stringValue;
          let rate = String(
            format: "%.1f", json["data"]["vote_average"].floatValue / 2
          );
          let posterPath = json["data"]["poster_path"].stringValue;
          let mediaDetails =
            MediaDetails(
              id: self.id,
              title: title,
              date: dateString,
              genres: genres,
              description: description,
              rate: rate,
              posterPath: posterPath
            )
          self.mediaDetails = mediaDetails;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func fetchVideoId() {
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.mediaType)/\(self.id)/video")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          let numVideos = json["data"].array?.count ?? 0;
          var videoID = ""
          if(numVideos > 1) {
            videoID = json["data"][0]["key"].stringValue;
          }
          self.videoID = videoID;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func fetchCasts() {
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.mediaType)/\(self.id)/casts")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          var numCasts = json["data"].array?.count ?? 0;
          numCasts = numCasts < 10 ? numCasts : 10;
          var castList: Array<Cast> = [];
          for i in 0..<numCasts {
            let id = json["data"][i]["id"].stringValue;
            let name = json["data"][i]["name"].stringValue;
            let profilePath = json["data"][i]["profile_path"].stringValue;
            castList.append(Cast(id: id, name: name, profilePath: profilePath))
          }
          self.casts = castList;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func fetchReviews() {
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.mediaType)/\(self.id)/reviews")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          var numReviews = json["data"].array?.count ?? 0;
          numReviews = numReviews < 3 ? numReviews : 3;
          var reviewList: Array<Review> = [];
          for i in 0..<numReviews {
            let id = String(i);
            let author = json["data"][i]["author"].stringValue;
            let date = json["data"][i]["created_at"].stringValue;
            let rate = String(
              format: "%.1f", json["data"][i]["rating"].floatValue / 2
            );
            let content = json["data"][i]["content"].stringValue;
            reviewList.append(
              Review(
                id: id,
                author: author,
                date: date,
                rate: rate,
                content: content
              )
            )
          }
          self.reviews = reviewList;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func fetchRecommendations() {
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/\(self.mediaType)/\(self.id)/recommended")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          let arrayCount = json["data"].array?.count ?? 0
          var list: Array<Preview> = []
          for i in 0..<arrayCount {
            let mediaType = json["data"][i]["media_type"].stringValue;
            let id = json["data"][i]["id"].stringValue;
            let name = mediaType == "tv" ? json["data"][i]["name"].stringValue : json["data"][i]["title"].stringValue;
            let date = mediaType == "tv" ?
              String(json["data"][i]["first_on_air_date"].stringValue.prefix(4)) :
              String(json["data"][i]["release_date"].stringValue.prefix(4));
            let posterPath = json["data"][i]["poster_path"].stringValue;
            let preview = Preview(id: id, name: name, date: date, posterPath: posterPath, mediaType: mediaType);
            list.append(preview);
          }
          self.recommendations = list;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func isLoaded() -> Bool {
    return
      self.mediaDetails.id != ""
  }
  
  var body: some View {
    VStack{
      if(isLoaded()) {
        ScrollView(.vertical){
          VStack(alignment: .leading) {
            if(self.videoID != ""){
              YoutubePlayer(videoID: self.videoID)
                .frame(maxWidth: .infinity, minHeight: 200.0)
                .lineLimit(self.showFullDescription ? nil : 3);
            }
            Text(self.mediaDetails.title)
              .font(.title)
              .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
              .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            Text("\(self.mediaDetails.date) | \(self.mediaDetails.genres)")
              .font(.body)
              .padding(.top, 4.0)
            HStack{
              Image(systemName: "star.fill")
                .foregroundColor(.red)
              Text("\(self.mediaDetails.rate)/5.0")
                .font(.body)
            }
            .padding(.top, 4.0)
            Text("\(self.mediaDetails.description)")
              .font(.footnote)
              .padding(.top, 4.0)
              .lineLimit(self.showFullDescription ? nil : 3)
            Button(
              action: {
                self.showFullDescription.toggle()
              },
              label: {
                Text("\(self.showFullDescription ? "Show less" : "Show more..")")
                  .foregroundColor(.gray)
                  .font(.callout)
              })
              .frame(maxWidth: .infinity, alignment: .trailing)
            if(casts.count != 0){
              CastList(data: self.casts)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            if(reviews.count != 0){
              ReviewList(data: self.reviews, title: self.mediaDetails.title)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            if(recommendations.count != 0){
              Recommendations(
                data: self.recommendations,
                title: self.mediaType == "movie" ?
                  "Recommended Movies" : "Recommended TV Shows"
              )
              .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
          }
          .padding(.horizontal)
        }
        .navigationBarItems(
          trailing: HStack {
            Button(
              action: {
                let decoder = JSONDecoder();
                let encoder = JSONEncoder();
                if let data = UserDefaults.standard.data(forKey: "watchList") {
                  do {
                    var savedWatchList = try decoder.decode([Preview].self, from: data)
                    do {
                      if !savedWatchList.contains(where: { $0.id == self.id }) {
                        //Append to tail
                        savedWatchList.append(Preview(
                          id: self.id,
                          name: self.mediaDetails.title,
                          date: self.mediaDetails.date,
                          posterPath: self.mediaDetails.posterPath,
                          mediaType: self.mediaType
                        ))
                      } else {
                        //Remove from index
                        if let i = savedWatchList.firstIndex(where: {$0.id == self.id }) {
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
                }
                else {
                  //Create new watchList
                  do {
                    let newWatchList = [Preview(
                      id: self.id,
                      name: self.mediaDetails.title,
                      date: self.mediaDetails.date,
                      posterPath: self.mediaDetails.posterPath,
                      mediaType: self.mediaType
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
                  "\(self.mediaDetails.title) was added to Watchlist":
                  "\(self.mediaDetails.title) was removed from Watchlist"
              },
              label: {
                Image(systemName: self.isInWatchList ? "bookmark.fill" : "bookmark")
                  .foregroundColor(self.isInWatchList ? /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/ :
                                    (colorScheme == .dark ? .white : .black)
                  )
              }
            )
            .buttonStyle(PlainButtonStyle())
            
            
            Button(
              action: {
                openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.youtube.com/watch?v=\(self.videoID)")!)
              },
              label: {
                Image(colorScheme == .dark ? "facebook-dark" : "facebook")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              })
              .buttonStyle(PlainButtonStyle())
            
            Button(
              action: {
                openURL(URL(string: "https://twitter.com/intent/tweet?hashtags=CSCI571USCFilms&text=Check%20out%20this%20link%3A%0Ahttps%3A%2F%2Fwww.themoviedb.org%2F\(self.mediaType)%2F\(self.id)")!)
              },
              label: {
                Image(colorScheme == .dark ? "twitter-dark" : "twitter")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              })
              .buttonStyle(PlainButtonStyle())
            
          })
      }else {
        LoadingView()
      }
    }
    .onAppear {
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            if savedWatchList.contains(where: { $0.id == self.id }) {
              self.isInWatchList = true;
            }
          } catch {
            print("Unable to Encode Array of Notes (\(error))")
          }
        }
      }
      fetchDetails();
      fetchVideoId();
      fetchCasts();
      fetchReviews();
      fetchRecommendations();
    }
    .onChange(of: toastController.displayToaster, perform: { value in
      do {
        let decoder = JSONDecoder();
        if let data = UserDefaults.standard.data(forKey: "watchList") {
          do {
            let savedWatchList = try decoder.decode([Preview].self, from: data)
            if savedWatchList.contains(where: { $0.id == self.id }) {
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

