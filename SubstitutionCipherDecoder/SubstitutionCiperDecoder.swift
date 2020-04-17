import Foundation

struct SubstitutionCiperDecoder {
    var dict: [Character: Character] = [:]
    private let bigramLetterProbability = NGramDistance(frombundleFileWithName: "count-2l.txt")!
    private let trigramLetterProbability = NGramDistance(frombundleFileWithName: "count-3l.txt")!
    func decode(words: [String]) -> String {
        let trigrams = letterNGrams(n: 3, from: words)
        return ""
    }
    private func localMaximum(from words: [String],
                              key: [Character: Character],
                              decryptionFitness: ([String]) -> Double,
                              numberOfSteps: [Character: Character]) -> [String] {
        let decryption = decrypt(words, using: key)
        let value = decryptionFitness(decryption)
        
        return []
    }
    
    private func decrypt(_ words: [String], using key: [Character: Character]) -> [String] {
        words.map { String($0.map { key[$0]! }) }
    }
    
    private func evaluatePosition(from trigrams: [String]) -> Double {
        return trigrams.map { trigramLetterProbability.getFrequency(forKey: $0) }.reduce(0) { $0 + log10($1) }
    }
    
    private func neighboringKeys(from words: [String], using key: [Character: Character]) {
        
    }
    
    private func letterNGrams(n: Int, from words: [String]) -> [String] {
        var nGrams = [String]()
        for word in words {
            let wordArr = Array(word).map { String($0) }
            for i in 0..<wordArr.count {
                nGrams.append(wordArr[i..<i+n].reduce("", +))
            }
        }
        return nGrams
    }
    private func letterNGrams(n: Int, from msg: String) -> [String] {
        // TODO: Add support for splitting string into probable words
        fatalError()
    }
}
