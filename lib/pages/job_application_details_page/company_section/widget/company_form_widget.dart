import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyFormWidget extends ConsumerStatefulWidget {
  const CompanyFormWidget({super.key, required this.submit, this.company});

  final void Function(Company, GlobalKey<FormState>) submit;
  final Company? company;

  @override
  ConsumerState<CompanyFormWidget> createState() => _CompanyFormWidgetState();
}

class _CompanyFormWidgetState extends ConsumerState<CompanyFormWidget>
    with AutomaticKeepAliveClientMixin<CompanyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.company != null) {
      final company = widget.company!;
      _nameController.text = company.name;
      _cityController.text = company.city;
      _addressController.text = company.address;
      _websiteController.text = company.website;
      _phoneController.text = company.phoneNumber ?? "";
      _workingHoursController.text = company.workingHours ?? "";
      _emailController.text = company.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _workingHoursController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 30.0,
        children: [
          Row(children: [_companyNameField()]),
          Row(
            spacing: AppStyle.formFieldSpacing,
            children: [_cityField(), _addressField(), _workingHoursField()],
          ),
          Row(
            spacing: AppStyle.formFieldSpacing,
            children: [_websiteField(), _emailField(), _phoneNumberField()],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SaveButtonWidget(
              onPressed: () => widget.submit(_companyObj(), _formKey),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _companyNameField() {
    return Expanded(
      child: RequiredFormFieldWidget(
        controller: _nameController,
        label: "Nome azienda(*)",
      ),
    );
  }

  Expanded _cityField() {
    return Expanded(
      child: RequiredFormFieldWidget(
        controller: _cityController,
        label: "Città(*)",
      ),
    );
  }

  Expanded _addressField() {
    return Expanded(
      child: RequiredFormFieldWidget(
        controller: _addressController,
        label: "Indirizzo(*)",
      ),
    );
  }

  Expanded _workingHoursField() {
    return Expanded(
      child: FormFieldWidget(
        controller: _workingHoursController,
        label: "Orario di lavoro",
      ),
    );
  }

  Expanded _websiteField() {
    return Expanded(
      flex: 2,
      child: RequiredFormFieldWidget(
        controller: _websiteController,
        label: "Sito web(*)",
        keyboardType: TextInputType.url,
      ),
    );
  }

  Expanded _emailField() {
    return Expanded(
      child: RequiredFormFieldWidget(
        controller: _emailController,
        label: "Email dell'azienda(*)",
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Expanded _phoneNumberField() {
    return Expanded(
      child: FormFieldWidget(
        controller: _phoneController,
        label: "Numero di telefono dell'azienda",
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Company _companyObj() {
    return Company(
      id: widget.company?.id,
      name: _nameController.text,
      address: _addressController.text,
      city: _cityController.text,
      phoneNumber: _phoneController.text,
      website: _websiteController.text,
      email: _emailController.text,
      workingHours: _workingHoursController.text,
    );
  }
}
