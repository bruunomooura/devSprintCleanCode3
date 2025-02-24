import Foundation
import UIKit

class BadNetworkLayer {
    static let shared = BadNetworkLayer()
    func checkPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func sendPasswordEmail(_ targetVc: UIViewController,
                           parameters: [String : String],
                           completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func createPassword(_ targetVc: UIViewController,
                        parameters: [String : String],
                        completionHandler: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            let uuid = UUID.init().uuidString
            completionHandler(uuid)
        }
    }

    

    func resetPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void) {

        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func login(_ targetVc: UIViewController,
               parameters: [String : String],
               completionHandler: @escaping (Session?) -> Void) {

        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        let endpoint = Endpoints.Auth.login
        AF.shared.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            targetVc.stopLoading()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let session = try? decoder.decode(Session.self, from: data) {
                    completionHandler(session)
                } else {
                    completionHandler(nil)
                }
            case .failure(let error):
                print("error Login: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
}


struct Messaging {
    static let messaging = Messaging()

    func token(completion: @escaping (String?, Error?)->Void) {
        let token = UUID.init().uuidString
        completion(token, nil)
    }
}




protocol ConnectivityManagerProxy {
    var isConnected: Bool { get }
}

class ConnectivityManager {
    static let shared = ConnectivityManager()

    var isConnected: Bool {
        let randomInt = Int.random(in: 0..<10)
        return randomInt > 2
    }
}

extension ConnectivityManager: ConnectivityManagerProxy {}

enum Methods {
    case get
    case post
}

protocol Networking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]?, completion: @escaping ((Result<Data, Error>) -> Void))
}

extension Networking {
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]? = nil, completion: @escaping ((Result<Data, Error>) -> Void)) {
        request(url, method: method, parameters: parameters, headers: headers, completion: completion)
    }
}


struct AF: Networking {
    static let shared = AF()
    
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]? = nil, completion: @escaping ((Result<Data, Error>) -> Void)) {
        switch url {
        case Endpoints.Auth.login:
            if let email = parameters?["email"],
               let password = parameters?["password"],
               email == "clean.code@devpass.com" && password == "123456" {

                let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
                let data = try? JSONEncoder().encode(session)
                if let data = data {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        completion(.success(data))
                    }
                } else {
                    completion(.failure(ServiceErros.invalidData))
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.failure(ServiceErros.invalidData))
                }
            }

        case Endpoints.contactUs:
            let contacUsModel = ContactUsModel(whatsapp: "37998988822",
                                               phone: "08001234567",
                                               mail: "cleanCode@devPass.com")
            let data = try? JSONEncoder().encode(contacUsModel)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }

        case Endpoints.sendMessage:
            if let data = "sucesso".data(using: .utf8) {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }
        case Endpoints.Auth.resetPassword:
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                completion(.success(Data()))
            }
        case Endpoints.Auth.createUser:
            let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
            let data = try? JSONEncoder().encode(session)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceErros.invalidData))
            }

        default:
            completion(.failure(ServiceErros.failure))
        }
    }
}



enum ServiceErros: Error {
    case invalidData
    case failure
}

enum Auth {
    class auth {
        func signIn(withCustomToken: String, completion: (Bool, Error?) -> Void) {
            completion(true, nil)
        }
    }
}
