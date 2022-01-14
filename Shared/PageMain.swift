//
//  PageMain.swift
//  stepcounter
//
//  Created by Ceren TAŞSIN on 9.01.2022.
//

import SwiftUI
import HealthKit

struct PageMain: View {
    
    var healthkitStore = HKHealthStore()
    let backgroundColor = Color("ColorBackground")
    let labelColor = Color("ColorLabel")
    let buttonColor = Color("ColorButton")
    @State var stepCountList = [StepList]()
    
    @State var pedometer : Int = 0
    @State var userName: String
    
    ///Bugünki adım sayısını getir methodu
    func getStepCountToday(){
        self.getStepsCount(forSpecificDate: Date()) { (steps) in
            if steps == 0.0 {
                self.pedometer = Int(steps)
                debugPrint("STEP -> \(steps)")
            }
            else {
                self.pedometer = Int(steps)
                debugPrint("STEP -> \(steps)")
            }
        }
    }
    
    ///Son 7 Günün Adım Sayısını Oku
    func getStepCountGetDateList() -> Void{
        let now = Date() // Current date
        var dateComponents = DateComponents()
        
        var stepList = [StepList]()
        for i in 1...6 {
            
            ///Önceki günlere ait tarihleri hesaplar
            switch i {
            case 1:
                ///Dün
                dateComponents.setValue(-1, for: .day)
            case 2:
                dateComponents.setValue(-2, for: .day)
            case 3:
                dateComponents.setValue(-3, for: .day)
            case 4:
                dateComponents.setValue(-4, for: .day)
            case 5:
                dateComponents.setValue(-5, for: .day)
            case 6:
                dateComponents.setValue(-6, for: .day)
            default:
                dateComponents.setValue(-1, for: .day)
            }
            
            let calculateDate = Calendar.current.date(byAdding: dateComponents, to: now)
            
            self.getStepsCount(forSpecificDate: calculateDate!) { (steps) in
                
                if steps == 0.0 {
                    ///Listeye eklenecek değerler. Tarih ve Adım Sayısı
                    let dateformat = DateFormatter()
                    dateformat.dateFormat = "dd-MM-yyyy"
                    let dateFormattingUseDate = dateformat.string(from: calculateDate! as Date)
                    
                    var listItem = StepList(userDate: dateFormattingUseDate, userStep: Int(steps))
                    
                    ///Listeye ekle
                    stepList.append(listItem)
                }else{
                    ///Listeye eklenecek değerler. Tarih ve Adım Sayısı
                    let dateformat = DateFormatter()
                    dateformat.dateFormat = "dd-MM-yyyy"
                    let dateFormattingUseDate = dateformat.string(from: calculateDate! as Date)
                    
                    var listItem = StepList(userDate: dateFormattingUseDate, userStep: Int(steps))
                    
                    ///Listeye ekle
                    stepList.append(listItem)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.stepCountList = stepList
            debugPrint("STEP stepList -> \(stepList)")
            debugPrint("STEP stepCountList -> \(self.stepCountList)")
        }
        
    }
    
    func getDateFrom(dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        guard let date = dateFormatter.date(from: dateString) else {return nil}
        return date
    }
    
    ///Adım Sayısını Okur
    func getStepsCount(forSpecificDate:Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = self.getWholeDate(date: forSpecificDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        self.healthkitStore.execute(query)
    }
    
    ///Tarih işlemlerini yapar.
    func getWholeDate(date : Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
    
    var body: some View {
        VStack(alignment: .center){
            
            VStack(alignment: .leading){
                
                //Kullanıcı Adı
                Text("Merhaba!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.custom("Poppins-Bold", size: 20))
                    .foregroundColor(labelColor)
                
                //Kullanıcı Adı
                Text("\(userName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.custom("Poppins-Medium", size: 18))
                    .foregroundColor(labelColor)
            }.padding()
            
            
            VStack{
                ViewCircleGraph(prg_StepCount: Double(self.pedometer))
            }.padding()
            
            
            ZStack{
                List {
                    ForEach(stepCountList) { section in
                        VStack{
                            HStack{
                                VStack(alignment: .leading) {
                                    Text("\(section.userDate)")
                                        .font(Font.custom("Poppins-Medium", size: 14))
                                        .foregroundColor(labelColor)
                                }
                                
                                VStack(alignment: .trailing) {
                                    Text("\(section.userStep) Adım")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .font(Font.custom("Poppins-Medium", size: 14))
                                        .foregroundColor(labelColor)
                                }
                            }
                        }.padding()
                    }
                }.opacity(0.8)
            }
            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.50)
            .onAppear(perform: getStepCountToday)
            .onAppear(perform: getStepCountGetDateList)
            
        }
        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1)
        .background(backgroundColor)
        .ignoresSafeArea()
        
    }
}

struct PageMain_Previews: PreviewProvider {
    static var previews: some View {
        PageMain(userName: "-")
    }
}
