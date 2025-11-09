import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/responsive_layout_widget.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyle.pad16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 30.0,
          children: [
            _CompanyNameField(_nameController),
            Row(
              spacing: AppStyle.formFieldSpacing,
              children: [
                Expanded(child: _CityField(_cityController)),
                Expanded(child: _AddressField(_addressController)),
              ],
            ),

            _WebsiteField(_websiteController),

            _ResponsiveFormFields(
              emailController: _emailController,
              phoneController: _phoneController,
              workingHoursController: _workingHoursController,
            ),
            
            Align(
              alignment: Alignment.centerRight,
              child: SaveButtonWidget(
                onPressed: () => widget.submit(_companyObj(), _formKey),
              ),
            ),
          ],
        ),
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

class _CompanyNameField extends StatelessWidget {
  const _CompanyNameField(this.nameController);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: nameController,
      label: "Nome azienda(*)",
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField(this.cityController);

  final TextEditingController cityController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: cityController,
      label: "Città(*)",
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField(this.addressController);

  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: addressController,
      label: "Indirizzo(*)",
    );
  }
}

class _WorkingHoursField extends StatelessWidget {
  const _WorkingHoursField(this.workingHoursController);

  final TextEditingController workingHoursController;

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      controller: workingHoursController,
      label: "Orario di lavoro",
    );
  }
}

class _WebsiteField extends StatelessWidget {
  const _WebsiteField(this.websiteController);
  final TextEditingController websiteController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: websiteController,
      label: "Sito web(*)",
      keyboardType: TextInputType.url,
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField(this.emailController);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: emailController,
      label: "Email(*)",
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField(this.phoneController);

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      controller: phoneController,
      label: "Numero di telefono",
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

class _ResponsiveFormFields extends StatelessWidget {
  const _ResponsiveFormFields({
    required this.phoneController,
    required this.workingHoursController,
    required this.emailController,
  });

  final TextEditingController phoneController;
  final TextEditingController workingHoursController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutWidget(
      desktop:
          (_, __) => Row(
            spacing: AppStyle.formFieldSpacing,
            children: [
              Expanded(flex: 2, child: _EmailField(emailController)),
              Expanded(child: _PhoneField(phoneController)),
              Expanded(child: _WorkingHoursField(workingHoursController)),
            ],
          ),

      compact:
          (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 30.0,
            children: [
              _EmailField(emailController),

              Row(
                spacing: AppStyle.formFieldSpacing,
                children: [
                  Expanded(child: _PhoneField(phoneController)),
                  Expanded(child: _WorkingHoursField(workingHoursController)),
                ],
              ),
            ],
          ),
    );
  }
}
