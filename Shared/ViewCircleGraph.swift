//
//  ViewCircleGraph.swift
//  stepcounter
//
//  Created by Ceren TAŞSIN on 9.01.2022.
//

import SwiftUI

#if DEBUG
struct ViewCircleGraph_Previews: PreviewProvider {
    static var previews: some View {
        ViewCircleGraph(prg_StepCount: 7500)
    }
}
#endif

struct ViewCircleGraph: View {
    var prg_StepCount: Double
    let labelColor = Color("ColorLabel")
    let labelCircle = Color("ColorCircle")
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12.0)  //Circle genişlik ayarı
                .foregroundColor(labelCircle)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(Double((prg_StepCount)) , 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(labelCircle)
                .rotationEffect(Angle(degrees: 270))
               
            //Circle Text Alanı
            VStack{
                Text("\(String(format: "%.0f", self.prg_StepCount)) Adım")
                    .font(Font.custom("Poppins-Bold", size: 20))
                    .foregroundColor(labelColor)
                
            }
            
            //Ekrandaki Kullanım Alanları
        }.frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.20)
    }
}

