//
//  RecipeModel.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 03/12/20.
//

import Foundation
import UIKit
import Alamofire

struct RecipeModel {
    private let name: String!
    private let category: String!
    private let ingredients: [String]!
    private let instructions: String!
    private let count: Int!
    private let imageData: Data?
    private let image:UIImage?
    private var headers:HTTPHeaders = ["token": UserModel.getToken()]
    
    public enum RecipeError: String {
        case valid = "Receta válida."
        case mandatory = "Todos los campos son obligatorios."
    }
    
    public enum RecipeCategories: String {
        case entrada = "Entrada"
        case sopa = "Sopa"
        case plato = "Plato fuerte"
        case postre = "Postre"
    }
    
    init(name: String, category: String, ingredients: [String], instructions: String, count: Int, image: UIImage? ) {
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.category = category.trimmingCharacters(in: .whitespaces)
        self.ingredients = ingredients
        self.instructions = instructions.trimmingCharacters(in: .whitespaces)
        self.count = count
        
        if image != nil {
            self.imageData = image?.jpegData(compressionQuality: 0.2)
            self.image = image
        } else {
            self.imageData = nil
            self.image = nil
        }
    }
    
    //Getters
    
    public func getName() -> String {
        return self.name
    }
    
    public func getImage() -> UIImage? {
        return self.image
    }
    
    public func getCategory() -> String {
        return self.category
    }
    
    public func validateRecipe() -> RecipeError {
        
        if(name == "" || category == "" || instructions == "" || count <= 0 || ingredients.count == 0 || imageData == nil) {
            return.mandatory
        } else {
            return .valid
        }
    }
    
    private func parseIngredients() -> String {
        var result = ""
        for item in ingredients {
            result = "\(result)|\(item)"
        }
        
        return result
    }
    
    public func createRecipe(completion: @escaping (Int, Dictionary<String,Any>) -> Void) {
        let ingredientsString = parseIngredients()
        let body:[String:String] = ["name":name, "category":category, "ingredients":ingredientsString, "count":String(count), "instructions":instructions]
        NetWorkService.httpUpload(url: "/recipe/create", method: .post, headers: headers, parameters: body, data: imageData!, paramName: "image", fileName: "recipe.jpeg", mimeType: "image/jpg") { (status, json) in
            completion(status, json)
        }
    }
    
    public static func getRecipesByCategory(completion: @escaping (Int, Dictionary<String, Any>) -> Void) {
        let headers:HTTPHeaders = ["token": UserModel.getToken(), "Content-Type": "application/x-www-form-urlencoded"]
        NetWorkService.httpRequest(url: "/recipe", method: .get, parameters: [:], headers: headers) { (status, json) in
            completion(status, json)
        }
    }
}
