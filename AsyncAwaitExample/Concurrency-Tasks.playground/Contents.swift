import UIKit

enum NetworkError: Error {
    case badUrl
    case decodingError
    case invalidId
}

struct CreditScore: Decodable {
    let score: Int
}

struct Constants {
    struct Urls {
        static func equifax(userId: Int) -> URL? {
            return URL(string: "https://ember-sparkly-rule.glitch.me/equifax/credit-score/\(userId)")
        }
        
        static func experian(userId: Int) -> URL? {
            return URL(string: "https://ember-sparkly-rule.glitch.me/experian/credit-score/\(userId)")
        }
    }
}

func calculateAPR(creditScores: [CreditScore]) -> Double {
    let sum = creditScores.reduce(0) { next, credit in
        return next + credit.score
    }
    
    return Double((sum/creditScores.count)/100)
}

func getARP(userId: Int) async throws -> Double {
    
    print("getARP")
    
    if userId % 2 == 0 {
        throw NetworkError.invalidId
    }
    
    guard let equifaxURL = Constants.Urls.equifax(userId: userId), let experianURL = Constants.Urls.experian(userId: userId) else {
        throw NetworkError.badUrl
    }
    
    //Do task concurrencly and more easier to do test
    
    async let (equifaxData, _) = URLSession.shared.data(from: equifaxURL)
    async let (experianData, _) = URLSession.shared.data(from: experianURL)
    
    let equifaxCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await equifaxData)
    
    let experianCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await experianData)
    
    guard let equifaxCreditScore = equifaxCreditScore, let experianCreditScore = experianCreditScore else {
        throw NetworkError.decodingError
    }

    return calculateAPR(creditScores: [equifaxCreditScore, experianCreditScore])
}

let ids = [1,2,3,4,5]
var invalidIds: [Int] = []
Task {
    for id in ids {
        do {
            try Task.checkCancellation()
            let apr = try await getARP(userId: id)
            print(apr)
        } catch {
            print(error)
            invalidIds.append(id)
        }
    }
    print(invalidIds)
}
