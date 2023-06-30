/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraView: View {
    @Binding private var isCameraOpen: Bool
    @StateObject private var cameraViewModel: CameraViewModel = CameraViewModel()
    
    init(isCameraOpen: Binding<Bool>) {
        self._isCameraOpen = isCameraOpen
    }
 
    private static let barHeightFactor = 0.15
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image: $cameraViewModel.viewfinderImage )
                    .overlay(alignment: .top) {
//                        Color.black
//                            .opacity(0.75)
//                            .frame(height: geometry.size.height * Self.barHeightFactor)
                        Button(action: {
                            isCameraOpen = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task {
                await cameraViewModel.camera.start()
                await cameraViewModel.loadPhotos()
                await cameraViewModel.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: cameraViewModel.photoCollection)
                    .onAppear {
                        cameraViewModel.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        cameraViewModel.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: cameraViewModel.thumbnailImage)
                }
            }
            
            Button {
                cameraViewModel.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                cameraViewModel.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
