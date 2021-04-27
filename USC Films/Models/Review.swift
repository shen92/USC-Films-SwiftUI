//
//  Review.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import Foundation

class Review: Identifiable, Equatable {
  static func == (lhs: Review, rhs: Review) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String;
  var author: String;
  var date: String; //ISO 8601 String
  var rate: String
  var content: String
  
  init() {
    self.id = "";
    self.author = "";
    self.date = "";
    self.rate = "";
    self.content = "";
  }
  
  init(id: String, author: String, date: String, rate: String, content: String) {
    self.id = id;
    self.author = author;
    self.date = date;
    self.rate = rate;
    self.content = content;
  }
}
