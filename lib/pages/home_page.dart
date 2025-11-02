import 'package:flutter/material.dart';
import 'package:manage_applications/pages/companies_list_page/companies_page.dart';
import 'package:manage_applications/pages/errors_page/errors_page.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_page.dart';
import 'package:manage_applications/widgets/components/errors_widget/icon_with_badge_widget.dart';
import 'package:manage_applications/widgets/components/side_navigation_rail_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SideNavigationRailWidget(
        pages: [JobApplicationsPage(), CompaniesPage(), ErrorsPage()],
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.folder),
            label: Text("Lista candidature"),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.business),
            label: Text("Lista aziende"),
          ),
          NavigationRailDestination(
            icon: IconWithBadgeWidget(icon: Icon(Icons.pan_tool)),
            label: Text("Pannello degli errori"),
          ),
        ],
      ),
    );
  }
}
