//
//  ReviewView.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI

struct ReviewView: View {
  var title: String = "";
  var subtitle: String = "";
  var rate: String = "";
  var content: String = "";
  
  var body: some View {
    ScrollView(.vertical){
      VStack(alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/){
        Text(title)
          .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
          .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
          .frame(maxWidth: .infinity, alignment: .leading)
          .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        Text(subtitle)
          .font(.body)
          .foregroundColor(Color.gray)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 4.0)
          .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        HStack{
          Image(systemName: "star.fill")
            .foregroundColor(.red)
          Text("\(self.rate)")
            .font(.body)
        }
        .padding(.vertical, 2.0)
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
      }
      .padding(.horizontal)
      Divider()
        .padding(.horizontal);
      VStack(alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/){
        Text(content)
      }
      .padding(.horizontal)
    }
  }
}

