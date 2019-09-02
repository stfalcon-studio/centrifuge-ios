//
//  CentrifugeServerMessageParserImpl.swift
//  Pods
//
//  Created by German Saprykin on 19/04/16.
//
//

protocol CentrifugeServerMessageParser {
    func parse(data: Data) throws -> [CentrifugeServerMessage]
}

class CentrifugeServerMessageParserImpl: CentrifugeServerMessageParser {
    func parse(data: Data) throws -> [CentrifugeServerMessage] {
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            var messages = [CentrifugeServerMessage]()

            if let infos = response as? [[String : AnyObject]] {
                for info in infos {
                    if let message = messageParse(info: info){
                        messages.append(message)
                    }
                }
            }

            if let info = response as? [String : AnyObject] {
                if let message = messageParse(info: info){
                    messages.append(message)
                }
            }

            return messages

        }catch {
            //TODO: add error thrown
            assertionFailure("Error: Invalid message json")
            return []
        }
    }

    func messageParse(info: [String : AnyObject]) -> CentrifugeServerMessage? {
        var error: String?

        if let err = info["error"] as? String {
            error = err
        }

        var responseMethod: CentrifugeMethod?

        if let methodName = info["method"] as? String, let method = CentrifugeMethod(rawValue: methodName) {
            responseMethod = method
        }

        var body: [String: AnyObject]?

        if let bd = info["result"] as? [String : AnyObject] {
            body = bd
        }

        return CentrifugeServerMessage(error: error,method: responseMethod, body: body)
    }
}
