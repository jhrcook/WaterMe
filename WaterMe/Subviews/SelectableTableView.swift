//
//  SelectableTableView.swift
//  WaterMe
//
//  Created by Joshua on 7/16/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


class SelectableCellData: ObservableObject, Identifiable {
    let id = UUID()
    let date: Date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self.date)
    }
    @Published var isSelected: Bool = false
    
    init(date: Date) {
        self.date = date
    }
}

class SelectableData: ObservableObject {
    @Published var data = [SelectableCellData]()
    
    init(dates: [Date]) {
        var x = [SelectableCellData]()
        for date in dates {
            x.append(SelectableCellData(date: date))
        }
        self.data = x
    }
    
    init() {
        
    }
}


struct SelectableCell: View {
    
    @ObservedObject var cellData: SelectableCellData
    
    var body: some View {
        HStack {
            Button(action: {
                self.cellData.isSelected.toggle()
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 15))
                    .foregroundColor(cellData.isSelected ? .white : .blue)
                    .padding(10)
                    .background(
                        Circle()
                            .foregroundColor(cellData.isSelected ? .blue : .clear)
                            .background(Circle().stroke(Color.blue, style: StrokeStyle(lineWidth: 1.5)))
                    )
            }
            
            Text(cellData.formattedDate)
            
            Spacer()
        }
    }
}


struct SelectableTableView: View {
    
    @ObservedObject var selectableData: SelectableData
    
    var deleteAction: () -> Void
    var doneAction: () -> Void
    
    var body: some View {
        VStack {
                ForEach(selectableData.data) { dataPoint in
                        SelectableCell(cellData: dataPoint)
                            .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                }
            
            HStack {
                Spacer()
                
                Button(action: deleteAction) {
                    HStack {
                        Text("Delete")
                    }
                    .foregroundColor(Color.red)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 2))
                )
                
                Spacer()
                
                Button(action: {
                    self.doneAction()
                    for dataPoint in self.selectableData.data {
                        dataPoint.isSelected = false
                    }
                }) {
                    Text("Done")
                        .foregroundColor(Color.gray)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 2))
                )
                
                Spacer()
            }
            .padding(.top, 12)
        }
    }
}





struct SelectableTableView_Previews: PreviewProvider {
    static var previews: some View {
        SelectableTableView(selectableData: SelectableData(dates: [
            Date(),
            Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        ]), deleteAction: {}, doneAction: {} )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
