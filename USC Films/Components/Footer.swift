//
//  Footer.swift
//  USC Films
//
//  Created by Jack  on 4/23/21.
//

import SwiftUI

struct Footer: View {
  var body: some View {
    Link(
      destination:
        URL(string: "https://www.themoviedb.org/?language=en-US")!,
      label: {
        VStack {
          Text("Powered by TMDB")
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(Color.gray)
          Text("Developed by Yingjie Shen")
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(Color.gray)
        }
        
      }
    )
    .frame(maxWidth: .infinity, alignment: .center)
  }
}

