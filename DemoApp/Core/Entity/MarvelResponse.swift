struct MarvelResponse: Codable {
    var data: HeroClass
    
    init(data: HeroClass) {
        self.data = data
    }
}

struct HeroClass: Codable {
    
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    var results: [Character]

    init(offset: Int,
         limit: Int,
         total: Int,
         count: Int,
         results: [Character]) {
        
        self.offset = offset
        self.limit = limit
        self.total = total
        self.count = count
        self.results = results
    }
}
