//
//  SwimmingPool.swift
//  USC Films
//
//  Created by Jack  on 4/21/21.
//

import SwiftUI

struct PosterList: View {
  @Environment(\.colorScheme) var colorScheme;
  var title: String = "";
  var data: Array<Preview> = [];
  
  var body: some View {
    VStack(alignment: .leading){
      Text("\(title)")
        .font(.title2)
        .fontWeight(.bold)
      ScrollView(.horizontal) {
        HStack(alignment: .top){
          if(data.count != 0){
            ForEach(data) { item in
              NavigationLink(
                destination: DetailsView(id: item.id, mediaType: item.mediaType),
                label: {
                  VStack(alignment: .center){
                    RemoteImage(url: item.posterPath)
                      .aspectRatio(contentMode: .fit)
                      .cornerRadius(10.0)
                      .frame(width: 92);
                    Text("\(item.name)")
                      .font(.caption)
                      .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                      .multilineTextAlignment(.center)
                      .frame(width: 92)
                      .foregroundColor(colorScheme == .dark ? .white: .black);
                    Text("(\(item.date))")
                      .font(.caption)
                      .multilineTextAlignment(.center)
                      .frame(width: 92)
                      .foregroundColor(Color.gray);
                  }
                  .padding(.trailing)
                })
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

