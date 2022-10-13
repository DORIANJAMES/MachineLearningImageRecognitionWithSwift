//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by Alihan AÇIKGÖZ on 13.10.2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var chosenImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        if let ciImage = CIImage(image: imageView.image!) {
            self.chosenImage = ciImage
        }
        recognizeImage(image: chosenImage)
        
    }
    
    func recognizeImage (image:CIImage) {
        // 1) REQUEST
        // 2) HANDLER
        
        
        // Burada VNCoreMLModel oluştururken bize bir hata dönderecek bu hatalardan kaçınabilmek için öncekile bu fonksiyonu "try" yapısı içerisine sokup bir değişkene atamamız lazım. DO ile yapılan TRY'dan farklı olarak "if let" ile de bir TRY yapısı oluşturabiliyoruz. ardından VNCoreMLModel fonksiyonu bizden bir parametre isteyecek. developer.apple.com'da CoreML olarak arattırıp indirdiğimiz modeli bir sınıf gibi tanıtıp ardından ".model" olarak yazdığımzda, VNCoreMLModel'in istediği for parametresindeki atamayı yapmış oluyoruz. Bu opsiyonel bir return veriyor. Bundan dolayı da TRY'ın sonuna "?" soru işareti koyarak bu opsiyonellikten kaçınıyoruz.
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { vnRequest, error in
                
                // vnRequest sonrasında çağaracağımız ".resutls" bize birden fazla bir any? arrayi dönderecek. Bize maymun resmi koyduğumzda maymunda olabilir şempanze de gibi bir sonuç döndermesi anlamına geliyor. Bunu mantık çerçevesinde almak lazım ki bu da genel olarak ilk indisteki obje oluyor. Bu sonucu işleyebilmek için any? objesi değil "VNClassificationObservation" objesi olarak almamız gerekli. Bundan dolayı vnRequest.results'dan dönen bilgileri "[VNClassificationObservarion]" obje arrayi olarak cast etmemiz gerekmektedir. Bu da sınıflandırma gözlemi dizisini oluşturacak. Birinci indisi en yüksek olasılıklı sonucu verecek bizlere.
                if let results = vnRequest.results as? [VNClassificationObservation] {
                    // Burada bir for loop ile tüm sonuçları alarak bunlardan birisi diye kullanıcı tarafına da gösterimini sağlayabilirz ancak biz ilk sonucu alıp en yüksek sonuç o olduğu için gösterimini gerçekleştireceğiz.
                    if results.count > 0 {
                        let topResult = results.first
                    }
                }
            }
        }
        
    }
    
}

