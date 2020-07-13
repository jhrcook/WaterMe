//
//  VerticalTimeLine.swift
//  WaterMe
//
//  Created by Joshua on 7/13/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct TimeLinePoints: View {
    let allDates: [Date]
    let selectDates: [Bool]
    var paddingHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: paddingHeight) {
            ForEach(0..<allDates.count) { i in
                ZStack {
                    RoundedRectangle(cornerRadius: 2, style: .circular)
                        .frame(width: 5)
                        .foregroundColor(Color.blue)
                        .padding(EdgeInsets(top: -1 * self.paddingHeight, leading: 0, bottom: -1 * self.paddingHeight, trailing: 0))
                    if self.selectDates[i] {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color.blue)
                    }
                }.padding(.horizontal, 5)
            }
        }
    }
}


struct TimeLineDates: View {
    let allDates: [Date]
    let selectDates: [Bool]
    var paddingHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: paddingHeight) {
            ForEach(0..<allDates.count) { i in
                Text(self.formatDate(self.allDates[i])).opacity(self.selectDates[i] ? 1 : 0)
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


struct VerticalTimeLine: View {
    var dates: [Date]
    
    var allDates: [Date] {
        let startDate = dates.min()!
        let endDate = Date()
        var d = [startDate]
        while d.last! <= endDate {
            if let x = Calendar.current.date(byAdding: .day, value: 1, to: d.last!) {
                d.append(x)
            }
        }
        d.reverse()
        return d
    }
    
    var isInDates: [Bool] {
        var a = [Bool]()
        for d in allDates {
            a.append(dateIsInDates(d))
        }
        return a
    }
    
    let spacing: CGFloat = 5
    
    var body: some View {
        HStack {
            Spacer()
            TimeLinePoints(allDates: self.allDates, selectDates: self.isInDates, paddingHeight: self.spacing)
            TimeLineDates(allDates: self.allDates, selectDates: self.isInDates, paddingHeight: self.spacing)
            Spacer()
        }
    }
    
    func dateIsInDates(_ date: Date) -> Bool {
        for d in self.dates {
            if Calendar.current.isDate(d, inSameDayAs: date) {
                return true
            }
        }
        return false
    }
}


struct VerticalTimeLine_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VerticalTimeLine(dates: [
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -11, to: Date())!
            ])
        }.previewLayout(.sizeThatFits)
    }
}
