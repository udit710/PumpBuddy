////
////  WorkoutsBriefView.swift
////  PumpBuddy
////
////  Created by udit on 22/08/23.
////
//
import SwiftUI
//
struct WorkoutsBriefView: View {
    //Sample workout data
    @FetchRequest(entity: Workout.entity(), sortDescriptors: []) var workouts: FetchedResults<Workout>

    var body: some View {
        VStack{
            HStack {
                VStack(alignment: .leading){
                    Text("Workouts")
                    Text("Completed")
                }
                    .bold()
                .font(.custom("San Francisco",size: 25))
                Spacer()
            }
            
            //Display the count of completed workouts
            HStack {
                Text(workouts.count < 10 ? "0\(workouts.count)" : "\(workouts.count)")
                    .font(.custom("San Serif", size: 80))
                    .padding(.leading)
                Spacer()
            }
        }
        .padding(.all)
        .background(.pink)
        .cornerRadius(20)
        .foregroundColor(.black)
    }
}

struct WorkoutsBriefView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsBriefView()
    }
}

//View to show number of workouts completed
//struct miniWorkout: View{
//    //Sample workout data
//    var workouts : [Workout] = workoutSampleData
//    var body: some View{
//        VStack{
//            //Display upto 2 workouts
//            ForEach(workouts.prefix(upTo: 2), id: \.ID) { workout in
//                HStack{
//                    Text("\(workout.name)")
//                    Spacer()
//                    Text("\(workout.date, format: .dateTime.day().month())")
//                }
//                Divider()
//            }
//        }
//
//    }
//}

//Separate struct to load and display recent workouts
struct recentWorkouts: View{
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: Workout.entity(), sortDescriptors: []) var workouts: FetchedResults<Workout>
    var body: some View{
        VStack{
            HStack {
                VStack(alignment: .leading){
                        Text("Recent")
                    HStack {
                        Text("Workouts")
                        Image(systemName: "chevron.forward.circle")
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    }
                }
                    .bold()
                .font(.custom("San Francisco",size: 18))
                Spacer()
            }
            Divider()
                .overlay(Color("Pink"))
//             Display up to 2 recent workouts with name and duration
            if workouts.isEmpty{
                Text("No Workouts yet")
            }
            else if workouts.count == 1{
                ForEach(workouts.prefix(upTo: 1)) { workout in
                    HStack{
                        Text(workout.name ?? "Workout")
                        Spacer()
                        Text("\(String(workout.duration))m")
                    }
                    Divider()
                        .overlay(Color("Pink"))
                }
            } else{
                ForEach(workouts.prefix(upTo: 2)) { workout in
                    HStack{
                        Text(workout.name ?? "Workout")
                        Spacer()
                        Text("\(String(workout.duration))m")
                    }
                    Divider()
                        .overlay(Color("Pink"))
                }
            }
        }
        .padding()
    }
}
