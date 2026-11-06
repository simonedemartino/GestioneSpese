import SwiftUI

struct RigaSpesaView: View {
    let spesa: Spesa

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: spesa.categoria.icona)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(spesa.categoria.colore, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(spesa.titolo)
                    .font(.headline)
                Text("\(spesa.categoria.nome) · \(spesa.data.comeDataBreve)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(spesa.importo.comeValuta)
                .font(.subheadline.bold())
        }
    }
}

#Preview {
    RigaSpesaView(spesa: Spesa(titolo: "Spesa al supermercato", importo: 54.30, categoria: .cibo))
        .padding()
}
