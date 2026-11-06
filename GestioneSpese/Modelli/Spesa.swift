import Foundation
import SwiftData


@Model
final class Spesa {
    var titolo: String
    var importo: Double
    var data: Date
    var categoria: CategoriaSpesa
    var note: String

    init(titolo: String,
         importo: Double,
         data: Date = Date(),
         categoria: CategoriaSpesa = .altro,
         note: String = "") {
        self.titolo = titolo
        self.importo = importo
        self.data = data
        self.categoria = categoria
        self.note = note
    }
}

struct TotaleCategoria: Identifiable {
    let categoria: CategoriaSpesa
    let totale: Double

    var id: CategoriaSpesa { categoria }
}

// MARK: - Dati di esempio
extension Spesa {
    static func esempi() -> [Spesa] {
        func giorniFa(_ giorni: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -giorni, to: Date()) ?? Date()
        }
        return [
            Spesa(titolo: "Spesa al supermercato", importo: 54.30, data: giorniFa(0), categoria: .cibo),
            Spesa(titolo: "Abbonamento treno", importo: 38.00, data: giorniFa(1), categoria: .trasporti),
            Spesa(titolo: "Cinema", importo: 12.50, data: giorniFa(2), categoria: .svago, note: "Con gli amici"),
            Spesa(titolo: "Farmacia", importo: 18.90, data: giorniFa(3), categoria: .salute),
            Spesa(titolo: "Bolletta luce", importo: 72.40, data: giorniFa(4), categoria: .casa),
            Spesa(titolo: "Maglione", importo: 45.00, data: giorniFa(5), categoria: .shopping),
            Spesa(titolo: "Pizza", importo: 16.00, data: giorniFa(6), categoria: .cibo)
        ]
    }
}
