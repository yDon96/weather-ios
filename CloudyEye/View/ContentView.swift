//
//  ContentView.swift
//  CloudyEye
//
//  Created by Youssef Donadeo on 30/09/22.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                VStack() {
                    Image(systemName: "slider.vertical.3")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                    Text("Hello, world!")
                        .font(.title2)
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        VStack() {
                            Text("hour")
                                .font(.title2)
                            ZStack {
                                VisualEffectView(effect: UIBlurEffect(style: .dark)).edgesIgnoringSafeArea(.all)
                                    .clipShape(Capsule())
                                    .padding(5)
                                    
                                VStack() {
                                    Text("Weather")
                                        .font(.subheadline)
                                        .padding()
                                        
                                    Image(systemName: "slider.vertical.3")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .scaledToFit()
                                    Text("20~C")
                                        .font(.title3)
                                        .padding()
                                }
                                
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    VStack(){
                        Text("City")
                            .font(.title)
                            .padding(5)
                        Text("Date")
                            .font(.subheadline)
                            
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "slider.vertical.3")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
