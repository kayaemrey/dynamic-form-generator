library dynamic_form_generator;

import 'dart:convert';

import 'package:flutter/material.dart';

/// Desteklenen alan tipleri
enum FieldType { text, email, password, number, checkbox, dropdown }

/// Form alanı bilgilerini tutan sınıf
class FieldInfo {
  final FieldType type;
  final String name;
  final String label;
  final bool isRequired;
  final String? hintText;
  final List<String>? options;
  final InputDecoration? decoration;
  final TextStyle? textStyle;

  FieldInfo({
    required this.type,
    required this.name,
    required this.label,
    this.isRequired = false,
    this.hintText,
    this.options,
    this.decoration,
    this.textStyle,
  });

  /// Alan tanımını ayrıştıran metot
  factory FieldInfo.parse(String definition) {
    // Tip ve kalan kısmı ayırma
    var typeSplit = definition.split(':');
    var typeStr = typeSplit[0];
    var rest = typeSplit.sublist(1).join(':');

    // Label ve özellikleri ayırma
    var labelSplit = rest.split('?');
    var labelPart = labelSplit[0];
    var propertiesPart = labelSplit.length > 1 ? labelSplit[1] : '';

    // Label ve seçenekleri ayırma
    var labelOptionsSplit = labelPart.split('=');
    var label = labelOptionsSplit[0];
    var options = labelOptionsSplit.length > 1 ? labelOptionsSplit[1].split(',') : null;

    // Özellikleri ayırma
    var properties = propertiesPart.split('&');
    bool isRequired = properties.contains('required');
    String? hintText;
    TextStyle? textStyle;
    InputDecoration? decoration;

    for (var prop in properties) {
      if (prop.startsWith('hint=')) {
        hintText = prop.substring(5);
      } else if (prop.startsWith('style=')) {
        var styleJson = prop.substring(6);
        Map<String, dynamic> styleMap = jsonDecode(styleJson);
        textStyle = _parseTextStyle(styleMap);
      } else if (prop.startsWith('decoration=')) {
        var decorationJson = prop.substring(11);
        Map<String, dynamic> decorationMap = jsonDecode(decorationJson);
        decoration = _parseInputDecoration(decorationMap);
      }
    }

    // Alan tipini belirleme
    FieldType fieldType;
    switch (typeStr) {
      case 't':
      case 'text':
        fieldType = FieldType.text;
        break;
      case 'e':
      case 'email':
        fieldType = FieldType.email;
        break;
      case 'p':
      case 'password':
        fieldType = FieldType.password;
        break;
      case 'n':
      case 'number':
        fieldType = FieldType.number;
        break;
      case 'c':
      case 'checkbox':
        fieldType = FieldType.checkbox;
        break;
      case 'd':
      case 'dropdown':
        fieldType = FieldType.dropdown;
        break;
      default:
        throw Exception('Geçersiz alan tipi: $typeStr');
    }

    return FieldInfo(
      type: fieldType,
      name: label,
      label: label,
      isRequired: isRequired,
      hintText: hintText,
      options: options,
      textStyle: textStyle,
      decoration: decoration,
    );
  }

  static TextStyle? _parseTextStyle(Map<String, dynamic> styleMap) {
    return TextStyle(
      color: _parseColor(styleMap['color']),
      fontSize: styleMap['fontSize']?.toDouble(),
      fontWeight: _parseFontWeight(styleMap['fontWeight']),
      fontStyle: _parseFontStyle(styleMap['fontStyle']),
    );
  }

  static InputDecoration? _parseInputDecoration(Map<String, dynamic> decorationMap) {
    return InputDecoration(
      labelText: decorationMap['labelText'],
      hintText: decorationMap['hintText'],
      filled: decorationMap['filled'] ?? false,
      fillColor: _parseColor(decorationMap['fillColor']),
      border: decorationMap['border'] == 'outline'
          ? OutlineInputBorder()
          : decorationMap['border'] == 'underline'
              ? UnderlineInputBorder()
              : null,
    );
  }

  static Color? _parseColor(String? colorStr) {
    if (colorStr == null) return null;
    switch (colorStr.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        // Hex kodu olarak kabul edelim
        if (colorStr.startsWith('#')) {
          return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
        }
        return null;
    }
  }

  static FontWeight? _parseFontWeight(String? fontWeightStr) {
    switch (fontWeightStr) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      default:
        return null;
    }
  }

  static FontStyle? _parseFontStyle(String? fontStyleStr) {
    switch (fontStyleStr) {
      case 'italic':
        return FontStyle.italic;
      case 'normal':
        return FontStyle.normal;
      default:
        return null;
    }
  }
}

/// Dinamik form oluşturucu widget
class DynamicFormGenerator extends StatefulWidget {
  final List<dynamic> fields;
  final void Function(Map<String, dynamic>) onSubmit;
  final InputDecoration? fieldDecoration;
  final TextStyle? textStyle;

  DynamicFormGenerator({
    required this.fields,
    required this.onSubmit,
    this.fieldDecoration,
    this.textStyle,
  });

  @override
  _DynamicFormGeneratorState createState() => _DynamicFormGeneratorState();
}

class _DynamicFormGeneratorState extends State<DynamicFormGenerator> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  final Map<String, String?> _dropdownSelectedValues = {}; // Dropdown seçilen değerler

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFields(widget.fields),
      ),
    );
  }

  List<Widget> _buildFields(List<dynamic> fields) {
    List<Widget> widgets = [];
    for (var field in fields) {
      if (field is List) {
        // Bu bir grup, Row içine alacağız
        widgets.add(
          Row(
            children: field.map<Widget>((f) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _buildField(f),
                ),
              );
            }).toList(),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), // Padding eklendi
            child: _buildField(field),
          ),
        );
      }
    }
    widgets.add(SizedBox(height: 16));
    widgets.add(
      ElevatedButton(
        onPressed: _submitForm,
        child: Text('Gönder'),
      ),
    );
    return widgets;
  }

  Widget _buildField(String fieldDefinition) {
    FieldInfo fieldInfo = FieldInfo.parse(fieldDefinition);

    // Alan bazlı stil uygulaması
    InputDecoration decoration = fieldInfo.decoration ??
        widget.fieldDecoration ??
        InputDecoration(
          labelText: fieldInfo.label,
          hintText: fieldInfo.hintText,
        );

    TextStyle? textStyle = fieldInfo.textStyle ?? widget.textStyle;

    // Alan tipine göre widget oluşturma
    switch (fieldInfo.type) {
      case FieldType.text:
        return _buildTextField(fieldInfo, decoration, textStyle);
      case FieldType.email:
        return _buildEmailField(fieldInfo, decoration, textStyle);
      case FieldType.password:
        return _buildPasswordField(fieldInfo, decoration, textStyle);
      case FieldType.number:
        return _buildNumberField(fieldInfo, decoration, textStyle);
      case FieldType.checkbox:
        return _buildCheckboxField(fieldInfo);
      case FieldType.dropdown:
        return _buildDropdownField(fieldInfo, decoration);
    }
  }

  Widget _buildTextField(FieldInfo fieldInfo, InputDecoration decoration, TextStyle? textStyle) {
    return TextFormField(
      decoration: decoration.copyWith(labelText: fieldInfo.label),
      style: textStyle,
      validator: (value) {
        if (fieldInfo.isRequired && (value == null || value.isEmpty)) {
          return '${fieldInfo.label} gerekli';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
    );
  }

  Widget _buildEmailField(FieldInfo fieldInfo, InputDecoration decoration, TextStyle? textStyle) {
    return TextFormField(
      decoration: decoration.copyWith(labelText: fieldInfo.label),
      style: textStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (fieldInfo.isRequired && (value == null || value.isEmpty)) {
          return '${fieldInfo.label} gerekli';
        }
        if (value != null && !value.contains('@')) {
          return 'Geçerli bir email giriniz';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
    );
  }

  Widget _buildPasswordField(FieldInfo fieldInfo, InputDecoration decoration, TextStyle? textStyle) {
    return TextFormField(
      decoration: decoration.copyWith(labelText: fieldInfo.label),
      style: textStyle,
      obscureText: true,
      validator: (value) {
        if (fieldInfo.isRequired && (value == null || value.isEmpty)) {
          return '${fieldInfo.label} gerekli';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
    );
  }

  Widget _buildNumberField(FieldInfo fieldInfo, InputDecoration decoration, TextStyle? textStyle) {
    return TextFormField(
      decoration: decoration.copyWith(labelText: fieldInfo.label),
      style: textStyle,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (fieldInfo.isRequired && (value == null || value.isEmpty)) {
          return '${fieldInfo.label} gerekli';
        }
        if (value != null && double.tryParse(value) == null) {
          return 'Geçerli bir sayı giriniz';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
    );
  }

  Widget _buildCheckboxField(FieldInfo fieldInfo) {
    return FormField<bool>(
      initialValue: false,
      validator: (value) {
        if (fieldInfo.isRequired && value != true) {
          return '${fieldInfo.label} onaylanmalı';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
      builder: (state) {
        return CheckboxListTile(
          title: Text(fieldInfo.label),
          value: state.value,
          onChanged: (val) => state.didChange(val),
          controlAffinity: ListTileControlAffinity.leading,
          subtitle:
              state.hasError ? Text(state.errorText!, style: TextStyle(color: Colors.red)) : null,
        );
      },
    );
  }

  Widget _buildDropdownField(FieldInfo fieldInfo, InputDecoration decoration) {
    return FormField<String>(
      validator: (value) {
        if (fieldInfo.isRequired && (value == null || value.isEmpty)) {
          return '${fieldInfo.label} gerekli';
        }
        return null;
      },
      onSaved: (value) => _formValues[fieldInfo.name] = value,
      builder: (state) {
        return InputDecorator(
          decoration: decoration.copyWith(errorText: state.errorText),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _dropdownSelectedValues[fieldInfo.name],
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _dropdownSelectedValues[fieldInfo.name] = newValue;
                  state.didChange(newValue);
                });
              },
              items: fieldInfo.options
                  ?.map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_formValues);
    }
  }
}
