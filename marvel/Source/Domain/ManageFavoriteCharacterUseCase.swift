//
//  ManageFavoriteCharacterUseCase.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation

struct ManageFavoriteCharacterUseCase {
    
    private var key: String {
        return "favorite_characters"
    }
    
    func fetchFavoriteCharacterList() -> [Int] {
        return UserDefaults
            .standard
            .array(forKey: key) as? [Int] ?? []
    }
    
    func updateFavoriteCharacter(_ id: Int) {
        
        var newArray = fetchFavoriteCharacterList()
        
        if let index = newArray.firstIndex(of: id) {
            newArray.remove(at: index)
        }
        else {
            newArray.append(id)
        }
        
        UserDefaults.standard.setValue(newArray, forKey: key)
    }
    
    func checkFavoriteCharacter(_ id: Int) -> Bool {
        fetchFavoriteCharacterList().contains(id)
    }
}
