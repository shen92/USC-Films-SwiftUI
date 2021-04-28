//
//  DropViewDelegate.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//
import SwiftUI

import Foundation

struct DropViewDelegate: DropDelegate {
  var target: Preview;
  var destination: Preview;
  @Binding var watchList: Array<Preview>;
  
  func performDrop(info: DropInfo) -> Bool {
    return true;
  }
  
  func dropEntered(info: DropInfo) {
    let targetIndex = watchList.firstIndex(where: {$0.id == target.id}) ?? 0;
    let destinationIndex = watchList.firstIndex(where: {$0.id == destination.id}) ?? 0;
    
    if(targetIndex != destinationIndex) {
      withAnimation(.default) {
        let tmp = self.watchList[targetIndex];
        self.watchList[targetIndex] = self.watchList[destinationIndex];
        self.watchList[destinationIndex] = tmp;
      }
    }
  }
  
  func dropUpdated(info: DropInfo) -> DropProposal? {
    return DropProposal(operation: .move)
  }
}
