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
        horarioClase.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        horarioClase.textColor = R.color.colorDiaSemanaNoSeleccionado()!
        horarioClase.backgroundColor = .clear
        
        // Seleccionados
        horarioClase.selectedFont = horarioClase.font
        horarioClase.selectedTextColor = R.color.colorDiaSemana()!
        horarioClase.selectedBackgroundColor = horarioClase.backgroundColor
        horarioClase.indicatorColor = R.color.indicadorDia()!
        
        // Varios
        horarioClase.menuItemSize = .selfSizing(estimatedWidth: 70, height: 50)
        horarioClase.menuItemSpacing = 0
        horarioClase.menuBackgroundColor = horarioClase.backgroundColor
        horarioClase.borderOptions = .hidden
        horarioClase.indicatorOptions = .hidden
        horarioClase.selectedScrollPosition = .left
        
        return horarioClase
    }()
}
