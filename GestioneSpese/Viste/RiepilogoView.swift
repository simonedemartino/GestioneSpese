import SwiftUI

struct RiepilogoView: View {
    let totaleMese: Double
    let totaleGenerale: Double
    let budget: Double

    private var percentuale: Double {
        budget > 0 ? totaleMese / budget : 0
    }

    private var coloreBudget: Color {
        switch percentuale {
        case ..<0.8: return .green
        case ..<1.0: return .orange
        default:     return .red
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                colonna(titolo: "Questo mese", valore: totaleMese)
                Divider()
                colonna(titolo: "Totale", valore: totaleGenerale)
            }

            if budget > 0 {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: min(percentuale, 1))
                        .tint(coloreBudget)
                    Text("Budget: \(percentuale.formatted(.percent.precision(.fractionLength(0)))) di \(budget.comeValuta)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func colonna(titolo: String, valore: Double) -> some View {
        VStack(spacing: 4) {
            Text(titolo)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valore.comeValuta)
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity)
    }
}
