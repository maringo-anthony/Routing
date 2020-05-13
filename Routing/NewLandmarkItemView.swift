//
//  NewLandmarkItemView.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import SwiftUI

struct NewLandmarkItemView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: LandmarkItem.getAllLandmarks()) var landmarkItems:FetchedResults<LandmarkItem>
    
    @State private var name = ""
    @State private var address = ""
    @State private var landMarkDescription = ""
    
    var body: some View {
        
        //NavigationView{
        VStack{
            // Save user input to these local state variables
            TextField("Name",text: self.$name).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("123 West Main St., New York NY, 12345", text: self.$address).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Description", text: self.$landMarkDescription).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button(action: {
                // Create a new landmark object and save it to the database
                let landmarkItem = LandmarkItem(context: self.managedObjectContext)
                landmarkItem.name = self.name
                landmarkItem.address = self.address
                landmarkItem.landMarkDescription = self.landMarkDescription
                landmarkItem.getCoordinates()
                
                do{
                    try self.managedObjectContext.save()
                    print("COORDINATES AFTER CREATING NEW OBJECT...")
                    print(landmarkItem.latitude)
                    print(landmarkItem.longitude)
                }catch{
                    print(error)
                }
                
                // Clean the item for the next time
                self.name = ""
                self.address = ""
                self.landMarkDescription = ""
                
            }) {
                Text("Save")}
            
            Spacer()
        }
        .navigationBarTitle("Add new location")
        
        //.navigationBarTitle("Add new location",displayMode: .inline)
        //            .navigationBarItems(trailing: Button(action: {
        //                // Create a new landmark object and save it to the database
        //                let landmarkItem = LandmarkItem(context: self.managedObjectContext)
        //                landmarkItem.name = self.name
        //                landmarkItem.address = self.address
        //                landmarkItem.landMarkDescription = self.landMarkDescription
        //
        //                do{
        //                    try self.managedObjectContext.save()
        //                }catch{
        //                    print(error)
        //                }
        //
        //                // Clean the item for the next time
        //                self.name = ""
        //                self.address = ""
        //                self.landMarkDescription = ""
        //
        //            }) {
        //            Text("Done")
        //                })
        //}
    }
}

struct NewLandmarkItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewLandmarkItemView()
    }
}
