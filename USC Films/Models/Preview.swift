//
//  Preview.swift
//  USC Films
//
//  Created by Jack  on 4/22/21.
//

import Foundation

class Preview: Identifiable, Equatable {
  static func == (lhs: Preview, rhs: Preview) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String;
  var name: String;
  var date: String;
  var posterPath: String;
  var mediaType: String;
  
  init() {
    self.id = "";
    self.name = "";
    self.date = "";
    self.posterPath = "";
    self.mediaType = "";
  }
  
  init(id: String, name: String, date: String, posterPath: String, mediaType: String) {
    self.id = id;
    self.name = name;
    self.date = date;
    self.posterPath = posterPath;
    self.mediaType = mediaType ;
  }
}
