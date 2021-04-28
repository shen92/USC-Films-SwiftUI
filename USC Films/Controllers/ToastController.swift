//
//  ToastController.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//

import Foundation

class ToastController: ObservableObject {
  @Published var displayToaster: Bool
  @Published var toasterMessage: String;
  
  init(){
    self.displayToaster = false ;
    self.toasterMessage = "";
  }
}
