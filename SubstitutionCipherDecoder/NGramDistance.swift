import Foundation

struct NGramDistance {
    let frequencies: [String: Double]
    let gramCount: Int
    init?(frombundleFileWithName str: String) {
        guard let resource = str.components(separatedBy: ".").first,
            let type = str.components(separatedBy: ".").last,
            (str.filter { $0 == "." }.count == 1),
            let path = Bundle.main.path(forResource: resource, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            guard let text = String(data: data, encoding: .utf8) else { print("data not convertable to ut8 string"); return nil }
            let allLines = text.components(separatedBy: .newlines)
            self.frequencies = allLines.map { NGramFrequency(from: $0) }.reduce(into: [:]) { $0[$1.nGram] = $1.count }
            self.gramCount = allLines.count
        }
        catch {
            print(error)
            return nil
        }
    }
    func getFrequency(forKey key: String) -> Double {
        if let value = frequencies[key] {
            return value / Double(gramCount)
        } else {
            return 1 / Double(gramCount) * pow(10.0, Double(key.count) - 2)
        }
    }
}

struct NGramFrequency {
    let nGram: String
    let count: Double
    init(from str: String) {
        let components = str.components(separatedBy: .whitespaces)
        self.nGram = components[0]
        self.count = Double(components[1])!
    }
}
