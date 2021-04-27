//
//  ResultCard.swift
//  USC Films
//
//  Created by Jack  on 4/27/21.
//

import SwiftUI

struct ResultCard: View {
  var result: Result = Result();
  var body: some View {
    NavigationLink(
      destination: DetailsView(id: self.result.id, mediaType: self.result.mediaType),
      label: {
        ZStack{
          RemoteImage(url: self.result.backdropPath)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10.0)
            .frame(maxWidth: .infinity)
            .frame(height: 180);
          VStack(alignment: .leading){
            HStack{
              VStack {
                Text("\(self.result.mediaType.uppercased())(\(self.result.date))")
                  .font(.headline)
                  .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                  .foregroundColor(.white)
              }
              .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
              VStack(alignment: .trailing) {
                HStack{
                  Image(systemName: "star.fill")
                    .foregroundColor(.red)
                  Text("\(self.result.rate)/5.0")
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                }
              }
              .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topTrailing)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
            HStack(alignment: .bottom){
              Text(self.result.name)
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottomLeading)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 16.0)
          .padding(.horizontal, 27.0)
        }
        .padding(.vertical, 5.0)
        .frame(maxWidth: .infinity)
      }
    )
  }
}
