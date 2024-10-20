Dynamic Form Generator
======================

Dinamik formlar oluşturmak için kullanabileceğiniz esnek ve kullanımı kolay bir Flutter paketi. Bu paket sayesinde form alanlarını kısa veya detaylı tanımlamalarla belirtebilir, stil özelleştirmeleri yapabilir ve form alanlarını istediğiniz gibi düzenleyebilirsiniz.

Özellikler
----------

*   **Esnek Alan Tanımlamaları:** Kısa veya uzun tanımlamalarla form alanları oluşturabilirsiniz.
*   **Stil Özelleştirmeleri:** Global veya alan bazlı stil uygulayabilirsiniz.
*   **Alanları Yan Yana Yerleştirme:** Form alanlarını gruplandırarak yan yana yerleştirebilirsiniz.
*   **Desteklenen Alan Tipleri:** Metin, e-posta, şifre, sayı, onay kutusu ve açılır liste alanları.
*   **Doğrulama Mekanizması:** Zorunlu alanlar ve basit doğrulama kuralları ile kullanıcı girdilerini kontrol edebilirsiniz.
*   **Kullanım Kolaylığı:** Widget içinde doğrudan form alanlarını tanımlayarak hızlıca formlar oluşturabilirsiniz.

* * *

Kurulum
-------

`pubspec.yaml` dosyanıza aşağıdaki satırı ekleyin:

    
    dependencies:
      dynamic_form_generator:
        git:
          url: https://github.com/kullaniciadi/dynamic_form_generator.git
        

Ardından terminalde aşağıdaki komutu çalıştırın:

    
    flutter pub get
        

* * *

Kullanım
--------

    
    import 'package:flutter/material.dart';
    import 'package:dynamic_form_generator/dynamic_form_generator.dart';
    
    void main() {
      runApp(MyApp());
    }
    
    class MyApp extends StatelessWidget {
      // Form alanlarını tanımlıyoruz
      final List<dynamic> formFields = [
        [
          't:Adınız?required&hint=Adınızı girin&style={"color":"#0000FF"}',
          't:Soyadınız?required&hint=Soyadınızı girin&style={"color":"#008000"}',
        ],
        'e:Email?required',
        'p:Şifre?required',
        'n:Yaş?hint=18',
        'd:Cinsiyet=Erkek,Kadın,Diğer?required',
        'c:Kullanım koşullarını kabul ediyorum?required',
      ];
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Dinamik Form Örneği',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Dinamik Form Örneği'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: DynamicFormGenerator(
                fields: formFields,
                onSubmit: (formData) {
                  // Form gönderildiğinde yapılacak işlemler
                  print('Form Verileri: \$formData');
                },
                fieldDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      }
    }
        

* * *

Form Verilerine Erişim
----------------------

`DynamicFormGenerator` widget'ının **onSubmit** callback fonksiyonu aracılığıyla form verilerine kolayca erişebilirsiniz. Form başarıyla doğrulandıktan ve gönderildikten sonra bu fonksiyon çağrılır ve form alanlarının değerlerini içeren bir `Map<String, dynamic>` parametresi alır.

### Örnek:

    
    onSubmit: (formData) {
      String adiniz = formData['Adınız'];
      String email = formData['Email'];
      String sifre = formData['Şifre'];
      // Form verilerini kullanarak işlemler yapabilirsiniz
    },
    

### Açıklamalar:

*   **formData:** Form alanlarının isimlerini (label) anahtar olarak kullanan ve kullanıcıdan alınan değerleri içeren bir harita (`Map<String, dynamic>`) yapısıdır.
*   **Alan Değerlerine Erişim:** Örneğin, `'Adınız'` alanının değerine `formData['Adınız']` ile erişebilirsiniz.

Alan Tanımlamaları
------------------

Form alanlarını tanımlamak için aşağıdaki söz dizimini kullanabilirsiniz:

    
    alanTipi:Label[=Seçenekler][?Özellikler]
        

### Desteklenen Alan Tipleri

- **`t`** (**text**): Metin girişi
- **`e`** (**email**): E-posta girişi
- **`p`** (**password**): Şifre girişi
- **`n`** (**number**): Sayısal girdi
- **`c`** (**checkbox**): Onay kutusu
- **`d`** (**dropdown**): Açılır liste


Açılır liste

### Özellikler

*   `required`: Alanı zorunlu yapar.
*   `hint=Değer`: Alanın placeholder değerini belirler.
*   `style={"özellik":"değer"}`: Alanın yazı stilini belirler (örneğin, renk, font boyutu).
*   `decoration={"özellik":"değer"}`: Alanın dekorasyonunu belirler (örneğin, doldurma rengi, border).

**Örnekler:**

*   `'t:Adınız?required&hint=Lütfen adınızı girin'`
*   `'e:Email?required'`
*   `'p:Şifre?required'`
*   `'n:Yaş?hint=18'`
*   `'d:Cinsiyet=Erkek,Kadın,Diğer?required'`
*   `'c:Kullanım koşullarını kabul ediyorum?required'`

* * *

Alanları Yan Yana Yerleştirme
-----------------------------

Form alanlarını yan yana yerleştirmek için alanları iç içe liste içinde tanımlayabilirsiniz:

    
    final List<dynamic> formFields = [
      [
        't:Adınız',
        't:Soyadınız',
      ],
      'e:Email',
      // Diğer alanlar
    ];
        

Bu yapı sayesinde `Adınız` ve `Soyadınız` alanları yan yana görüntülenecektir.

* * *

Stil Özelleştirmeleri
---------------------

### Global Stil

`DynamicFormGenerator` widget'ına `fieldDecoration` ve `textStyle` parametreleri ekleyerek tüm alanlara uygulanacak genel stil belirleyebilirsiniz.

**Örnek:**

    
    DynamicFormGenerator(
      fields: formFields,
      onSubmit: (formData) {
        // İşlemler
      },
      fieldDecoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(),
      ),
      textStyle: TextStyle(fontSize: 16),
    )
        

### Alan Bazlı Stil

Her bir form alanı için özel stil belirtebilirsiniz. Bunun için alan tanımında `style` ve `decoration` parametrelerini kullanabilirsiniz.

**Örnek:**

    
    't:Adınız?style={"color":"blue","fontSize":18}'
        

**Desteklenen Stil Özellikleri:**

*   **color**: Renk değeri (isim veya hex kodu)
*   **fontSize**: Yazı boyutu
*   **fontWeight**: Yazı kalınlığı (`"bold"` veya `"normal"`)
*   **fontStyle**: Yazı stili (`"italic"` veya `"normal"`)

**Renk Değerleri:**

*   Renk isimleri: `red`, `blue`, `green`, `black`, `white`, `grey`
*   Hex kodları: `#FF5733`, `#008000` vb.

* * *

Doğrulama Mekanizması
---------------------

Form alanlarını zorunlu yapmak ve basit doğrulama kuralları eklemek için `required` özelliğini kullanabilirsiniz.

**Örnek:**

    
    'e:Email?required'
        

E-posta alanı için basit bir doğrulama yapılır ve `@` karakterinin varlığı kontrol edilir.

* * *

Örnek Tam Form Tanımı
---------------------

    
    final List<dynamic> formFields = [
      [
        't:Adınız?required&hint=Adınızı girin&style={"color":"#0000FF"}',
        't:Soyadınız?required&hint=Soyadınızı girin&style={"color":"#008000"}',
      ],
      'e:Email?required',
      'p:Şifre?required',
      'n:Yaş?hint=18',
      'd:Cinsiyet=Erkek,Kadın,Diğer?required',
      'c:Kullanım koşullarını kabul ediyorum?required',
    ];
        

* * *

Paket Geliştirme ve Test Etme
-----------------------------

1.  **Paket Klasörüne Gidin:**
    
        
        cd dynamic_form_generator
                    
    
2.  **Bağımlılıkları Yükleyin:**
    
        
        flutter pub get
                    
    
3.  **Örnek Uygulamayı Çalıştırın:**
    
        
        cd example
        flutter run
                    
    

* * *

Katkıda Bulunma
---------------

Eğer bu pakete katkıda bulunmak isterseniz, GitHub üzerinden pull request gönderebilirsiniz. Yeni özellikler, hata düzeltmeleri ve önerileriniz için teşekkür ederiz.

* * *

Lisans
------

Bu proje [MIT Lisansı](LICENSE) ile lisanslanmıştır.

* * *

İletişim
--------

Herhangi bir sorunuz veya öneriniz varsa, lütfen [GitHub Issues](https://github.com/kullaniciadi/dynamic_form_generator/issues) üzerinden bizimle iletişime geçin.

* * *

Teşekkürler
-----------

Bu paketi kullanmayı tercih ettiğiniz için teşekkür ederiz! Umarız projenizde size yardımcı olur.

* * *

Sıkça Sorulan Sorular (SSS)
===========================

### 1\. **Desteklenen alan tipleri nelerdir?**

Metin (`t` veya `text`), E-posta (`e` veya `email`), Şifre (`p` veya `password`), Sayı (`n` veya `number`), Onay Kutusu (`c` veya `checkbox`), Açılır Liste (`d` veya `dropdown`)

### 2\. **Form alanlarını nasıl yan yana yerleştirebilirim?**

Form alanlarını yan yana yerleştirmek için alanları iç içe liste içinde tanımlayabilirsiniz. Örneğin:

    
    [
      [
        't:Adınız',
        't:Soyadınız',
      ],
      'e:Email',
    ]
        

### 3\. **Stil özelleştirmelerini nasıl yapabilirim?**

**Global Stil:** `DynamicFormGenerator` widget'ına `fieldDecoration` ve `textStyle` parametreleri ekleyerek tüm alanlara uygulanacak genel stili belirleyebilirsiniz.

**Alan Bazlı Stil:** Alan tanımlarında `style` ve `decoration` parametreleri ile özel stil belirtebilirsiniz.

### 4\. **Özel doğrulama kuralları ekleyebilir miyim?**

Şu an için paket basit doğrulama kurallarını desteklemektedir. Gelecekteki sürümlerde özel doğrulama fonksiyonları ekleme özelliği planlanmaktadır.

### 5\. **Paket açık kaynak mı?**

Evet, bu paket açık kaynaklıdır ve [MIT Lisansı](LICENSE) ile lisanslanmıştır.

* * *

Feedback
========

Her türlü geri bildiriminiz bizim için değerlidir. Lütfen görüşlerinizi bizimle paylaşın ve paketi geliştirmemize yardımcı olun.

* * *

Kısaca
======

**Dynamic Form Generator** paketi ile Flutter projelerinizde dinamik ve özelleştirilebilir formlar oluşturmak artık çok kolay. Esnek yapısı ve kullanım kolaylığı sayesinde zaman kazanacak ve daha verimli çalışacaksınız.

* * *

Teşekkürler ve iyi kodlamalar!