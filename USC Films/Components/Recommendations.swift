//
//  Recommendations.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI

struct Recommendations: View {
  var data: Array<Preview> = [];
  var title: String = "";
  
  var body: some View {
    VStack(alignment: .leading){
      Text("\(title)")
        .font(.title)
        .fontWeight(.bold)
      ScrollView(.horizontal) {
        HStack(alignment: .top){
          if(data.count != 0){
            ForEach(data) { item in
              NavigationLink(
                destination: DetailsView(id: item.id, mediaType: item.mediaType),
                label: {
                  RemoteImage(url: item.posterPath)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10.0)
                    .frame(width: 110)
                    .padding(.horizontal, 12.0);
                })
            }
          }
        }
      }
    }
    .padding(.vertical)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

