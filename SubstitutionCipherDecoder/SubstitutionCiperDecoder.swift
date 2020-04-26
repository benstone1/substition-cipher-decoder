import Foundation

struct NGramUtility {
    static let singleWordProbability = NGramDistance(frombundleFileWithName: "one-grams.txt")!
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
    static func wordSequenceFitness(of words: [String]) -> Double {
        return words.reduce(0) { $0 + log10(singleWordProbability.frequencies[$1] ?? 0) }
    }
    static func letterNGrams(n: Int, from msg: String) -> [String] {
        // TODO: Add support for splitting string into probable words
        fatalError()
    }
}

struct SubstitutionCiperDecoder {
    var dict: [Character: Character] = [:]
    
    func decode(words: [String]) -> [String] {
        print("decoding message: \(words)")
        let startingKeys = Array(repeating: getRandomKey(), count: 20)
        var bestDecryption = (msg: [""], fitness: 0.0)
        for key in startingKeys {
            let localMax = localMaximum(from: words,
                                        key: key,
                                        decryptionFitness: evaluatePosition,
                                        numberOfSteps: 2000)
            let fitness = NGramUtility.wordSequenceFitness(of: words)
            if fitness > bestDecryption.fitness {
                bestDecryption = (localMax, fitness)
            }
        }
        return bestDecryption.msg
    }
    
    private func localMaximum(from words: [String],
                              key: [Character: Character],
                              decryptionFitness: ([String]) -> Double,
                              numberOfSteps: Int) -> [String] {
        let decryption = decrypt(words, using: key)
        var maxValue = decryptionFitness(decryption)
        for _ in 0..<numberOfSteps {
            var neighboringKeys = NeighboringKeys(key: key, decryptedMessage: decryption)
            for neighboringKey in neighboringKeys {
                let newDecryption = decrypt(words, using: neighboringKey)
                let newValue = decryptionFitness(newDecryption)
                if newValue > maxValue {
                    maxValue = newValue
                    neighboringKeys.updateKey(to: neighboringKey)
                    neighboringKeys.updateDecryptedMessage(to: newDecryption)
                }
            }
        }
        return decryption
    }
    
    private func decrypt(_ words: [String], using key: [Character: Character]) -> [String] {
        words.map { String($0.map { key[$0]! }) }
    }
    
    private func evaluatePosition(from trigrams: [String]) -> Double {
        return trigrams.map { NGramUtility.trigramLetterProbability.getFrequency(forKey: $0) }.reduce(0) { $0 + log10($1) }
    }
    
    private func getRandomKey() -> [Character: Character] {
        let alphabet = Array("abcdefghijklmnopqrstuvwxyz").map { "\($0)" }
        let shuffledAlphabet = alphabet.shuffled()
        var randomKey = [Character: Character]()
        for i in 0..<alphabet.count {
            randomKey[Character(alphabet[i])] = Character(shuffledAlphabet[i])
        }
        return randomKey
    }
        
    struct NeighboringKeys: Sequence, IteratorProtocol {
        private var key: [Character: Character]
        private var decryptedMessage: [String]
        private let alphabet = Array("abcdefghijklmnopqrstuvwxyz").map { "\($0)" }
        
        init(key: [Character: Character], decryptedMessage: [String]) {
            self.key = key
            self.decryptedMessage = decryptedMessage
        }
        
        mutating func updateKey(to newKey: [Character: Character]) {
            self.key = newKey
        }
        
        mutating func updateDecryptedMessage(to newMessage: [String]) {
            self.decryptedMessage = newMessage
        }
        
        mutating func next() -> [Character: Character]? {
            let bigramFrequencies = NGramUtility.bigramLetterProbability.frequencies
            let bigrams = NGramUtility.letterNGrams(n: 2, from: decryptedMessage).sorted { nGram1, nGram2 in
                return bigramFrequencies[nGram1] ?? Double.greatestFiniteMagnitude < bigramFrequencies[nGram2] ?? Double.greatestFiniteMagnitude
                }[0..<30]
            for bigram in bigrams {
                let firstLetter = "\(bigram.first!)"
                let secondLetter = "\(bigram.last!)"
                let shuffledAlphabet = alphabet.shuffled()
                for alphaLetter in shuffledAlphabet {
                    if firstLetter == secondLetter && bigramFrequencies[alphaLetter + alphaLetter]! > bigramFrequencies[firstLetter + secondLetter]! {
                        return keyswap(key: key,
                                       firstLetter: Character(alphaLetter),
                                       secondLetter: Character(secondLetter))
                    } else if bigramFrequencies[alphaLetter + secondLetter]! > bigramFrequencies[firstLetter + secondLetter]! {
                        return keyswap(key: key,
                                       firstLetter: Character(alphaLetter),
                                       secondLetter: Character(firstLetter))
                    } else if bigramFrequencies[firstLetter + alphaLetter]! > bigramFrequencies[firstLetter + secondLetter]! {
                        return keyswap(key: key,
                                       firstLetter: Character(alphaLetter),
                                       secondLetter: Character(secondLetter))
                    }
                }
            }
            return keyswap(key: key,
                           firstLetter: Character(alphabet.randomElement()!),
                           secondLetter: Character(alphabet.randomElement()!))
        }
        private func keyswap(key: [Character: Character], firstLetter: Character, secondLetter: Character) -> [Character: Character] {
            var newKey = key
            newKey[firstLetter] = key[secondLetter]
            newKey[secondLetter] = key[firstLetter]
            return newKey
        }
    }
}

