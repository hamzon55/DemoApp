struct MarvelResponse: Codable {
    var data: HeroClass
    
    init(pagination: Pagination,
         total: Int,
         count: Int,
         results: [Character]) {
        
        let heroClass = HeroClass(pagination: pagination, total: total, count: count, results: results)
        self.data = heroClass
    }
}

struct HeroClass: Codable {
    
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    var results: [Character]
    
    init(pagination: Pagination, total: Int, count: Int, results: [Character]) {
        self.offset = pagination.offset
        self.limit = pagination.limit
        self.total = total
        self.count = count
        self.results = results
    }
}


