//
//  SearchView.swift
//  USC Films
//
//  Created by Jack  on 4/20/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct SearchView: View {
  @State private var searchString: String = "";
  @State private var isEditing: Bool = false
  @State private var searchResults: Array<Result> = [];
  @State private var loaded = false;
  
  let debouncer = Debouncer(delay: 0.5)
  
  func fetchMediaList() {
    let validSearchString = self.searchString.replacingOccurrences(of: " ", with: "%20")
    AF.request("\(Config.BASE_URL.rawValue)/api/v1/search/\(validSearchString)")
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value);
          let arrayCount = json["data"].array?.count ?? 0
          var list: Array<Result> = []
          for i in 0..<arrayCount {
            let mediaType = json["data"][i]["media_type"].stringValue;
            let id = json["data"][i]["id"].stringValue;
            let name = json["data"][i]["name"].stringValue;
            let date = String(json["data"][i]["date"].stringValue.prefix(4));
            let rate = String(
              format: "%.1f", json["data"][i]["rate"].floatValue / 2
            );
            let backdropPath = json["data"][i]["backdrop_path"].stringValue;
            list.append(Result(id: id, name: name, date: date, rate: rate, backdropPath: backdropPath, mediaType: mediaType));
          }
          self.searchResults = list;
          self.loaded = true;
        case .failure(let error):
          print(error)
        }
      }
  }
  
  var body: some View {
    NavigationView{
      VStack{
        HStack {
          HStack {
            TextField("Search Movies, TVs...", text: $searchString)
              .padding(.horizontal, 27)
          }
          .padding(7)
          .background(Color(.systemGray6))
          .cornerRadius(10)
          .onTapGesture {
            self.isEditing = true
          }
          .overlay(
            HStack {
              Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray2))
                .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  alignment: .leading
                )
                .padding(.leading, 8.0)
              
              if isEditing && self.searchString != "" {
                Button(action: {
                  self.searchString = "";
                  self.loaded = false;
                }, label: {
                  Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8.0)
                })
              }
            }
          )
          .transition(.move(edge: .trailing))
          .animation(.linear)
          
          if isEditing {
            Button(action: {
              self.isEditing = false;
              self.searchString = "";
              self.loaded = false;
              hideKeyboard();
            }, label: {
              Text("Cancel")
            })
            .transition(
              .asymmetric(insertion: .move(edge: .trailing), removal: .opacity)
            )
            .animation(.linear)
          }
          
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        VStack{
          if(self.loaded && self.searchResults.count == 0){
            Text("No Results")
              .font(.title2)
              .foregroundColor(.gray)
              .padding(.top)
          }else {
            ScrollView(.vertical){
              if(searchResults.count != 0){
                ForEach(self.searchResults) { result in
                  ResultCard(result: result)
                }
              }
            }
          }}
          .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
      }
      .padding(.horizontal)
      .navigationTitle("Search")
    }
    
    .navigationViewStyle(StackNavigationViewStyle())
    .onChange(of: searchString) { _ in
      debouncer.run{
        self.loaded = false;
        if(self.searchString.count >= 3){
          fetchMediaList()
        }
      }
    }
  }
}

