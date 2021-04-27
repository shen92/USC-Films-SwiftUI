//
//  ReviewCard.swift
//  USC Films
//
//  Created by Jack  on 4/26/21.
//

import SwiftUI
import Foundation

struct ReviewCard: View {
  @Environment(\.colorScheme) var colorScheme;
  var review: Review = Review();
  var title: String = "";
  
  func  getDateString(iso8601Date: String) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    isoDateFormatter.formatOptions = [
      .withFullDate,
      .withFullTime,
      .withDashSeparatorInDate,
      .withFractionalSeconds]
    
    if let realDate = isoDateFormatter.date(from: iso8601Date) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .none
      return dateFormatter.string(from: realDate)
    }
    
    return "";
  }
  
  var body: some View {
    NavigationLink(
      destination: ReviewView(
        title: self.title,
        subtitle: "By \(self.review.author) on \(getDateString(iso8601Date: self.review.date))",
        rate: "\(self.review.rate)/5.0",
        content: self.review.content
      ),
      label: {
        VStack(alignment: .leading) {
          Text("A review by \(self.review.author)")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(colorScheme == .dark ? .white: .black)
          Text("Written by \(self.review.author) on \(getDateString(iso8601Date: self.review.date))")
            .foregroundColor(.gray)
          HStack{
            Image(systemName: "star.fill")
              .foregroundColor(.red)
            Text("\(self.review.rate)/5.0")
              .font(.body)
              .foregroundColor(colorScheme == .dark ? .white: .black)
          }
          .padding(.vertical, 2.0)
          Text(self.review.content)
            .lineLimit(3)
            .font(/*@START_MENU_TOKEN@*/.callout/*@END_MENU_TOKEN@*/)
            .foregroundColor(colorScheme == .dark ? .white: .black)
        }
        .foregroundColor(.black)
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 1)
        )
      })
    
  }
}

