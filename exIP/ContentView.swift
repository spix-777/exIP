//
//  ContentView.swift
//  exIP
//
//  Created by Tony M. Karlsson on 04/10/2022.
//

import SwiftUI
import SwiftPublicIP
import AppKit


struct ContentView: View {
    @State private var IpEx: String = ""
    @State var currentDate = Date()     // Timer for View
    
    // MAC
    var MAC = GetMac()
    // private IIP
    var prIp: String! = getIPAddressForCellOrWireless()
    // publite IP
    func puIp() {
        var _: () = SwiftPublicIP.getPublicIP(url: PublicIPAPIURLs.IPv4.icanhazip.rawValue) { (string, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let string = string {
                print(string) // Your IP address
                IpEx = string
            }
        }
    }
    
    // Timer for 5 sec
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()   // ... 5 sec
    
    // paste for Clipboard
    private func copyToClipBoard(textToCopy: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(textToCopy, forType: .string)

    }
    
    init() {
        // public IP
        self.puIp() // non always good, but can
    }
        
    var body: some View {
        // public IP
        self.puIp()
        return
        
        VStack {
            Text("MAC")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Text(MAC)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .fixedSize()
                .onTapGesture {
                    self.copyToClipBoard(textToCopy: MAC)
                    print("copyToClipBoard")
                }
            Text("Private IP")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Text(prIp)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .fixedSize()
                .onTapGesture {
                    self.copyToClipBoard(textToCopy: prIp)
                    print("copyToClipBoard")
                }
            Text("Public IP")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Text(IpEx)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .fixedSize()
                .onTapGesture {
                    self.copyToClipBoard(textToCopy: IpEx)
                    print("copyToClipBoard")
                }
                .onReceive(timer) { input in            // here is the timer
                     currentDate = input
                    self.puIp()
                 }
        }
        .padding(100.0)
        .frame(width: 300, height: 180)
        .foregroundColor(yellow)
        .background(blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
