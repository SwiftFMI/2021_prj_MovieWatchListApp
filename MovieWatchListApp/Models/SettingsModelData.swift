import Foundation

struct Setting {
    let image: String
    let label: String
    let description: String
}

extension Setting {
    static func getSettingsData() -> [Setting] {
        return [Setting]([Setting(image: "folder.fill", label: "General", description: ""), Setting(image: "person.fill", label: "About", description: ""), Setting(image: "power", label: "Log out", description: "")])
    }
}
