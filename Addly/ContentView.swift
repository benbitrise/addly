//
//  ContentView.swift
//  Addly
//
//  Created by Ben Boral on 7/26/21.
//

import SwiftUI

struct ContentView: View {
    let adder: Adder
    @ObservedObject var operand1 = NumbersOnly()
    @ObservedObject var operand2 = NumbersOnly()
    @State var status = AddingStatus.nothingToAdd

    var result: String {
        switch status {
        case .nothingToAdd:
            return "0"
        case .adding:
            return ""
        case .added(let newVal):
            return newVal
        case .error:
            return "error"
        }
    }

    var body: some View {
        Color.init(red: (249/256), green: (242/256), blue: (214/256)).ignoresSafeArea().overlay(
            VStack {
                Text("☞ add.ly")
                    .font(Font.custom("Menlo-Bold", size: 32))
                Spacer()
                if self.status == .adding {
                    LottieView()
                }
                TextField("Operand 1", text: $operand1.value.onChange(operandChanged))
                    .keyboardType(.decimalPad)
                    .font(Font.custom("Menlo", size: 18))
                    .accessibility(identifier: "operand1")
                Text("➕")
                    .font(Font.custom("Menlo-Bold", size: 23))
                    .padding()
                TextField("Operand 2", text: $operand2.value.onChange(operandChanged))
                    .keyboardType(.decimalPad)
                    .font(Font.custom("Menlo", size: 18))
                    .accessibility(identifier: "operand2")
                Text("=")
                    .font(Font.custom("Menlo-Bold", size: 23))
                    .padding()
                Text(result).font(Font.custom("Menlo-Bold", size: 23)).accessibility(identifier: "result")
            }
        )
    }

    func operandChanged(to value: String) {
        if self.status == .adding {
            self.status = .nothingToAdd
        }
        self.status = .adding
        adder.add(operand1: operand1, operand2: operand2) { newStatus in
            self.status = newStatus
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: {
                self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(adder: Adder(intervalMaker: RandomIntervalMaker()))
    }
}
