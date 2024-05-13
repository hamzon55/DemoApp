
struct MarvelResponse: Codable {
 var data: HeroClass
    
}

struct HeroClass: Codable {
    var results: [Character]
 
    enum CodingKeys :  String, CodingKey {
        case results = "results"
     }
    
}

