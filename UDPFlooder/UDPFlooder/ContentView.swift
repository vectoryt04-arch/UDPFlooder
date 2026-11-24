// ContentView.swift — UDPFlooder UI
// SwiftUI | iOS 15+

import SwiftUI

struct ContentView: View {
    @StateObject private var flooder = UDPFlooder()
    @State private var ip: String = "192.168.1.1"
    @State private var port: String = "80"

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 28) {
                Text("UDP FLOODER")
                    .font(.system(size: 28, weight: .black, design: .monospaced))
                    .foregroundColor(.green)

                VStack(spacing: 12) {
                    HStack {
                        Text("IP")
                            .foregroundColor(.gray)
                            .frame(width: 50, alignment: .leading)
                        TextField("", text: $ip)
                            .keyboardType(.numbersAndPunctuation)
                            .autocorrectionDisabled()
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(6)
                    }
                    HStack {
                        Text("PORT")
                            .foregroundColor(.gray)
                            .frame(width: 50, alignment: .leading)
                        TextField("", text: $port)
                            .keyboardType(.numberPad)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal)

                VStack(spacing: 4) {
                    Text("\(flooder.packetCount)")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(flooder.running ? .green : .white)
                    Text("packets sent")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.gray)
                }

                Button {
                    if flooder.running {
                        flooder.stop()
                    } else {
                        guard let p = UInt16(port) else { return }
                        flooder.start(host: ip, port: p)
                    }
                } label: {
                    Text(flooder.running ? "■  STOP" : "▶  FLOOD")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(flooder.running ? Color.red : Color.green)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
