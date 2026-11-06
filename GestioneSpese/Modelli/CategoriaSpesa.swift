import SwiftUI

enum CategoriaSpesa: String, Codable, CaseIterable, Identifiable {
    case cibo
    case trasporti
    case casa
    case svago
    case salute
    case shopping
    case altro

    var id: String { rawValue }

    var nome: String {
        switch self {
        case .cibo:      return "Cibo"
        case .trasporti: return "Trasporti"
        case .casa:      return "Casa"
        case .svago:     return "Svago"
        case .salute:    return "Salute"
        case .shopping:  return "Shopping"
        case .altro:     return "Altro"
        }
    }

    var icona: String {
        switch self {
        case .cibo:      return "fork.knife"
        case .trasporti: return "car.fill"
        case .casa:      return "house.fill"
        case .svago:     return "gamecontroller.fill"
        case .salute:    return "cross.case.fill"
        case .shopping:  return "bag.fill"
        case .altro:     return "ellipsis.circle.fill"
        }
    }

    var colore: Color {
        switch self {
        case .cibo:      return .orange
        case .trasporti: return .blue
        case .casa:      return .brown
        case .svago:     return .purple
        case .salute:    return .red
        case .shopping:  return .pink
        case .altro:     return .gray
        }
    }
}
