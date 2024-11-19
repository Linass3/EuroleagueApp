import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var address: String
    @NSManaged public var code: String
    @NSManaged public var image: String
    @NSManaged public var name: String

}

extension Team : Identifiable {

}
