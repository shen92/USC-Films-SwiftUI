//
//  Cast.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import Foundation

class Cast: Identifiable, Equatable {
  static func == (lhs: Cast, rhs: Cast) -> Bool {
    return lhs.id == rhs.id
  }
  
  var id: String;
  var name: String;
  var profilePath: String;
  
  init(id: String, name: String, profilePath: String) {
    self.id = id;
    self.name = name;
    self.profilePath = profilePath;
  }
}
