import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        GeometryReader{geometry in
            Image("SplashBackgroundImage")
                .resizable()
            .scaledToFill()
              
                .frame(width: geometry.size.width,height: geometry.size.height)
                .clipped()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview {
    BackgroundImage()
}

