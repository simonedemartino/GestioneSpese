import SwiftUI

struct ImpostazioniView: View {

    @Environment(SpeseViewModel.self) private var viewModel

    @AppStorage(ChiaviImpostazioni.budgetMensile) private var budgetMensile: Double = 0
    @AppStorage(ChiaviImpostazioni.notificheAttive) private var notificheAttive = false

    @State private var mostraErrorePermesso = false
    @State private var mostraConfermaElimina = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Budget mensile (€)")
                        TextField("0", value: $budgetMensile, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Budget")
                } footer: {
                    Text("Imposta 0 per disattivare il controllo del budget.")
                }

                Section {
                    Toggle("Avvisi sul budget", isOn: $notificheAttive)
                } header: {
                    Text("Notifiche")
                } footer: {
                    Text("Ricevi un avviso quando raggiungi l'80% del budget e quando lo superi.")
                }

                Section("Dati") {
                    ShareLink(item: DocumentoCSV(testo: ServizioEsportazione.generaCSV(da: viewModel.spese)),
                              preview: SharePreview("Spese.csv")) {
                        Label("Esporta in CSV", systemImage: "square.and.arrow.up")
                    }
                    .disabled(viewModel.spese.isEmpty)

                    Button {
                        viewModel.caricaDatiEsempio()
                    } label: {
                        Label("Carica dati di esempio", systemImage: "tray.and.arrow.down")
                    }

                    Button(role: .destructive) {
                        mostraConfermaElimina = true
                    } label: {
                        Label("Elimina tutte le spese", systemImage: "trash")
                    }
                    .disabled(viewModel.spese.isEmpty)
                }
            }
            .navigationTitle("Impostazioni")
            .onChange(of: notificheAttive) { _, attive in
                if attive { richiediPermessoNotifiche() }
            }
            .alert("Notifiche disattivate", isPresented: $mostraErrorePermesso) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Abilita le notifiche per quest'app dalle Impostazioni di iOS.")
            }
            .confirmationDialog("Eliminare tutte le spese?",
                                isPresented: $mostraConfermaElimina,
                                titleVisibility: .visible) {
                Button("Elimina tutto", role: .destructive) {
                    viewModel.eliminaTutto()
                }
            } message: {
                Text("L'operazione non può essere annullata.")
            }
        }
    }

    private func richiediPermessoNotifiche() {
        Task {
            let concesso = await ServizioNotifiche.condiviso.richiediPermesso()
            if !concesso {
                notificheAttive = false
                mostraErrorePermesso = true
            }
        }
    }
}

#Preview {
    ImpostazioniView()
        .environment(SpeseViewModel.anteprima)
}
