//
//  HomeView.swift
//  USC Films
//
//  Created by Jack  on 4/20/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct HomeView: View {
  @State private var contentMode = 1;
  @State private var currentlyPlayingMovies: Array<Preview> = [];
  @State private var topRatedMovies: Array<Preview> = [];
  @State private var popularMovies: Array<Preview> = [];
  @State private var trendingTVShows: Array<Preview> = [];
  @State private var topRatedTVShows: Array<Preview> = [];
  @State private var popularTVShows: Array<Preview> = [];
  
  func fetchMediaList(endpoint: String, action: @escaping (_ result: Array<Preview>) -> Void) {
    AF.request("\(Config.BASE_URL.rawValue)\(endpoint)")
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
          action(list)
          return;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  func isLoaded() -> Bool {
    return
      self.currentlyPlayingMovies.count != 0 &&
      self.topRatedMovies.count != 0 &&
      self.popularMovies.count != 0 &&
      self.trendingTVShows.count != 0 &&
      self.topRatedTVShows.count != 0 &&
      self.popularTVShows.count != 0
  }
  
  var body: some View {
    VStack{
      if(isLoaded()) {
        NavigationView {
          ScrollView(.vertical){
            VStack(alignment: .leading){
              if contentMode == 1 {
                PosterCarousel(title: "Now Playing", data: self.currentlyPlayingMovies)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                PosterList(title: "Top Rated", data: self.topRatedMovies)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/);
                PosterList(title: "Popular", data: self.popularMovies)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/);
                
              } else {
                PosterCarousel(title: "Trending", data: self.trendingTVShows)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/);
                PosterList(title: "Top Rated", data: self.topRatedTVShows)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/);
                PosterList(title: "Popular", data: self.popularTVShows)
                  .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/);
                
              }
              Footer();
            }
            
          }
          .navigationTitle("USC Films")
          .navigationBarItems(
            trailing:
              Button(
                action: {
                  self.contentMode = self.contentMode == 1 ? 2 : 1;
                },
                label: {
                  Text("\(self.contentMode == 1 ? "TV Shows" : "Movies")")
                }
              )
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          .padding(.horizontal)
        }
        .navigationViewStyle(StackNavigationViewStyle())
      }else {
        LoadingView()
      }
    }
    .onAppear{
      fetchMediaList(endpoint: "/api/v1/movies/currently-playing") {
        result in self.currentlyPlayingMovies = result
      }
      fetchMediaList(endpoint: "/api/v1/movies/top-rated") {
        result in self.topRatedMovies = result
      }
      fetchMediaList(endpoint: "/api/v1/movies/popular") {
        result in self.popularMovies = result
      }
      fetchMediaList(endpoint: "/api/v1/tvs/trending") {
        result in self.trendingTVShows = result
      }
      fetchMediaList(endpoint: "/api/v1/tvs/top-rated") {
        result in self.topRatedTVShows = result
      }
      fetchMediaList(endpoint: "/api/v1/tvs/popular") {
        result in self.popularTVShows = result
      }
    }
  }
}

