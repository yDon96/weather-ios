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
    private var city = "MyCity"
    private var date = "01/01/22"
    
    private var hourInfo = [
        WeatherInfo(hour: "10:00", weatherType: "Sunny", imageName: "slider.vertical.3", temperature: "20~C"),
        WeatherInfo(hour: "10:00", weatherType: "Sunny", imageName: "slider.vertical.3", temperature: "20~C"),
        WeatherInfo(hour: "10:00", weatherType: "Sunny", imageName: "slider.vertical.3", temperature: "20~C"),
        WeatherInfo(hour: "10:00", weatherType: "Sunny", imageName: "slider.vertical.3", temperature: "20~C")
    ]
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
                        ForEach(hourInfo, id: \.self) { info in
                            CapsuleInfoView(
                                infoTag: info.hour,
                                infoTitle: info.weatherType,
                                infoContent: info.temperature,
                                infoImageName: info.imageName
                            )
                        }
                    }
                    .frame(maxHeight: 250)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    VStack(){
                        Text(city)
                            .font(.title)
                            .padding(5)
                        Text(date)
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
