//
//  LoadingView.swift
//  USC Films
//
//  Created by Jack  on 4/23/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
      VStack{
        ProgressView()
        Text("Fetching Data...")
          .foregroundColor(Color.gray)
      }
    }
}

