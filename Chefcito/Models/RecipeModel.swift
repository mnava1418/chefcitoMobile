//
//  RecipeModel.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 03/12/20.
//

import Foundation
import UIKit
import Alamofire

enum Section {
    case main
}

class RecipeModel: Hashable {
    private var name: String!
    private var category: String!
    private var ingredients: [String]!
    private var instructions: String!
    private var count: Int!
    private var imageData: Data?
    private var image:UIImage?
    private var imageURL: URL?
    private var identifier = UUID()
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
        
        static let allCases = [entrada, sopa, plato, postre]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(name: String, category: String, ingredients: [String], instructions: String, count: Int, image: UIImage?, imageURL: URL? ) {
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.category = category.trimmingCharacters(in: .whitespaces)
        self.ingredients = ingredients
        self.instructions = instructions.trimmingCharacters(in: .whitespaces)
        self.count = count
        
        if image != nil {
            self.imageData = image?.jpegData(compressionQuality: 0.2)
        } else {
            self.imageData = nil
        }
        
        self.image = image
        self.imageURL = imageURL
    }
    
    // MARK: - Getters
    public func getName() -> String {
        return self.name
    }
    
    public func getCategory() -> String {
        return self.category
    }
    
    public func getImageURL() -> URL? {
        return self.imageURL
    }
    
    public func getImage() -> UIImage? {
        return self.image
    }
    
    // MARK: - Setters
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    // MARK: - Methods
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
