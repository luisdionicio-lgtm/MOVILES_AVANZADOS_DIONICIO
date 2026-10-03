//
//  ViewController.swift
//  LAB_05
//
//  Created by Luis DB on 16/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Introduce tu Peso y Altura"
    }

    @IBAction func CalcularResultado(_ sender: Any) {
        guard
            let weightText = weightTextField.text?.replacingOccurrences(of: ",", with: "."),
            let heightText = heightTextField.text?.replacingOccurrences(of: ",", with: "."),
            let weight = Double(weightText),
            let height = Double(heightText),
            weight > 0,
            height > 0
        else {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let bmi = weight / (height * height)
        let status: String

        if bmi < 18.5 {
            status = "Bajo peso"
        } else if bmi < 24.9 {
            status = "Peso normal"
        } else if bmi < 29.9 {
            status = "Sobrepeso"
        } else {
            status = "Obesidad"
        }

        resultLabel.text = "IMC: \(String(format: "%.2f", bmi)) - \(status)"
        view.endEditing(true)
    }
}
