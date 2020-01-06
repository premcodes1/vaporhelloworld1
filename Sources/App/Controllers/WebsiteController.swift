//
//  WebsiteController.swift
//  App
//
//  Created by Prem Nalluri on 06/01/20.
//

import Foundation
import Vapor
import Leaf
struct WebsiteController : RouteCollection{
    func boot(router: Router) throws {
        router.get(use: indexHandler)
    }
    func indexHandler(_ req : Request) throws -> Future<View> {
        return try req.view().render("index")
    }
}
