//
//  Carousel.swift
//  USC Films
//
//  Created by Jack  on 4/21/21.
//

import SwiftUI
import Kingfisher

struct PosterCarousel: View {
  var title: String = "";
  var data: Array<Preview> = [];
  
  var body: some View {
    VStack(alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/){
      Text("\(title)")
        .font(.title2)
        .fontWeight(.bold)
      GeometryReader { geometry in
        ImageCarousel(numberOfImages: self.data.count == 0 ? 1 : self.data.count) {
          ForEach(self.data) { item in
            NavigationLink(
              destination: DetailsView(id: item.id, mediaType: item.mediaType),
              label: {
                ZStack {
                  KFImage(URL(string: item.posterPath))
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: geometry.size.width ,height: geometry.size.height)
                    .blur(radius: 5.0)
                    .clipped()
                  KFImage(URL(string: item.posterPath))
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: geometry.size.width * 0.6 ,height: geometry.size.height)
                    .clipped()
                }.frame(height: 300, alignment: .center)})
          }
        }
      }
      .frame(height: 300, alignment: .center)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

