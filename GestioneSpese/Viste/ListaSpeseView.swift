import SwiftUI

struct ListaSpeseView: View {

    @Environment(SpeseViewModel.self) private var viewModel
    @AppStorage(ChiaviImpostazioni.budgetMensile) private var budgetMensile: Double = 0

    @State private var mostraNuovaSpesa = false
    @State private var spesaDaModificare: Spesa?

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            List {
                Section {
                    RiepilogoView(totaleMese: viewModel.totaleMeseCorrente,
                                  totaleGenerale: viewModel.totaleGenerale,
                                  budget: budgetMensile)
                }

                Section("Spese") {
                    if viewModel.speseFiltrate.isEmpty {
                        Text("Nessuna spesa trovata")
                            .foregroundStyle(.secondary)
                    }

                    ForEach(viewModel.speseFiltrate) { spesa in
                        RigaSpesaView(spesa: spesa)
                            .contentShape(Rectangle())
                            .onTapGesture { spesaDaModificare = spesa }
                    }
                    .onDelete { indici in
                        viewModel.elimina(daIndici: indici)
                    }
                }
            }
            .navigationTitle("Le mie spese")
            .searchable(text: $viewModel.testoRicerca, prompt: "Cerca una spesa")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    menuFiltro
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostraNuovaSpesa = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostraNuovaSpesa) {
                ModificaSpesaView()
            }
            .sheet(item: $spesaDaModificare) { spesa in
                ModificaSpesaView(spesaEsistente: spesa)
            }
        }
    }

    @ViewBuilder
    private var menuFiltro: some View {
        @Bindable var viewModel = viewModel

        Menu {
            Picker("Categoria", selection: $viewModel.categoriaFiltro) {
                Text("Tutte").tag(CategoriaSpesa?.none)
                ForEach(CategoriaSpesa.allCases) { categoria in
                    Label(categoria.nome, systemImage: categoria.icona)
                        .tag(CategoriaSpesa?.some(categoria))
                }
            }
        } label: {
            Image(systemName: viewModel.categoriaFiltro == nil
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
        }
    }
}

#Preview {
    ListaSpeseView()
        .environment(SpeseViewModel.anteprima)
}
