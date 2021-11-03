//
//  ContentView.swift
//  TodaysTodoList
//
//  Created by Morgana Galamba on 25/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var newTask: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack{
                        Button(action: {
                            item.isCompleted.toggle()
                        }){
                            if item.isCompleted {
                                Label("", systemImage: "checkmark.circle.fill")
                                    .foregroundColor(.purple)
                            }else {
                                Label("",systemImage: "circle")
                                    .foregroundColor(.purple)
                            }
                        }
                        Text(item.name ?? "tarefa sem nome")
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                                .foregroundColor(.purple)
                        }.alert(isPresented: $showAlert){
                            Alert(title: Text("Tarefa sem nome"), message: Text("Não foi possível criar uma nova tarefa devido a falta do nome"), dismissButton: .default(Text("Ok")))
                        }
                        EditButton()
                            .foregroundColor(.purple)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading){
                    TextField("Nova tarefa" , text: $newTask )
                }
            }
            .navigationTitle("Tarefas para fazer:")
        }
    }

    private func addItem() {
        withAnimation {
            if newTask != "" {
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.name = newTask
                newTask = ""
            } else {
                showAlert = true
            }
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
