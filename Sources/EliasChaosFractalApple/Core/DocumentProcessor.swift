import Foundation
import PDFKit

class DocumentProcessor {
    func extractText(from url: URL) -> String? {
        if url.pathExtension.lowercased() == "txt" {
            return try? String(contentsOf: url, encoding: .utf8)
        } else if url.pathExtension.lowercased() == "pdf" {
            guard let pdfDocument = PDFDocument(url: url) else { return nil }
            var text = ""
            for pageIndex in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: pageIndex) {
                    text += page.string ?? ""
                }
            }
            return text
        }
        return nil
    }

    func extractKeywords(from text: String) -> [String: Int] {
        let words = text.lowercased().components(separatedBy: CharacterSet.whitespacesAndNewlines)
        var keywords: [String: Int] = [:]
        for word in words {
            if word.count > 3 {
                keywords[word, default: 0] += 1
            }
        }
        return keywords
    }

    func extractPhrases(from text: String) -> [String: Int] {
        let sentences = text.components(separatedBy: ". ")
        var phrases: [String: Int] = [:]
        for sentence in sentences {
            if sentence.contains("entropy") || sentence.contains("swarm") || sentence.contains("peers") {
                phrases[sentence.lowercased(), default: 0] += 1
            }
        }
        return phrases
    }

    // Stress test fix: Cap document size at 10MB
    func processDocument(url: URL) -> Bool {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let fileSize = attributes[.size] as? Int else { return false }
        let maxSize = 10 * 1024 * 1024 // 10MB
        return fileSize <= maxSize
    }
}
