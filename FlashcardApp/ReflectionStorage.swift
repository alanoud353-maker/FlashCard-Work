// التخزين المحلي
import Foundation

struct ReflectionStorage {
    private let storageKey = "savedReflections"
    // داله حفظ التدوين
    func save(_ entry: ReflectionEntry) {
        var entries = load()
        entries.append(entry)

        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save reflection: \(error)")
        }
    }
    func delete(id: ReflectionEntry.ID) throws {
        let entries = load().filter { $0.id != id }
        let data = try JSONEncoder().encode(entries)
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    // هذي الداله تقراء التدوين المحفوظ وتسترجعه عل شكل قائمه
    func load() -> [ReflectionEntry] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode(
                [ReflectionEntry].self,
                from: data
            )
        } catch {
            print("Failed to load reflections: \(error)")
            return []
        }
    }
}

