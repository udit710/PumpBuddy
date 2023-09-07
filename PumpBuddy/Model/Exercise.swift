//
//  Exercise.swift
//  PumpBuddy
//
//  Created by udit on 22/08/23.
//

import Foundation

enum exerciseType{
    case cardio, strength, yoga, bodyweight
}

struct Exercise{
    
    // Unique identifier for the exercise, generated using UUID
    var ID = UUID()
    // Name of the exercise
    var name: String
    // Optional description of the exercise
    var description: String?
    // Optional image name for the exercise illustration
    var imageName: String?
    // Type of the exercise, using the exerciseType enumeration
    var type: exerciseType
    // Muscle group targeted by the exercise
    var muscleGroups: [MuscleGroup]
    
    
    init(ID: UUID = UUID(), name: String, description: String? = nil, imageName: String? = nil, type: exerciseType, muscleGroups: [MuscleGroup]) {
        self.ID = ID
        self.name = name
        self.description = description
        self.imageName = imageName
        self.type = type
        self.muscleGroups = muscleGroups
    }
    
}

//Creating Instances of a MuscleGroup with excercises
let cardioMuscleGroup = MuscleGroup(name: .quads, exercises: [])
let cardioExercise = Exercise(ID: UUID(), name: "Running", description: "Cardio exercise that involves running", imageName: "running.jpg", type: .cardio, muscleGroups: [cardioMuscleGroup])

let bodyweightMuscleGroup1 = MuscleGroup(name: .chest, exercises: [])
let bodyweightMuscleGroup2 = MuscleGroup(name: .triceps, exercises: [])
let bodyweightExercise = Exercise(ID: UUID(), name: "Push-ups", description: "Bodyweight exercise targeting chest and triceps", imageName: "pushups.jpg", type: .bodyweight, muscleGroups: [bodyweightMuscleGroup1, bodyweightMuscleGroup2])


let legs = MuscleGroup(name: .quads, exercises: [cardioExercise])
let chest = MuscleGroup(name: .chest, exercises: [bodyweightExercise])
let triceps = MuscleGroup(name: .triceps, exercises: [bodyweightExercise])
let biceps = MuscleGroup(name: .biceps, exercises: [bodyweightExercise])

let hamstrings = MuscleGroup(name: .hamstrings, exercises: [])
let hamstringsExercise = Exercise(ID: UUID(), name: "Hamstring Curls", description: "Exercise targeting the hamstrings", imageName: "hamstring_curls.jpg", type: .strength, muscleGroups: [hamstrings])

let back = MuscleGroup(name: .back, exercises: [])
let backExercise = Exercise(ID: UUID(), name: "Lat Pulldowns", description: "Strength exercise targeting the back muscles", imageName: "lat_pulldowns.jpg", type: .strength, muscleGroups: [back])

let glutes = MuscleGroup(name: .legs, exercises: [])
let glutesExercise = Exercise(ID: UUID(), name: "Hip Thrusts", description: "Strength exercise targeting the glutes", imageName: "hip_thrusts.jpg", type: .strength, muscleGroups: [glutes])

let core = MuscleGroup(name: .core, exercises: [])
let coreExercise = Exercise(ID: UUID(), name: "Russian Twists", description: "Core exercise for abdominal muscles", imageName: "russian_twists.jpg", type: .bodyweight, muscleGroups: [core])

let legs2 = MuscleGroup(name: .legs, exercises: [])
let legsExercise = Exercise(ID: UUID(), name: "Leg Press", description: "Strength exercise targeting the leg muscles", imageName: "leg_press.jpg", type: .strength, muscleGroups: [legs2])

let shoulders = MuscleGroup(name: .shoulders, exercises: [])
let shouldersExercise = Exercise(ID: UUID(), name: "Dumbbell Shoulder Press", description: "Strength exercise targeting the shoulder muscles", imageName: "shoulder_press.jpg", type: .strength, muscleGroups: [shoulders])

let core2 = MuscleGroup(name: .core, exercises: [])
let coreExercise2 = Exercise(ID: UUID(), name: "Hanging Leg Raises", description: "Core exercise targeting the lower abdominal muscles", imageName: "hanging_leg_raises.jpg", type: .bodyweight, muscleGroups: [core2])

let cardio2 = MuscleGroup(name: .legs, exercises: [])
let cardioExercise2 = Exercise(ID: UUID(), name: "Jumping Jacks", description: "Cardio exercise involving jumping movements", imageName: "jumping_jacks.jpg", type: .cardio, muscleGroups: [cardio2])

let shoulders2 = MuscleGroup(name: .shoulders, exercises: [])
let shouldersExercise2 = Exercise(ID: UUID(), name: "Lateral Raises", description: "Strength exercise targeting the lateral deltoids", imageName: "lateral_raises.jpg", type: .strength, muscleGroups: [shoulders2])

let legs3 = MuscleGroup(name: .legs, exercises: [])
let legsExercise2 = Exercise(ID: UUID(), name: "Step Ups", description: "Strength exercise targeting the leg muscles", imageName: "step_ups.jpg", type: .strength, muscleGroups: [legs3])

//Define musclegroup instances for sample data
var musclegroupSampleData: [MuscleGroup] = [legs,chest,triceps,biceps,hamstrings, back, glutes, core, legs2, shoulders, core2, cardio2, shoulders2, legs3]

//Define exercises instances for sample data
var exerciseSampleData: [Exercise] = [cardioExercise, bodyweightExercise,hamstringsExercise, backExercise, glutesExercise, coreExercise, legsExercise, shouldersExercise, coreExercise2, cardioExercise2, shouldersExercise2, legsExercise2]


//Define workout instances for sample data
var workoutSampleData = [
    Workout(name: "Morning Run", date: Date(), duration: 30, exercise: [cardioExercise], muscles: [legs], description: "A morning run to start the day"),
    Workout(name: "Push-up Session", date: Date(), duration: 45, exercise: [bodyweightExercise], muscles: [chest, triceps], description: "Bodyweight workout focusing on chest and triceps"),
    Workout(name: "Yoga Flow", date: Date(), duration: 60, exercise: [], muscles: [], description: "Relaxing yoga session for flexibility and balance"),
    Workout(name: "Leg Day", date: Date(), duration: 60, exercise: [cardioExercise, bodyweightExercise], muscles: [legs, chest], description: "Intense leg workout including running and bodyweight exercises"),
    Workout(name: "Upper Body Blast", date: Date(), duration: 50, exercise: [bodyweightExercise], muscles: [chest, triceps], description: "High-intensity upper body workout with push-ups and tricep exercises"),
    Workout(name: "Restorative Stretch", date: Date(), duration: 40, exercise: [], muscles: [], description: "Gentle stretching routine to aid in recovery and relaxation"),
    Workout(name: "Back and Biceps", date: Date(), duration: 55, exercise: [], muscles: [], description: "Workout targeting the back and bicep muscle groups"),
    Workout(name: "Core Strengthening", date: Date(), duration: 45, exercise: [], muscles: [], description: "Focus on core muscles for improved stability and strength")
]

