//
//  ContentView.swift
//  Shared
//
//  Created by Ceren TAŞSIN on 9.01.2022.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    var healthkitStore = HKHealthStore()
    let backgroundColor = Color("ColorBackground")
    let labelColor = Color("ColorLabel")
    let buttonColor = Color("ColorButton")
    
    @State private var txt_userName = ""
    @State private var txt_password = ""
    
    @State private var showingPageMain = false
    
    ///HealthKit İzni
        func getHealthKitPermission() {
            // delay(0.1) {
            guard HKHealthStore.isHealthDataAvailable() else {
                return
            }
            
            let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
            
            self.healthkitStore.requestAuthorization(toShare: [], read: [stepsCount]) { (success, error) in
                if success {
                    print("Permission accept.")
                }
                else {
                    if error != nil {
                        print(error ?? "")
                    }
                    print("Permission denied.")
                }
            }
        }
    
    var body: some View {
        NavigationView{
            VStack{
                
                VStack(alignment: .leading, spacing: 3){
                    //Kullanıcı Adı
                    Text("Kullanıcı Adı")
                        .font(Font.custom("Roboto-Regular", size: 16))
                        .foregroundColor(labelColor)
                    
                    //cmlcrn17
                    TextField("Ceren", text: self.$txt_userName)
                        .font(Font.custom("Poppins-Bold", size: 20).bold())
                        .frame(width: nil, height: 30)
                        .foregroundColor(labelColor)
                    
                    Divider()
                        .frame(width: 350, height: 2)
                        .background(labelColor)
                    
                    
                }.padding(.leading)
                    .padding(.bottom)
                
                
                VStack(alignment: .leading, spacing: 3){
                    //Parola
                    Text("Parola")
                        .font(Font.custom("Roboto-Regular", size: 16))
                        .foregroundColor(labelColor)
                    
                    //******
                    SecureField("******", text: self.$txt_password)
                        .font(Font.custom("Poppins-Bold", size: 20).bold())
                        .frame(width: nil, height: 30)
                        .foregroundColor(labelColor)
                    
                    Divider()
                        .frame(width: 350, height: 2)
                        .background(labelColor)
                    
                }.padding(.leading)
                
                ZStack {
                    //Rectangle 1
                    RoundedRectangle(cornerRadius: 20)
                        .fill(buttonColor)
                        .frame(width: 354, height: 50)
                    
                    //Oturum Aç
                    Button(action: {
                        self.showingPageMain = true
                    }){
                        Text("Oturum Aç")
                            .font(Font.custom("Poppins-Bold", size: 18).bold())
                            .foregroundColor(labelColor)
                            .multilineTextAlignment(.center)
                    }
                    
                    NavigationLink(destination: PageMain(userName: self.txt_userName), isActive: self.$showingPageMain)
                    {
                        Text("")
                    }.isDetailLink(false)
                        .navigationBarTitle("")
                    
                }.padding()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .ignoresSafeArea()
        }.accentColor(labelColor)
            .onAppear(perform: getHealthKitPermission)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
