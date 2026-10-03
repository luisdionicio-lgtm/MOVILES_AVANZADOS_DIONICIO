//
//  ViewController.swift
//  LAB_05
//
//  Created by Luis DB on 16/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var annualRateTextField: UITextField!
    @IBOutlet weak var termYearsTextField: UITextField!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyPaymentLabel.text = "Ingresa los datos del préstamo"
        totalPaymentLabel.text = ""
    }

    @IBAction func calcularPrestamo(_ sender: Any) {
        guard
            let capitalText = capitalTextField.text?.replacingOccurrences(of: ",", with: "."),
            let rateText = annualRateTextField.text?.replacingOccurrences(of: ",", with: "."),
            let yearsText = termYearsTextField.text?.replacingOccurrences(of: ",", with: "."),
            let capital = Double(capitalText),
            let annualRate = Double(rateText),
            let years = Double(yearsText),
            capital > 0,
            annualRate >= 0,
            years > 0
        else {
            monthlyPaymentLabel.text = "Ingresa valores válidos."
            totalPaymentLabel.text = ""
            return
        }

        let numberOfPayments = years * 12
        let monthlyRate = annualRate / 100 / 12
        let monthlyPayment: Double

        if monthlyRate == 0 {
            monthlyPayment = capital / numberOfPayments
        } else {
            let factor = pow(1 + monthlyRate, numberOfPayments)
            monthlyPayment = capital * (monthlyRate * factor) / (factor - 1)
        }

        let totalPayment = monthlyPayment * numberOfPayments
        monthlyPaymentLabel.text = String(format: "Cuota mensual: S/ %.2f", monthlyPayment)
        totalPaymentLabel.text = String(format: "Monto total: S/ %.2f", totalPayment)
        view.endEditing(true)
    }
}
