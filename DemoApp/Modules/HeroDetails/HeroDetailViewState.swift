import Combine
protocol HeroeDetailViewModelType: AnyObject {
   // func transform(input: HeroDetailViewModelInput) -> HeroDetailViewModelOuput
}


public enum HeroDetailViewState {
    case idle
    case success([Character])
    case error(String)
}

extension HeroDetailViewState: Equatable {
    public static func == (lhs: HeroDetailViewState, rhs: HeroDetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsSeries), .success(let rhsSeries)): return lhsSeries == rhsSeries
        case (.error, .error): return true
        default: return false
        }
    }
}

struct HeroDetailViewModelInput {
    let appear: AnyPublisher<Void, Never>
}

