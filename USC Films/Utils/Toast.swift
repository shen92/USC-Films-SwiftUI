//
//  Toast.swift
//  USC Films
//
//  Created by Jack  on 4/28/21.
//

import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
  
  /// The binding that decides the appropriate drawing in the body.
  @EnvironmentObject var toastController: ToastController;
  /// The view that will be "presenting" this toast
  let presenting: () -> Presenting
  /// The text to show
  let text: Text
  
  var body: some View {
    
    GeometryReader { geometry in
      
      ZStack(alignment: .bottom) {
        
        self.presenting()
        
        VStack {
          self.text
        }
        .frame(
          width: geometry.size.width * 0.8,
          height: geometry.size.height / 10)
        .background(Color.gray)
        .foregroundColor(Color.primary)
        .cornerRadius(geometry.size.height / 5)
        .transition(.slide)
        .opacity(self.toastController.displayToaster ? 1 : 0)
        .onChange(of: self.toastController.displayToaster, perform: { value in
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
              self.toastController.displayToaster = false;
            }
          }
        })
      }
    }
  }
}

extension View {
  
  func toast(text: Text) -> some View {
    Toast(presenting: { self },text: text)
  }
  
}
