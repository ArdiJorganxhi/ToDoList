//
//  AuthenticationError.swift
//  ToDoList-MVC
//
//  Created by Ardi Jorganxhi on 6.1.23.
//

import Foundation


enum AuthenticationError: Error {

case invalidCredientals
 case custom(errorMessage: String)
}
