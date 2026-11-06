import SwiftUI
import Charts

enum TipoGrafico: String, CaseIterable, Identifiable {
    case torta = "Torta"
    case barre = "Barre"

    var id: String { rawValue }
}

struct StatisticheView: View {

    @Environment(SpeseViewModel.self) private var viewModel
    @State private var tipoGrafico: TipoGrafico = .torta

    var body: some View {
        NavigationStack {
            List {
                if viewModel.totaliPerCategoria.isEmpty {
                    Text("Aggiungi qualche spesa per vedere le statistiche")
                        .foregroundStyle(.secondary)
                } else {
                    Section {
                        Picker("Tipo di grafico", selection: $tipoGrafico) {
                            ForEach(TipoGrafico.allCases) { tipo in
                                Text(tipo.rawValue).tag(tipo)
                            }
                        }
                        .pickerStyle(.segmented)

                        grafico
                            .padding(.vertical, 8)
                    } header: {
                        Text("Spese per categoria")
                    }

                    Section("Dettaglio") {
                        ForEach(viewModel.totaliPerCategoria) { elemento in
                            HStack {
                                Label(elemento.categoria.nome,
                                      systemImage: elemento.categoria.icona)
                                    .foregroundStyle(elemento.categoria.colore)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(elemento.totale.comeValuta)
                                        .bold()
                                    Text(percentuale(di: elemento.totale))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statistiche")
        }
    }

    @ViewBuilder
    private var grafico: some View {
        switch tipoGrafico {
        case .torta:
            Chart(viewModel.totaliPerCategoria) { elemento in
                SectorMark(
                    angle: .value("Totale", elemento.totale),
                    innerRadius: .ratio(0.55),
                    angularInset: 1.5
                )
                .cornerRadius(4)
                .foregroundStyle(elemento.categoria.colore)
            }
            .frame(height: 260)

        case .barre:
            Chart(viewModel.totaliPerCategoria) { elemento in
                BarMark(
                    x: .value("Categoria", elemento.categoria.nome),
                    y: .value("Totale", elemento.totale)
                )
                .foregroundStyle(elemento.categoria.colore)
            }
            .frame(height: 260)
        }
    }

    private func percentuale(di valore: Double) -> String {
        guard viewModel.totaleGenerale > 0 else { return "0%" }
        return (valore / viewModel.totaleGenerale)
            .formatted(.percent.precision(.fractionLength(0)))
    }
}

#Preview {
    StatisticheView()
        .environment(SpeseViewModel.anteprima)
}
