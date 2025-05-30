//
//  LottieAnimation.swift
//  Lingvistik
//
//  Created by Екатерина Яцкевич on 19.02.25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) ->  UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: filename)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}

#Preview {
    LottieView(filename: "LogoAnimation")
}
