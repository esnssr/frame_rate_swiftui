//
//  frame_rate_ahhhhh.swift
//  Beep_Boop
//
//  Created by Eslam Nasser on 2024-11-04.
//

import SwiftUI

struct frame_rate_ahhhhh: View {

    @State var offSet: CGFloat = .zero

    @State var toggleSwiftUI = false
    @State var toggleUIKit = false

    var body: some View {
        VStack(spacing: 50) {
            Button("Toggle SwiftUI") {
                toggleSwiftUI.toggle()
            }

            Button("Toggle UIKit") {
                toggleUIKit.toggle()
            }

            Button("Toggle Both") {
                toggleUIKit.toggle()
                toggleSwiftUI.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.red)
                .frame(width: 200, height: 200)
                .offset(y: offSet)
        }
        .overlay(alignment: .bottomLeading) {
            // cheap and quick way to get a UIKit in SwiftUI
            UIKit_Sheet(show: $toggleUIKit) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.green)
                    .frame(width: 200, height: 200)
                    .offset(y: offSet)
            }
            // disable interactions for the wrapper view.
            .allowsHitTesting(false)
        }
        .onChange(of: toggleSwiftUI, initial: true) { _, newValue in
            // move the SwiftUI view. same spring animation as in UIKit view.
            withAnimation(.spring(duration: 1)) {
                if toggleSwiftUI {
                    offSet = -500
                } else {
                    offSet = .zero
                }
            }
        }
    }
}

#Preview {
    frame_rate_ahhhhh()
}

struct UIKit_Sheet<Content: View>: UIViewRepresentable {

    typealias UIViewType = UIView

    let containerView = UIView(frame: .zero)

    @Binding var show: Bool

    @ViewBuilder let content: () -> Content

    func makeUIView(context: Context) -> UIView {
        // ❗ please ignore the ugly code here. it was written in
        //  a moment of despair and a lot of anger :)

        let window = UIApplication.shared.window

        let hosting = UIHostingController(rootView: content())
        hosting.view.backgroundColor = .clear

        containerView.addSubview(hosting.view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        window?.addSubview(containerView)
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let height = hosting.view.intrinsicContentSize.height
        // used the height in one of the prototypes, ignore it.
        context.coordinator.height = height
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: window!.leadingAnchor)
        ])
        let layout = containerView.bottomAnchor.constraint(equalTo: window!.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        layout.isActive = true

        // quick way to just move the view with the constraint.
        context.coordinator.sheetLayout = layout

        return UIView(frame: .zero)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        debugPrint("beep boop 🤖: should update \(show)")

        // animate based on the binding value
        if show {
            // present will move the way up, dismiss will move the view down
            context.coordinator.present()
        } else {
            context.coordinator.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}


extension UIKit_Sheet{
    class Coordinator: NSObject {

        var height: CGFloat?
        var sheetLayout: NSLayoutConstraint!

        func present() {
            debugPrint("beep boop 🤖: present")
            UIView.animate(springDuration: 1) {
                self.sheetLayout.constant = -500
                // i know it's crazy to call this on the window but i am just trying to
                // get this UIKit working 😔
                UIApplication.shared.window?.layoutIfNeeded()
            }
        }

        func dismiss() {
            debugPrint("beep boop 🤖: dismiss")
            UIView.animate(springDuration: 1) {
                self.sheetLayout.constant = 0
                UIApplication.shared.window?.layoutIfNeeded()
            }
        }
    }
}

extension UIApplication {
    var window: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first
    }
}

