import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/benefits_section.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_form_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_controller.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ContractDetailsPage extends ConsumerWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeArg = getRouteArg<int?>(context);

    final asyncValue = ref.watch(getContractDetailsProvider(routeArg));

    ref.listenOnErrorWithoutSnackbar(
      provider: getContractDetailsProvider(routeArg),
      context: context,
    );

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dettagli del contratto'),
          actions: const [ErrorsWidget()],
          bottom: TabBar(tabs: _tabs),
        ),
        body: asyncValue.when(
          data:
              (details) => TabBarView(
                children: [
                  ContractFormWidget(details.contract),
                  const BenefitsSection(),
                ],
              ),
          error: (_, __) {
            return DataLoadErrorScreenWidget(
              onPressed: () => ref.invalidate(getContractDetailsProvider),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Tab> get _tabs => const [
    Tab(text: 'Dettagli del contratto'),
    Tab(text: 'Benefits'),
  ];
}

/* Per la sezione contratto di un gestionale per la gestione delle candidature, dovresti includere i seguenti dati:

Tipo di Contratto:

Full-time / Part-time

Tempo determinato / Indeterminato

Stage / Apprendistato

Freelance / Collaborazione

Data di Inizio:

La data in cui il contratto entra in vigore.

Data di Fine (se applicabile):

Solo se il contratto è a tempo determinato, la data di fine del contratto.

Orario di Lavoro:

Ore settimanali, orari di lavoro (se specifici) o flessibilità oraria.

Retribuzione:

Stipendio lordo mensile o annuo

Bonus o incentivi

Eventuali benefici extra (buoni pasto, premi, etc.)

Livello Contrattuale:

Riferimento al livello contrattuale secondo il contratto collettivo nazionale di riferimento (CCNL) o l'inquadramento aziendale.

Luogo di Lavoro:

Indirizzo o città dove il candidato lavorerà (o se il lavoro è remoto).

Periodo di Prova (se previsto):

Durata del periodo di prova e condizioni per la cessazione anticipata.

Condizioni di Termini e Risoluzione:

Specifiche riguardo la cessazione del contratto (ad esempio, preavviso, condizioni di risoluzione, ecc.).

Contratti Aggiuntivi o Altri Accordi:

Se ci sono accordi particolari, come la possibilità di rinnovo o clausole aggiuntive.

Documentazione da Allegare:

Eventuali allegati richiesti, come la firma del contratto, copie dei documenti di identità, etc.

Firma:

La sezione dove il datore di lavoro e il candidato firmano per confermare l'accettazione dei termini del contratto.

Puoi anche aggiungere campi per le note specifiche o le condizioni personalizzate a seconda delle esigenze dell'azienda o della posizione. */
