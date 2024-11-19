import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var viewModel: DefaultTeamListViewModel
    @State private var selectedView = "List"
    
    init(viewModel: @autoclosure @escaping () -> DefaultTeamListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isUpdating {
                    ProgressView("Loading teams...")
                } else {
                    content
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Euroleague")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.orange)
            .toolbarBackground(.visible)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: setView) {
                        Text(selectedView == "List" ? "Grid" : "List")
                    }
                }
            }
        }
    }
    
    private var content: some View {
        Group {
            if selectedView == "List" {
                listView
            } else {
                gridView
            }
        }

    }
    
    private var listView: some View {
        List(viewModel.teamsList, id: \.objectID) { team in
            NavigationLink(destination: TeamDetailsView()) {
                TeamListItem(team: team)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 5,
                         leading: 20,
                         bottom: 5,
                         trailing: 20))
            }
        }
        .listStyle(.plain)
        
    }
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.fixed(190)), GridItem(.fixed(190))],
                spacing: 20
            ) {
                ForEach(viewModel.teamsList, id: \.self) { team in
                    TeamGridItem(team: team)
                }
            }
            .padding()
        }
    }
    
    private func loadData() async {
        await viewModel.checkTeamsData()
    }
    
    private func setView() {
        if selectedView == "Grid" {
            selectedView = "List"
        } else {
            selectedView = "Grid"

        }
    }
    
}

//#Preview {
//    ContentView()
//}

    
    
    
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
