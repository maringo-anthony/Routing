//
//  LandmarkItemView.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import SwiftUI

struct LandmarkItemView: View {
    var name:String = ""
    var address:String = ""
    
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(name)
                    .font(.headline)
                Text(address)
                    .font(.caption)
            }
        }
    }
}

struct LandmarkItemView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkItemView(name:"Home",address: "39 Spectacle Lake Dr")
    }
}
