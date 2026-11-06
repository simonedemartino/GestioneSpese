import Foundation

extension Double {
    var comeValuta: String {
        self.formatted(.currency(code: "EUR"))
    }
}

extension Date {
    var comeDataBreve: String {
        let formattatore = DateFormatter()
        formattatore.locale = Locale(identifier: "it_IT")
        formattatore.dateStyle = .medium
        formattatore.timeStyle = .none
        return formattatore.string(from: self)
    }
}
