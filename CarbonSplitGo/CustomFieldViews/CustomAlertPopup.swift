import SwiftUI

struct CustomAlertPopup {
    
    struct SwiftUIAlert {
        @Binding var isPresented: Bool
        var title: String
        var message: String
        
        func alert() -> Alert {
            Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("")) {
                    isPresented = false
                }
            )
        }
    }
}
