//this is custom text field, so I could stay consistent

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    //fields like passwords need to be secure to added a flag
    var isSecure: Bool = false

    var body: some View {
        Group {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("Sen", size: 17))
                        .foregroundColor(AppColours.customMediumGreen)
                }
                
                if isSecure {
                    SecureField("", text: $text)
                        .font(.custom("Sen", size: 17))
                        .foregroundColor(AppColours.customDarkGrey)
                } else {
                    TextField("", text: $text)
                        .font(.custom("Sen", size: 17))
                        .foregroundColor(AppColours.customDarkGrey)
                }
            }
        }
        .padding()
        .background(Color(.white).opacity(0.9))
        .cornerRadius(30)
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
        )
    }
}

