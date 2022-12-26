//
//  APIService.swift
//  ToDoList
//
//  Created by Ardi Jorganxhi on 13.12.22.
//

import Foundation



enum AuthenticationError: Error {

    case invalidCredientals
    case custom(errorMessage: String)
}


enum NetworkError: Error {

    case invalidURL
    case noData
    case decodingError
    case custom(errorMessage: String)

}


struct RegisterModel: Decodable{

    var name: String = ""
    var surname: String = ""
    var mail: String = ""
    var password: String = ""
    
}

struct LoginModel: Decodable {

    var mail: String = ""
    var password: String = ""
}

struct RegisterResponse: Codable {

    var status: Int?

}

struct LoginResponse: Codable {

    var content: String?
    var status: Int?


}


class APIService {

    var registerUrl = "http://todolist-api.oguzhanercelik.dev/auth"
    var loginUrl = "http://todolist-api.oguzhanercelik.dev/auth/login"
    var getUserUrl = "http://todolist-api.oguzhanercelik.dev/api/user"


    func register(name: String, surname: String, mail: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void){

        guard let url = URL(string: registerUrl) else {

            completion(.failure(.invalidURL))
            return

        }

        let body: [String: AnyHashable] = ["name": name, "surname": surname, "mail": mail, "password": password]

        let bodyJSON = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request){ data, res, err in

            guard let data = data, err == nil else{
                completion(.failure(.noData))
                return
            }

            do{

                guard let res = try? JSONDecoder().decode(RegisterResponse.self, from: data)
                else{
                    completion(.failure(.decodingError))
                    return
                }

                completion(.success("User is registered!"))



            }


            
        }.resume()

        
    }


    func login(mail: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void){

        guard let url = URL(string: loginUrl) else {

            completion(.failure(.custom(errorMessage: "URL is not correct!")))

            return}

        let body: [String: AnyHashable] = ["mail": mail, "password": password]

        let bodyJSON = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request){ data, res, err in

            guard let data = data, err == nil else{
                completion(.failure(.custom(errorMessage: "No data!")))
                return
            }

            do{

                guard let res = try? JSONDecoder().decode(LoginResponse.self, from: data)
                else{
                    completion(.failure(.invalidCredientals))
                    return
                }




                guard let token = res.content else{
                    completion(.failure(.custom(errorMessage: "Token is not found!")))
                    
                    return
                }

                completion(.success(token))

            }



        }.resume()










        

    }


    func getUser(token: String, completion: @escaping (Result<AccountModel, NetworkError>) -> Void){
        var accountData: [AccountModel] = []
        guard let url = URL(string: getUserUrl) else {

            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {data, res, err in

            guard let data = data, err == nil else {
                completion(.failure(.custom(errorMessage: "No account!")))
                return
            }
           

            do {
                 let res = try JSONDecoder().decode(AccountModel.self, from: data)



                print(res)
                completion(.success(res))
            } catch(let err){
                print(err)
            }



        }.resume()




    }



    
}

