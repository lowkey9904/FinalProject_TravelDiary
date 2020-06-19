//
//  AttractionsRow.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/19.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct AttractionsRow: View {
    @State var attName:String
    @State var attAdd:String
    //@State var attURL:String
    var body: some View {
        VStack(alignment: .leading){
            Text(self.attName)
                .bold()
            Text(self.attAdd.dropFirst(4))
        }
    }
}
