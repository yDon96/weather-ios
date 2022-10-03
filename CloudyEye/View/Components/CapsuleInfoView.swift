//
//  CapsuleInfoView.swift
//  CloudyEye
//
//  Created by Youssef Donadeo on 03/10/22.
//

import SwiftUI

struct CapsuleInfoView: View {
    var infoTag : String
    var infoTitle : String
    var infoContent : String
    var infoImageName: String

    var body: some View {
        VStack() {
            Text(infoTag)
                .font(.title2)
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .dark)).edgesIgnoringSafeArea(.all)
                    .clipShape(Capsule())
                    .padding(5)
                    
                VStack() {
                    Text(infoTitle)
                        .font(.subheadline)
                        .padding()
                        
                    Image(systemName: infoImageName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                    Text(infoContent)
                        .font(.title3)
                        .padding()
                }
                
            }
        }
    }
}

struct CapsuleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleInfoView(infoTag: "hour", infoTitle: "Weather", infoContent: "20~C", infoImageName: "slider.vertical.3")
    }
}
