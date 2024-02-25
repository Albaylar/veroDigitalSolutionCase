//
//  ColorPicker.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 25.02.2024.
//

import Foundation

import UIKit

class ColorPickerController: UIViewController {
    
    // "Filter By Color" düğmesine basıldığında çağrılacak işlev
    @objc func filterByColorButtonTapped() {
        // Renk seçme arayüzünü başlat
        showColorPicker()
    }
    
    // Renk seçme arayüzünü gösteren işlev
    func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
}

// UIColorPickerViewControllerDelegate protokolüne uyum sağlamak için uzantı
extension ColorPickerController: UIColorPickerViewControllerDelegate {
    
    // Renk seçme işlemi tamamlandığında çağrılır
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // Seçilen rengi al
        let selectedColor = viewController.selectedColor
        // İçeriği seçilen renge göre filtrele
        //filterByColor(selectedColor: selectedColor)
        // Renk seçme arayüzünü kapat
        dismiss(animated: true, completion: nil)
    }
    
    // Renk seçme işlemi iptal edildiğinde çağrılır
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // İptal edildiğinde herhangi bir şey yapmayabiliriz, ancak gerekirse bu fonksiyonu kullanabiliriz.
    }
    
}
