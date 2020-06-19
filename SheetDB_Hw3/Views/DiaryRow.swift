//
//  DiaryRow.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/17.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct DiaryRow: View {
    let diary:Diary
    
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    var body: some View {
        VStack(alignment: .leading) {
            diary.content.map(Text.init)
                .font(.title)
            HStack {
                //Text(diary.id!)
                diary.date.map { Text(Self.releaseFormatter.string(from: $0)) }
                    .font(.caption)
            }
        }
    }
}

