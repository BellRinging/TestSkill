import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct CheckboxAtFrontToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
            .resizable()
            .frame(width: 22, height: 22)
            .onTapGesture { configuration.isOn.toggle() }
            configuration.label
            Spacer()
        }
    }
}

struct CheckboxAtFrontToggleStyle2: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
            .resizable()
            .frame(width: 22, height: 22)
            .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}



//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//public protocol ToggleStyle {
//    associatedtype Body : View
//
//    func makeBody(configuration: Self.Configuration) -> Self.Body
//
//    typealias Configuration = ToggleStyleConfiguration
//}
