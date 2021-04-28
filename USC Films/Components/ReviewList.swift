//
//  ReviewList.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI

struct ReviewList: View {
  var data: Array<Review> = [];
  var title: String = "";
  
  var body: some View {
    VStack(alignment: .leading){
      Text("Reviews")
        .font(.title)
        .fontWeight(.bold)
        .padding(.bottom, 5.0)
      if(data.count != 0){
        ForEach(data) { review in
          ReviewCard(review: review, title: title);
        }
      }
    }
    .padding(.top)
    
  }
}

