import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class SpeseViewModel {


    private(set) var spese: [Spesa] = []
    var testoRicerca = ""
    var categoriaFiltro: CategoriaSpesa? = nil

    private let contenitore: ModelContainer
    private var contesto: ModelContext { contenitore.mainContext }


    init(contenitore: ModelContainer) {
        self.contenitore = contenitore
        caricaSpese()
    }


    var speseFiltrate: [Spesa] {
        spese
            .filter { categoriaFiltro == nil || $0.categoria == categoriaFiltro }
            .filter { testoRicerca.isEmpty || $0.titolo.localizedCaseInsensitiveContains(testoRicerca) }
            .sorted { $0.data > $1.data }
    }

    var totaleGenerale: Double {
        spese.reduce(0) { $0 + $1.importo }
    }

    var totaleMeseCorrente: Double {
        spese
            .filter { Calendar.current.isDate($0.data, equalTo: Date(), toGranularity: .month) }
            .reduce(0) { $0 + $1.importo }
    }

    var totaliPerCategoria: [TotaleCategoria] {
        Dictionary(grouping: spese, by: { $0.categoria })
            .map { categoria, elenco in
                TotaleCategoria(categoria: categoria,
                                totale: elenco.reduce(0) { $0 + $1.importo })
            }
            .sorted { $0.totale > $1.totale }
    }


    func aggiungi(titolo: String, importo: Double, data: Date,
                  categoria: CategoriaSpesa, note: String) {
        let totalePrima = totaleMeseCorrente

        let nuova = Spesa(titolo: titolo, importo: importo, data: data,
                          categoria: categoria, note: note)
        contesto.insert(nuova)
        salvaERicarica()

        controllaBudget(totalePrima: totalePrima)
    }

    func aggiorna(_ spesa: Spesa, titolo: String, importo: Double, data: Date,
                  categoria: CategoriaSpesa, note: String) {
        let totalePrima = totaleMeseCorrente

        spesa.titolo = titolo
        spesa.importo = importo
        spesa.data = data
        spesa.categoria = categoria
        spesa.note = note
        salvaERicarica()

        controllaBudget(totalePrima: totalePrima)
    }

    func elimina(daIndici indici: IndexSet) {
        let filtrate = speseFiltrate
        for indice in indici {
            contesto.delete(filtrate[indice])
        }
        salvaERicarica()
    }

    func eliminaTutto() {
        for spesa in spese {
            contesto.delete(spesa)
        }
        salvaERicarica()
    }

    func caricaDatiEsempio() {
        for spesa in Spesa.esempi() {
            contesto.insert(spesa)
        }
        salvaERicarica()
    }


    func percentualeBudget(_ budget: Double) -> Double {
        guard budget > 0 else { return 0 }
        return totaleMeseCorrente / budget
    }

    private func controllaBudget(totalePrima: Double) {
        let impostazioni = UserDefaults.standard
        let budget = impostazioni.double(forKey: ChiaviImpostazioni.budgetMensile)

        guard budget > 0,
              impostazioni.bool(forKey: ChiaviImpostazioni.notificheAttive) else { return }

        let totaleDopo = totaleMeseCorrente
        let soglia = budget * 0.8

        if totalePrima < budget && totaleDopo >= budget {
            ServizioNotifiche.condiviso.inviaAvviso(
                titolo: "Budget superato!",
                messaggio: "Hai speso \(totaleDopo.comeValuta) su un budget di \(budget.comeValuta).")
        } else if totalePrima < soglia && totaleDopo >= soglia {
            ServizioNotifiche.condiviso.inviaAvviso(
                titolo: "Attenzione al budget",
                messaggio: "Hai già usato l'80% del budget mensile (\(totaleDopo.comeValuta)).")
        }
    }


    private func caricaSpese() {
        let descrittore = FetchDescriptor<Spesa>(sortBy: [SortDescriptor(\.data, order: .reverse)])
        spese = (try? contesto.fetch(descrittore)) ?? []
    }

    private func salvaERicarica() {
        try? contesto.save()
        caricaSpese()
    }
}

extension SpeseViewModel {
    static var anteprima: SpeseViewModel {
        let configurazione = ModelConfiguration(isStoredInMemoryOnly: true)
        let contenitore = try! ModelContainer(for: Spesa.self, configurations: configurazione)
        let viewModel = SpeseViewModel(contenitore: contenitore)
        viewModel.caricaDatiEsempio()
        return viewModel
    }
}
