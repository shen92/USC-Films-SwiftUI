//
//  CastSwimmingPool.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI
import Kingfisher

struct CastList: View {
  @Environment(\.colorScheme) var colorScheme;
  var data: Array<Cast> = [];
  
  var body: some View {
    VStack(alignment: .leading){
      Text("Cast & Crew")
        .font(.title)
        .fontWeight(.bold)
        .padding(.bottom, 5.0)
      ScrollView(.horizontal) {
        HStack(alignment: .top){
          if(data.count != 0){
            ForEach(data) { item in
              VStack(alignment: .center){
                KFImage(URL(string: item.profilePath))
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 90.0, height: 90.0)
                  .clipShape(Circle())
                  .overlay(Circle().stroke(Color.white, lineWidth: 1))
                Text("\(item.name)")
                  .font(.caption)
                  .multilineTextAlignment(.center)
                  .foregroundColor(colorScheme == .dark ? .white: .black)
                  .padding(.top, 4.0)
              }
            }
          }
        }
      }
    }
    .padding(.top)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

