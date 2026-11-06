import UserNotifications

final class ServizioNotifiche: NSObject, UNUserNotificationCenterDelegate {

    static let condiviso = ServizioNotifiche()

    private let centro = UNUserNotificationCenter.current()

    func configura() {
        centro.delegate = self
    }

    func richiediPermesso() async -> Bool {
        let concesso = try? await centro.requestAuthorization(options: [.alert, .sound, .badge])
        return concesso ?? false
    }

    func inviaAvviso(titolo: String, messaggio: String) {
        let contenuto = UNMutableNotificationContent()
        contenuto.title = titolo
        contenuto.body = messaggio
        contenuto.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let richiesta = UNNotificationRequest(identifier: UUID().uuidString,
                                              content: contenuto,
                                              trigger: trigger)
        centro.add(richiesta)
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
