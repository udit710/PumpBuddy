//
//  ExploreOverview.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI

//Brief view to display on home page
struct ExploreOverview: View {
    var body: some View {
        VStack(alignment: .leading){
                
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    exploreMiniCard(imageName: "Running-explore",name: "For \nRunners", colorx: .red)
                        .frame(width: 150.0, height: 150.0)
                        .padding(.leading)
                    exploreMiniCard(imageName: "Running-explore",name: "Run", colorx: .blue)
                        .frame(width: 150.0, height: 150.0)
                    exploreMiniCard(imageName: "Running-explore",name: "Run", colorx: .gray)
                        .frame(width: 150.0, height: 150.0)
                }
                
            }
        }
    }
}

struct ExploreOverview_Previews: PreviewProvider {
    static var previews: some View {
        ExploreOverview()
    }
}

struct exploreMiniCard: View{
    var imageName: String
    var name: String
    var colorx: Color
    var body: some View{
        ZStack{
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding(.all, 3.0)
            Rectangle()
                .opacity(0.5)
                .cornerRadius(20)
                .padding([.leading, .bottom, .trailing], 3.0)
                .foregroundColor(colorx)
            Text(name)
                .foregroundColor(.white)
                .bold()
        }
    }
}
