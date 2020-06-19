//
//  AddDiary.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/17.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct AddDiary: View {
    static let DefaultDiaryContent = "I dont want to say anything..."
    static let DefaultDiaryID = userDefaults.string(forKey: "userLoginAPPID")!
    @State var content = ""
    @State var id = userDefaults.string(forKey: "userLoginAPPID")!
    @State var date = Date()
    let onComplete: (String, String, Date) -> Void
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            Form {
                Text("Add Diary")
                .font(.system(size: 50))
                .bold()
                Section(header: Text("Content")){
                    MultilineTextField(text: $content)
                }
                Section {
                    DatePicker(
                        selection: $date,
                        displayedComponents: .date) {
                            Text("Release Date").foregroundColor(Color(.gray))
                    }
                }
                Section {
                    Button(action: addDiaryAction) {
                        Text("Add Diary")
                            .foregroundColor(.black)
                    }
                }
            }
        })
    }
    
    private func addDiaryAction() {
        onComplete(
            content.isEmpty ? AddDiary.DefaultDiaryContent : content,
            id.isEmpty ? AddDiary.DefaultDiaryID : id,
            date)
    }
}
