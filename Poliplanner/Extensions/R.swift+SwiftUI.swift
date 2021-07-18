//
//  R.swift+SwiftUI.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-14.
//

import Rswift
import SwiftUI

extension FontResource {
    // MARK: SwiftUI
    
    /// Convierte la fuente en una fuente de SwiftUI
    func font(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}

extension ColorResource {
    // MARK: SwiftUI
    
    /// Convierte el color en un color de SwiftUI
    var color: Color {
        Color(name)
    }
}

extension StringResource {
    // MARK: SwiftUI
    
    /// Obtiene el `LocalizedStringKey` de la cadena
    var localizedStringKey: LocalizedStringKey {
        LocalizedStringKey(key)
    }

    /// Obtiene el texto localizado de la cadena
    var text: Text {
        Text(localizedStringKey)
    }
}

extension ImageResource {
    // MARK: SwiftUI
    
    /// Convierte la imagen en una imagen de SwiftUI
    var image: Image {
        Image(name)
    }
}
