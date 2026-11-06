import SwiftUI

struct VistaPrincipale: View {
    var body: some View {
        TabView {
            ListaSpeseView()
                .tabItem { Label("Spese", systemImage: "list.bullet") }

            StatisticheView()
                .tabItem { Label("Statistiche", systemImage: "chart.pie.fill") }

            ImpostazioniView()
                .tabItem { Label("Impostazioni", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    VistaPrincipale()
        .environment(SpeseViewModel.anteprima)
}
