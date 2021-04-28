//
//  WatchList.swift
//  USC Films
//
//  Created by Jack  on 4/22/21.
//

import Foundation

class WatchList: ObservableObject {
  let defaults = UserDefaults.standard;
  @Published var watchList: Array<Preview>;
  
  init(){
    let defaults = UserDefaults.standard;
    let savedWatchList = defaults.object(forKey: "watchList") as? [Preview] ?? [Preview]()
    self.watchList = savedWatchList;
  }
  
  func add(item: Preview){
    self.watchList.append(item)
    defaults.set(self.watchList, forKey: "watchList")
  }
  
  func remove(id: String){
    
  }
  
  
  
}
