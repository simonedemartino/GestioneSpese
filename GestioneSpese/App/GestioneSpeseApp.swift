import SwiftUI
import SwiftData

@main
struct GestioneSpeseApp: App {

    private let contenitore: ModelContainer

    @State private var viewModel: SpeseViewModel

    init() {
        do {
            let contenitore = try ModelContainer(for: Spesa.self)
            self.contenitore = contenitore
            _viewModel = State(initialValue: SpeseViewModel(contenitore: contenitore))
        } catch {
            fatalError("Impossibile creare il database: \(error)")
        }

        ServizioNotifiche.condiviso.configura()
    }

    var body: some Scene {
        WindowGroup {
            VistaPrincipale()
                .environment(viewModel)
        }
    }
}
