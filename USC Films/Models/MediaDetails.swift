//
//  Media.swift
//  USC Films
//
//  Created by Jack  on 4/22/21.
//

import Foundation

class MediaDetails: Identifiable, Equatable {
  static func == (lhs: MediaDetails, rhs: MediaDetails) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String;
  var title: String;
  var date: String;
  var genres: String;
  var description: String;
  var rate: String;
  
  init(){
    self.id = "";
    self.title = "";
    self.date = "";
    self.genres = "";
    self.description = "";
    self.rate = "";
  }
  
  init(id:String, title: String, date: String, genres: String, description: String, rate: String) {
    self.id = id;
    self.title = title;
    self.date = date;
    self.genres = genres;
    self.description = description;
    self.rate = rate;
  }
}
