//
//  ContentView.swift
//  USC Films
//
//  Created by Jack  on 4/19/21.
//

import SwiftUI

struct AppView: View {
  @State private var selection = 1
  @State private var showToast: Bool = true;
  
  var body: some View {
    TabView(selection: $selection) {
      SearchView()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(0)
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house")
        }
        .tag(1)
      WatchListView()
        .tabItem {
          Label("WatchList", systemImage: "heart")
        }
        .tag(2)
    }
    .toast(text: Text("Hello toast!"))
  }
}

