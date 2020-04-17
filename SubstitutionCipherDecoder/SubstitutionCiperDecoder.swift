import Foundation

struct NGramUtility {
    static let bigramLetterProbability = NGramDistance(frombundleFileWithName: "count-2l.txt")!
    static let trigramLetterProbability = NGramDistance(frombundleFileWithName: "count-3l.txt")!
    static func letterNGrams(n: Int, from words: [String]) -> [String] {
        var nGrams = [String]()
        for word in words {
            let wordArr = Array(word).map { String($0) }
            for i in 0..<wordArr.count {
                nGrams.append(wordArr[i..<i+n].reduce("", +))
            }
        }
        return nGrams
    }
    static func letterNGrams(n: Int, from msg: String) -> [String] {
        // TODO: Add support for splitting string into probable words
        fatalError()
    }
}

struct SubstitutionCiperDecoder {
    var dict: [Character: Character] = [:]
    
    func decode(words: [String]) -> String {
        let trigrams = NGramUtility.letterNGrams(n: 3, from: words)
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
        return trigrams.map { NGramUtility.trigramLetterProbability.getFrequency(forKey: $0) }.reduce(0) { $0 + log10($1) }
    }
    
    private func neighboringKeys(from words: [String], using key: [Character: Character]) {
        
    }
    
    struct NeighboringKeys: Sequence, IteratorProtocol {
        let key: [Character: Character]
        let decryptedMessage: [String]
        
        init(key: [Character: Character], decryptedMessage: [String]) {
            self.key = key
            self.decryptedMessage = decryptedMessage
        }
        mutating func next() -> [Character: Character]? {
            let bigramFrequencies = NGramUtility.bigramLetterProbability.frequencies
            let bigrams = NGramUtility.letterNGrams(n: 2, from: decryptedMessage).sorted { nGram1, nGram2 in
                return bigramFrequencies[nGram1] ?? Double.greatestFiniteMagnitude < bigramFrequencies[nGram2] ?? Double.greatestFiniteMagnitude
                }[0..<30]
            for bigram in bigrams {
                let firstLetter = bigrams.first!
                let secondLetter = bigrams.last!
                let shuffledAlphabet = Array("abcdefghijklmnopqrstuvwxyz").map { "\($0)" }.shuffled()
                for alphaLetter in shuffledAlphabet {
                    if firstLetter == secondLetter && bigramFrequencies[alphaLetter + alphaLetter]! > bigramFrequencies[firstLetter + secondLetter] {
                        return
                    }
                }
            }
            
            return nil
        }
        private func keyswap(key: [Character: Character], firstLetter: String, secondLetter: String) {
            var newKey = key
            newKey[firstLetter + secondLetter] = secondLetter + firstLetter
        }
    }
}

