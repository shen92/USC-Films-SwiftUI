//
//  SwimmingPool.swift
//  USC Films
//
//  Created by Jack  on 4/21/21.
//

import SwiftUI

struct PosterList: View {
  @Environment(\.colorScheme) var colorScheme;
  @State private var isInWatchList = false;
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
            ForEach(self.data){ item in
              Poster(item: item)
                .padding(.trailing)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
  }
}
