import Foundation
import CoreData

extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var birthDate: String
    @NSManaged public var name: String
    @NSManaged public var image: String?
    @NSManaged public var height: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var position: String
    @NSManaged public var number: String
    @NSManaged public var country: String
    @NSManaged public var lastTeam: String
    @NSManaged public var clubCode: String
    
    var age: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let birthDate = dateFormatter.date(from: birthDate)
        let now = Date()
        let calendar = Calendar.current
        if let birthDate {
            let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
            let age = ageComponents.year!
            return age
        } else {
            return 0
        }
    }
}
