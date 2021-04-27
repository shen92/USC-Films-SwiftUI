//
//  Result.swift
//  USC Films
//
//  Created by Jack  on 4/27/21.
//

import Foundation

class Result: Identifiable, Equatable {
  static func == (lhs: Result, rhs: Result) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String;
  var name: String;
  var date: String;
  var rate: String;
  var backdropPath: String;
  var mediaType: String;
  
  init() {
    self.id = "";
    self.name = "";
    self.date = "";
    self.rate = "";
    self.backdropPath = "";
    self.mediaType = "";
  }
  
  init(id: String, name: String, date: String, rate: String, backdropPath: String, mediaType: String) {
    self.id = id;
    self.name = name;
    self.date = date;
    self.rate = rate;
    self.backdropPath = backdropPath;
    self.mediaType = mediaType ;
  }
}
