import SwiftData
import Foundation

enum ChoreCategory: String, Codable, CaseIterable {
    case cleaning = "Cleaning"
    case kitchen = "Kitchen"
    case laundry = "Laundry"
    case bathroom = "Bathroom"
    case outdoor = "Outdoor"
    case pets = "Pets"
    case shopping = "Shopping"
    case organization = "Organization"
    case maintenance = "Maintenance"
    case other = "Other"

    var emoji: String {
        switch self {
        case .cleaning: return "🧹"
        case .kitchen: return "🍳"
        case .laundry: return "👕"
        case .bathroom: return "🚿"
        case .outdoor: return "🌿"
        case .pets: return "🐾"
        case .shopping: return "🛒"
        case .organization: return "📦"
        case .maintenance: return "🔧"
        case .other: return "✨"
        }
    }

    var colorHex: String {
        switch self {
        case .cleaning: return "#4A90D9"
        case .kitchen: return "#E8913A"
        case .laundry: return "#7B68EE"
        case .bathroom: return "#20B2AA"
        case .outdoor: return "#32CD32"
        case .pets: return "#FF8C69"
        case .shopping: return "#FF6B6B"
        case .organization: return "#DDA0DD"
        case .maintenance: return "#A0522D"
        case .other: return "#87CEEB"
        }
    }
}

enum ChoreFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    case custom = "Custom"

    var intervalDays: Int {
        switch self {
        case .daily: return 1
        case .weekly: return 7
        case .biweekly: return 14
        case .monthly: return 30
        case .custom: return 7
        }
    }
}
