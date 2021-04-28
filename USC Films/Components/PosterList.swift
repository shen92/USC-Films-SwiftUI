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
            ForEach(self.data){ item in
              NavigationLink(
                destination: DetailsView(id: item.id, mediaType: item.mediaType)
              ){
                VStack(alignment: .center){
                  RemoteImage(url: item.posterPath)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10.0)
                    .frame(width: 92)
                  Text("\(item.name)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 92)
                    .foregroundColor(colorScheme == .dark ? .white: .black);
                  Text("(\(item.date))")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(width: 92)
                    .foregroundColor(Color.gray);
                }
                .background(colorScheme == .dark ? Color.black: Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .contextMenu{
                  VStack {
                    Button(
                      action: {},
                      label: {
                        HStack{
                          Text("Add to watchList")
                          Image(systemName: "bookmark")
                        }
                      }
                    )
                    Button(
                      action: {},
                      label: {
                        HStack{
                          Text("Share on Facebook")
                          Image(colorScheme == .dark ? "facebook-dark" : "facebook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                      }
                    )
                    Button(
                      action: {},
                      label: {
                        HStack{
                          Text("Share on Twitter")
                          Image(colorScheme == .dark ? "twitter-dark" : "twitter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                      }
                    )
                  }
                }
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.trailing)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .topLeading)
    }
  }
}
