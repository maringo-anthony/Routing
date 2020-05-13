//
//  ContentView.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: LandmarkItem.getAllLandmarks()) var landmarkItems:FetchedResults<LandmarkItem>
    
    
    @State private var newLandmarkItem = ""
    @State private var landmarkList = [LandmarkItem]()
    
    var body: some View {
        NavigationView{
            List{
                //                Section(header: Text("Whats next?")){
                //                    HStack{
                //                        TextField("New Item", text: self.$newLandmarkItem)
                //                        Button(action: {
                //                            let landmarkItem = LandmarkItem(context: self.managedObjectContext)
                //                            landmarkItem.name = self.newLandmarkItem
                //
                //
                //                            do{
                //                                try self.managedObjectContext.save()
                //                            }catch{
                //                                print(error)
                //                            }
                //
                //                            self.newLandmarkItem = ""
                //
                //                        }){
                //                            Image(systemName: "plus.circle.fill")
                //                                .foregroundColor(.green)
                //                                .imageScale(.large)
                //                        }
                //                    }
                //                }.font(.headline)
                Section(header:Text("Landmarks")){
                    
                    ForEach(self.landmarkItems){ landmarkItem in
                        
                        NavigationLink(destination:LandmarkDetailView(landmark: landmarkItem)){
                            LandmarkItemView(name: landmarkItem.name , address: landmarkItem.address)
                        }
                        
                        
                    }.onDelete{indexSet in
                        let deleteItem = self.landmarkItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Landmarks"))
            .navigationBarItems(trailing: NavigationLink(destination:NewLandmarkItemView()){
                Image(systemName: "plus")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

