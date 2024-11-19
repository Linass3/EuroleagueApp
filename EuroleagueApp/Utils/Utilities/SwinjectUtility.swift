import Swinject
import CoreData

@MainActor
struct SwinjectUtility {
    static let container: Container = {
        let container = Container()
        container.register(EuroleagueDataClient.self) { _ in DefaultEuroleagueDataClient() }
        container.register(NSManagedObjectContext.self) { _ in CoreDataUtility.shared.context }
        return container
    }()
    
    static func forceResolve<Service>(_ service: Service.Type) -> Service {
        guard let resolved = container.resolve(service) else {
            fatalError("Could not resolve \(service)")
        }
        return resolved
    }
}
