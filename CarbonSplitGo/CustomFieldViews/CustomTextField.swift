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
                //there was promt this whole time to make my life easier with these placeholders...
                SecureField(placeholder, text: $text,prompt: Text(placeholder).foregroundColor(AppColours.customMediumGreen))
                    .font(.custom("Sen", size: 17))
                    .foregroundColor(AppColours.customDarkGrey)
            } else {
                TextField(placeholder, text: $text,prompt: Text(placeholder).foregroundColor(AppColours.customMediumGreen))
                    .font(.custom("Sen", size: 17))
                    .foregroundColor(AppColours.customDarkGrey)
        }
        }
        .padding()
        .background(AppColours.customWhite.opacity(0.9))
        .cornerRadius(30)
        .foregroundColor(AppColours.customBlack)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
        )
    }
}

