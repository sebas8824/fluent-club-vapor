//
//  Forum.swift
//  App
//
//  Created by Sebastian on 7/29/18.
//

import Foundation
import Fluent
import FluentSQLite
import Vapor

struct Forum: Content, SQLiteModel, Migration {
    var id: Int?
    var name: String
}


