// lib/features/welcome/presentation/pages/welcome_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/components/atoms/app_logo.dart';
import '../widgets/molecules/welcome_background.dart';
import '../widgets/organisms/welcome_form.dart';
import '../../../../routes/route_names.dart';


class WelcomePage extends ConsumerWidget {
  // Déclarer la clé comme statique
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Garder le constructeur const
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: WelcomeBackground(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Stack(
            children: [
              // Conteneur centré avec positionnement relatif
              Align(
                alignment: const Alignment(0, 0.65), // Ajusté pour être légèrement au-dessus du centre
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    AppLogo(
                      size: LogoSize.large,
                    ),

                    // Espace fixe de 5px entre le logo et le formulaire
                    const SizedBox(height: 5),

                    // Formulaire
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingHorizontalM.left,
                      ),
                      child: WelcomeForm(
                        isLoading: false,
                        onSubmit: () {
                          Navigator.of(context).pushReplacementNamed('/category');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}