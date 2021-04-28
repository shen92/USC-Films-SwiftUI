//
//  USC_FilmsApp.swift
//  USC Films
//
//  Created by Jack  on 4/20/21.
//

import SwiftUI

@main
struct USC_FilmsApp: App {
  @ObservedObject var toastController: ToastController = ToastController();
  
  var body: some Scene {
    WindowGroup {
      AppView().environmentObject(toastController)
    }
  }
}
