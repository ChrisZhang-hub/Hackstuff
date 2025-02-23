//
//  HomeView.swift
//  Study
//
//  Created by Chen Ryan on 21/2/2025.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Home Screen!")
                .font(.largeTitle)
                .padding()
            
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("You are now logged in.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
        
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

