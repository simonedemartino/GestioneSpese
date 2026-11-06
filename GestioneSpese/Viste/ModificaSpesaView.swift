import SwiftUI

struct ModificaSpesaView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(SpeseViewModel.self) private var viewModel

    private let spesaEsistente: Spesa?

    @State private var titolo: String
    @State private var importoTesto: String
    @State private var data: Date
    @State private var categoria: CategoriaSpesa
    @State private var note: String

    init(spesaEsistente: Spesa? = nil) {
        self.spesaEsistente = spesaEsistente
        _titolo = State(initialValue: spesaEsistente?.titolo ?? "")
        _importoTesto = State(initialValue: spesaEsistente.map {
            String($0.importo).replacingOccurrences(of: ".", with: ",")
        } ?? "")
        _data = State(initialValue: spesaEsistente?.data ?? Date())
        _categoria = State(initialValue: spesaEsistente?.categoria ?? .cibo)
        _note = State(initialValue: spesaEsistente?.note ?? "")
    }


    private var importoValido: Double? {
        let normalizzato = importoTesto.replacingOccurrences(of: ",", with: ".")
        guard let valore = Double(normalizzato), valore > 0 else { return nil }
        return valore
    }

    private var puoSalvare: Bool {
        !titolo.trimmingCharacters(in: .whitespaces).isEmpty && importoValido != nil
    }


    var body: some View {
        NavigationStack {
            Form {
                Section("Dettagli") {
                    TextField("Titolo", text: $titolo)
                    TextField("Importo (€)", text: $importoTesto)
                        .keyboardType(.decimalPad)
                    DatePicker("Data", selection: $data, displayedComponents: .date)
                }

                Section("Categoria") {
                    Picker("Categoria", selection: $categoria) {
                        ForEach(CategoriaSpesa.allCases) { categoria in
                            Label(categoria.nome, systemImage: categoria.icona)
                                .tag(categoria)
                        }
                    }
                }

                Section("Note") {
                    TextField("Note (facoltative)", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(spesaEsistente == nil ? "Nuova spesa" : "Modifica spesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") { salva() }
                        .disabled(!puoSalvare)
                }
            }
        }
    }


    private func salva() {
        guard let importo = importoValido else { return }
        let titoloPulito = titolo.trimmingCharacters(in: .whitespaces)

        if let spesa = spesaEsistente {
            viewModel.aggiorna(spesa, titolo: titoloPulito, importo: importo,
                               data: data, categoria: categoria, note: note)
        } else {
            viewModel.aggiungi(titolo: titoloPulito, importo: importo,
                               data: data, categoria: categoria, note: note)
        }
        dismiss()
    }
}

#Preview {
    ModificaSpesaView()
        .environment(SpeseViewModel.anteprima)
}
