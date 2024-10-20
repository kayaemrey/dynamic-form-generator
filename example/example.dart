import 'package:flutter/material.dart';
import 'package:dynamic_form_generator/dynamic_form_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        body: SingleChildScrollView( // Formun taşmasını önlemek için
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: DynamicFormGenerator(
              fields: formFields,
              onSubmit: (formData) {
                // Form gönderildiğinde yapılacak işlemler
                String adiniz = formData['Adınız'];
                String soyadiniz = formData['Soyadınız'];
                String email = formData['Email'];
                String sifre = formData['Şifre'];
                String yas = formData['Yaş'];
                String cinsiyet = formData['Cinsiyet'];
                bool kosullariKabulEttim = formData['Kullanım koşullarını kabul ediyorum'];

                print('Adınız: $adiniz');
                print('Soyadınız: $soyadiniz');
                print('Email: $email');
                print('Şifre: $sifre');
                print('Yaş: $yas');
                print('Cinsiyet: $cinsiyet');
                print('Koşulları Kabul Ettim: $kosullariKabulEttim');
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
      ),
    );
  }
}
