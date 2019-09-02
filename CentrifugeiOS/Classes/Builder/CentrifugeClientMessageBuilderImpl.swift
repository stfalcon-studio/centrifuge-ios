//
//  CentrifugeClientMessageBuilderImpl.swift
//  Pods
//
//  Created by German Saprykin on 18/04/16.
//
//


protocol CentrifugeClientMessageBuilder {
    func buildConnectMessage(credentials: CentrifugeCredentials) -> CentrifugeClientMessage
    func buildDisconnectMessage() -> CentrifugeClientMessage
    func buildSubscribeMessageTo(channel: String) -> CentrifugeClientMessage
    func buildSubscribeMessageTo(channel: String, lastMessageUUID: String) -> CentrifugeClientMessage
    func buildUnsubscribeMessageFrom(channel: String) -> CentrifugeClientMessage
    func buildPresenceMessage(channel: String) -> CentrifugeClientMessage
    func buildHistoryMessage(channel: String) -> CentrifugeClientMessage
    func buildPingMessage() -> CentrifugeClientMessage
    func buildPublishMessageTo(channel: String, data: [String: Any]) -> CentrifugeClientMessage
}

class CentrifugeClientMessageBuilderImpl: CentrifugeClientMessageBuilder {

    func buildConnectMessage(credentials: CentrifugeCredentials) -> CentrifugeClientMessage {

        let token = credentials.token
        var params = ["token" : token,
                      "data": Dictionary<String, Any>()] as [String : Any]
        if let info = credentials.info {
            params["info"] = info
        }

        return buildMessage(id: 1, method: .сonnect, params: params)
    }

    func buildDisconnectMessage() -> CentrifugeClientMessage {
        return buildMessage(id: 0, method: .disconnect, params: [:])
    }

    func buildSubscribeMessageTo(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(id: 2, method: .subscribe, params: params)
    }

    func buildSubscribeMessageTo(channel: String, lastMessageUUID: String) -> CentrifugeClientMessage {
        let params: [String : Any] = ["channel" : channel,
                                      "recover" : true,
                                      "last" : lastMessageUUID]
        return buildMessage(id: 3, method: .subscribe, params: params)
    }

    func buildUnsubscribeMessageFrom(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(id: 4, method: .unsubscribe, params: params)
    }

    func buildPublishMessageTo(channel: String, data: [String : Any]) -> CentrifugeClientMessage {
        let params = ["channel" : channel,
                      "data" : data] as [String : Any]
        return buildMessage(id: 5, method: .publish, params: params)
    }

    func buildPresenceMessage(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(id: 6, method: .presence, params: params)
    }

    func buildHistoryMessage(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(id: 7, method: .history, params: params)
    }

    func buildPingMessage() -> CentrifugeClientMessage {
        return buildMessage(id: 8, method: .ping, params: [:])
    }

    private func buildMessage(id: Int, method: CentrifugeMethod, params: [String: Any]) -> CentrifugeClientMessage {
        let message = CentrifugeClientMessage(id: id, method: method, params: params)
        return message
    }

    private func generateUUID() -> String {
        return NSUUID().uuidString
    }

}
