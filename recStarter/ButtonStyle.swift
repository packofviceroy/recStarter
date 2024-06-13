//
//  Created by dumbo on 6/13/24.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    let labelWidth:CGFloat
    let labelHeight:CGFloat
    let scaleFactor:CGFloat
    let minWidth:CGFloat
    let verticalPadding:CGFloat

    init(labelWidth: CGFloat, labelHeight: CGFloat, scaleFactor: CGFloat, minWidth: CGFloat = 0, verticalPadding: CGFloat = 0) {
        self.labelWidth = labelWidth
        self.labelHeight = labelHeight
        self.scaleFactor = scaleFactor
        self.minWidth = minWidth
        self.verticalPadding = verticalPadding

    }

    func makeBody(configuration: Configuration) -> some View {
        let darkBlue = Color(red: 0, green: 0, blue: 1)
        configuration.label
            .frame(width: labelWidth, height: labelHeight)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .font(Font.system(size: 80))
            .frame(minWidth: minWidth)
            .padding(.vertical, verticalPadding)
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
            .background(configuration.isPressed ? darkBlue : Color.white)
            .cornerRadius(labelHeight)
            
    }
}
