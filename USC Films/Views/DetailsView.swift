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
  
  var id: String = "";
  var mediaType: String = "";
  
  @State private var mediaDetails = MediaDetails();
  @State private var videoID: String = "";
  @State private var casts: Array<Cast> = [];
  @State private var reviews: Array<Review> = [];
  @State private var recommendations: Array<Preview> = [];
  
  @State private var showFullDescription: Bool = false;
  
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
          let mediaDetails =
            MediaDetails(
              id: self.id,
              title: title,
              date: dateString,
              genres: genres,
              description: description,
              rate: rate
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
                self.showFullDescription = !self.showFullDescription
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
            Image(systemName: "bookmark")
            Image(colorScheme == .dark ? "facebook-dark" : "facebook")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Image(colorScheme == .dark ? "twitter-dark" : "twitter")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          })
      }else {
        LoadingView()
      }
    }
    .onAppear {
      fetchDetails();
      fetchVideoId();
      fetchCasts();
      fetchReviews();
      fetchRecommendations();
    }
    
  }
}
