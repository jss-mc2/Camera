//
//  CameraApp.swift
//  Camera
//
//  Created by Jason Rich Darmawan Onggo Putra on 30/06/23.
//

import SwiftUI

struct ButtonHighlight: View {
    let onAction: () -> Void
    let label: String
    
    init(action: @escaping () -> Void, label: String) {
        self.onAction = action
        self.label = label
    }
    
    var body: some View {
        let cornerRadius = CGFloat(10)
        
        Button(
            action: {
                onAction()
            },
            label: {
                Text(label)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.blue, lineWidth: 2)
                        
                    }
            }
        )
    }
}

@main
struct CameraApp: App {
    @State var isCameraOpen = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("In-app will ask permissions for Camera and Photo Library access")
                ButtonHighlight(
                    action: { isCameraOpen = true },
                    label: "Open Camera in-app"
                )
                
                /**
                 - ToDo:
                    - error: "This app is not allowed to query for scheme com.apple.camera"
                 */
                Text("error: \"This app is not allowed to query for scheme com.apple.camera\"")
                ButtonHighlight(
                    action: {
                        if let url = URL(string: "com.apple.camera://") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    },
                    label: "Open the Camera app"
                )
                
                /**
                 - ToDo:
                    - [it's not a public URL scheme and may cause rejection from App Store](https://stackoverflow.com/questions/10547214/is-it-possible-to-launch-redirect-the-user-to-the-native-photo-gallery-applica)
                 */
                Text("it's not a public URL scheme and may cause rejection from App Store")
                ButtonHighlight(
                    action: {
                        if let url = URL(string: "photos-redirect://") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    },
                    label: "Open the Photos app (not a public URL scheme and may cause rejection from App Store)"
                )
            }.sheet(isPresented: $isCameraOpen) {
                CameraView(isCameraOpen: $isCameraOpen)
            }
        }
    }
}
