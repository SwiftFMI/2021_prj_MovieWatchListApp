import Foundation

struct Setting {
    let image: String
    let label: String
    let description: String
}

extension Setting {
    static func getSettingsData() -> [Setting] {
        return [Setting]([Setting(image: "general", label: "General", description: ""), Setting(image: "about", label: "About", description: ""), Setting(image: "logout", label: "Log out", description: "")])
    }
}
