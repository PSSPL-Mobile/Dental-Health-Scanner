

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = DentalHealthScannerModel()
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var navigateToResult = false
    @State private var showCameraNotAvailableAlert = false
    @State private var showNoTeethImageAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    VStack(alignment: .center, spacing: 10) {
                        Text(AppConstants.dentalHealthScannerTitle)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(AppConstants.instruction)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    ImagePreview(image: selectedImage)
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 16) {
                            Button(action: {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    showCamera = true
                                } else {
                                    showCameraNotAvailableAlert = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: SystemImage.camera.rawValue)
                                    Text(AppConstants.camera)
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Button(action: { showPhotoPicker = true }) {
                                HStack {
                                    Image(systemName: SystemImage.gallery.rawValue)
                                    Text(AppConstants.gallery)
                                        .font(.headline)
                                }
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            }
                        }
                        .navigationDestination(isPresented: $navigateToResult) {
                            ResultScreen(viewModel: viewModel)
                        }
                        
                        Button(action: {
                            viewModel.analyzeImage(selectedImage) {
                                if viewModel.errorMessage != nil {
                                    showNoTeethImageAlert = true
                                } else {
                                    navigateToResult = true
                                }
                            }
                        }) {
                            HStack {
                                Text(AppConstants.proceedToAnalysis)
                                    .font(.headline)
                                Image(systemName: SystemImage.rightArrow.rawValue)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .opacity(selectedImage == nil ? 0.4 : 1.0)
                            .allowsHitTesting(selectedImage != nil)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                if viewModel.inProgress {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.blue.opacity(0.4)))
                                .padding()
                                .scaleEffect(2)
                        )
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(capturedImage: $selectedImage)
            }
            .alert(AppConstants.dentalHealthScannerTitle, isPresented: $showCameraNotAvailableAlert) {
                Button(AppConstants.ok, role: .cancel) {}
            } message: {
                Text(AppConstants.cameraNotSupportMsg)
            }
            .alert(AppConstants.dentalHealthScannerTitle, isPresented: $showNoTeethImageAlert) {
                Button(AppConstants.ok, role: .cancel) {}
            } message: {
                Text(AppConstants.noTeethImageMsg)
            }
            .onDisappear() {
                selectedImage = nil
            }
        }
    }
}

struct ImagePreview: View {
    let image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(icons.logo.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            
                            Text(AppConstants.noPhotoSelected)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(10)
                    )
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

