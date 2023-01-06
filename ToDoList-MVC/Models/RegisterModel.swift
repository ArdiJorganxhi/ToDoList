//
//  RegisterModel.swift
//  ToDoList-MVC
//
//  Created by Ardi Jorganxhi on 6.1.23.
//

import Foundation



struct RegisterModel: Decodable {

    var name: String?
    var surname: String?
    var mail: String?
    var password: String?
}
