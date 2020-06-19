//
//  DiaryView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/16.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import CoreData

struct DiaryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Diary.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Diary.content, ascending: true)
    ]) var diaries:FetchedResults<Diary>
    
    @State var isPresented = false
    
    var body: some View {
        
        let myDiary = diaries.filter({$0.id == userDefaults.string(forKey: "userLoginAPPID")!})
        
        return LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(VStack {
        List {
            ForEach(myDiary, id: \.content){ (diary) in
                DiaryRow(diary: diary)
            }.onDelete(perform: deleteDiary)
            }
        }
        .navigationBarTitle(Text("Your Diary"))
            .navigationBarItems(trailing:
                Button(action: { self.isPresented.toggle() }) {
                    Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresented) {
                AddDiary { content, id, date in
                    self.addDiary(content: content, id: id, date: date)
                    self.isPresented = false
                }
        })
    }
    func addDiary(content: String, id: String, date: Date) {
        let newDiary = Diary(context: managedObjectContext)
        newDiary.content = content
        newDiary.date = date
        newDiary.id = id
        saveContext()
    }
    func deleteDiary(at offsets: IndexSet) {
        offsets.forEach { index in
            let diary = self.diaries[index]
            self.managedObjectContext.delete(diary)
        }
        saveContext()
    }
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
