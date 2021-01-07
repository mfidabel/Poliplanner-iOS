//
//  PagingOptions+HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-10.
//

import Foundation
import Parchment

extension PagingOptions {
    // MARK: - Opciones
    
    /// Configuración de paginación del horario de clases
    static let horarioClase: PagingOptions = {
        var horarioClase = PagingOptions()
        // No seleccionados
        horarioClase.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        horarioClase.textColor = .gray
        horarioClase.backgroundColor = .clear
        
        // Seleccionados
        horarioClase.selectedFont = horarioClase.font
        horarioClase.selectedTextColor = .label
        horarioClase.selectedBackgroundColor = horarioClase.backgroundColor
        
        // Varios
        horarioClase.menuItemSize = .selfSizing(estimatedWidth: 80, height: 50)
        horarioClase.menuItemSpacing = 5
        horarioClase.menuBackgroundColor = horarioClase.backgroundColor
        horarioClase.borderOptions = .hidden
        horarioClase.indicatorOptions = .hidden
        horarioClase.selectedScrollPosition = .left
        
        return horarioClase
    }()
}
