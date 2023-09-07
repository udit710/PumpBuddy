//
//  WeekView.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import SwiftUI

struct WeekView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        //This is a hard-coded display as of now as we do not have actual user data to load
        //Logic for this will be done in the VM folder
        VStack(alignment: .leading){
            Text("This week's activity")
                .padding([.leading, .bottom], 8.0)
                .font(.custom("Arial", size: 25))
                .bold()
            HStack{
                circleView(day:"M",done:true,date:Date())
                circleView(day:"Tu",done:true,date:Date())
                circleView(day:"W",done:false,date:Date())
                circleView(day:"Th",done:true,date:Date())
                circleView(day:"F",done:false,date:Date())
                circleView(day:"Sa",done:false,date:Date())
                circleView(day:"Su",done:false,date:Date())
                
            }
            .foregroundColor(colorScheme == .light ? .white : .black)
        }
        .padding(.all)
        .frame(maxWidth: .infinity)
        .background(Color("AppColor"))
        .cornerRadius(20)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}

//Common view displayed for each day
struct circleView: View{
    @Environment(\.colorScheme) var colorScheme
    var day: String
    var done: Bool
    var date: Date
    var body: some View {
        VStack{
            Text(day)
            ZStack {
                Circle()
                    .frame(maxWidth: 40)
                .foregroundColor(done == true ? .black : .white)
                if done{
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
