//this is custom text field, so I could stay consistent

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    //fields like passwords need to be secure to added a flag
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color(AppColours.customDarkGrey), lineWidth: 1)
        )
    }
}

