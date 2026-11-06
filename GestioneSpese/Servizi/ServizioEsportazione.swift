import SwiftUI
import UniformTypeIdentifiers

enum ServizioEsportazione {

    static func generaCSV(da spese: [Spesa]) -> String {
        let formattatoreData = DateFormatter()
        formattatoreData.dateFormat = "yyyy-MM-dd"

        var righe = ["Data;Titolo;Categoria;Importo;Note"]

        for spesa in spese.sorted(by: { $0.data > $1.data }) {
            let importo = String(format: "%.2f", spesa.importo)
                .replacingOccurrences(of: ".", with: ",")
            let campi = [
                formattatoreData.string(from: spesa.data),
                proteggi(spesa.titolo),
                spesa.categoria.nome,
                importo,
                proteggi(spesa.note)
            ]
            righe.append(campi.joined(separator: ";"))
        }

        return "\u{FEFF}" + righe.joined(separator: "\n")
    }

    private static func proteggi(_ testo: String) -> String {
        "\"" + testo.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}

struct DocumentoCSV: Transferable {
    let testo: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .commaSeparatedText) { documento in
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("Spese.csv")
            try documento.testo.write(to: url, atomically: true, encoding: .utf8)
            return SentTransferredFile(url)
        }
    }
}
