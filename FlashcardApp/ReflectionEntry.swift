// ملف تعريف شكل البيانات الي رح اخزنها محليًا
import Foundation

struct ReflectionEntry: Identifiable, Codable {
    let id: UUID
    let scenarioID: String
    let scenarioTitle: String
    let feeling: String
    let reflectionText: String
    

    init(
        scenarioID: String,
        scenarioTitle: String,
        feeling: String,
        reflectionText: String
    ) {
        self.id = UUID()
        self.scenarioID = scenarioID
        self.scenarioTitle = scenarioTitle
        self.feeling = feeling
        self.reflectionText = reflectionText
        
    }
}
