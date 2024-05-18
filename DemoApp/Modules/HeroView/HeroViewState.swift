public enum HeroViewState {
    case idle
    case loading
    case success([Character])
    case failure(Error)
    case error(String)
}

extension HeroViewState: Equatable {
    public static func == (lhs: HeroViewState, rhs: HeroViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsSeries), .success(let rhsSeries)): return lhsSeries == rhsSeries
        case (.failure, .failure): return true
        default: return false
        }
    }
}
