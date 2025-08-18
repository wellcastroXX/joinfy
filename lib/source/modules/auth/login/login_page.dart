import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:joinfy/theme/text_styles.dart';
import 'package:joinfy/theme/colors.dart';
import 'package:joinfy/ui/widgets/app_buttons.dart';

const String kEyeOpenPng = 'assets/icons/eye_open.png';
const String kEyeClosedPng = 'assets/icons/eye_close.png';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _loading = false;

  // toggle "lembrar-se"
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
    if (!ok) return 'E-mail inválido';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Informe sua senha';
    if (value.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  Future<void> _onSubmit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // mock
    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Login enviado! Lembrar-se: ${_rememberMe ? "sim" : "não"} (mock)'),
      ),
    );
  }

  InputDecoration _dec(String label, {Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bodyLC.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.textSecondary, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 25.0;

    // Cálculos responsivos para a logo
    final screenSize = MediaQuery.of(context).size;
    final topPad =
        (screenSize.height * 0.015).clamp(8.0, 24.0).toDouble(); // 8–24 px
    final logoWidth = (screenSize.width * 0.55)
        .clamp(180.0, 350.0)
        .toDouble(); // 55% (min/max)

    // estilo maior para os botões sociais
    final socialTextStyle = AppTextStyles.headingLC
        .copyWith(fontSize: 16, fontWeight: FontWeight.w500);

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: AbsorbPointer(
          absorbing: _loading,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LOGO responsiva quase colada no topo
                        Padding(
                          padding: EdgeInsets.only(top: topPad),
                          child: Center(
                            child: Image.asset(
                              'assets/images/joinfy_logo.png',
                              width: logoWidth,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height * 0.04)
                              .clamp(16.0, 40.0),
                        ),

                        // TÍTULO "Entrar"
                        Text(
                          'Entrar',
                          style: AppTextStyles.headingLC.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 15),

                        // E-mail
                        TextFormField(
                          controller: _emailCtrl,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: _dec(
                            'abc@email.com',
                            prefix: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset('assets/icons/email.png',
                                  width: 20, height: 20),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: spacing),

                        // Senha
                        TextFormField(
                          controller: _passwordCtrl,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscurePass,
                          decoration: _dec(
                            'Sua senha',
                            prefix: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset('assets/icons/lock.png',
                                  width: 18, height: 16),
                            ),
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 44, minHeight: 44),
                              tooltip: _obscurePass ? 'Mostrar' : 'Ocultar',
                              icon: Image.asset(
                                _obscurePass ? kEyeClosedPng : kEyeOpenPng,
                                width: 18,
                                height: 18,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _onSubmit(),
                        ),

                        // lembrar-se + esqueceu a senha?
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Switch.adaptive(
                              value: _rememberMe,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFFFF5800),
                              onChanged: (v) => setState(() => _rememberMe = v),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Lembrar-se',
                              style: AppTextStyles.bodyLC.copyWith(
                                color: const Color(0xFF222222),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/forgot'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Esqueceu a senha?',
                                style: AppTextStyles.bodyLC.copyWith(
                                  color: const Color(0xFF44424A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Espaço elástico
                        SizedBox(
                          height: math.max(
                            12.0,
                            MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),

                        // --- BLOCO DE BOTÕES CENTRALIZADO ---
                        Center(
                          child: Column(
                            children: [
                              FractionallySizedBox(
                                alignment: Alignment.center,
                                widthFactor: appButtonWidthFactor(context),
                                child: AppPrimaryButton(
                                  label: 'INSCREVA-SE',
                                  onPressed: _loading
                                      ? null
                                      : () => Navigator.pushNamed(
                                          context, '/register'),
                                  fullWidth: false,
                                  trailing: Image.asset(
                                    'assets/icons/arrow_circle.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const AppOrTextDivider(verticalMargin: 25),

                              // Login com Google — largura 80% e ALTURA personalizada
                              FractionallySizedBox(
                                alignment: Alignment.center,
                                widthFactor: 0.80,
                                child: AppAltButton(
                                  label: 'Login com Google',
                                  onPressed: _loading ? null : () {},
                                  fullWidth: false,
                                  leading: Image.asset(
                                    'assets/icons/google_icon.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  pinLeading: true,
                                  reservedLeadingWidth: 52,
                                  textStyleOverride: socialTextStyle,
                                  // ⬇ altura só aqui:
                                  style: appAltButtonStyle(context).copyWith(
                                    minimumSize: MaterialStateProperty.all(
                                      const Size.fromHeight(64),
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Login com Facebook — largura 80% e ALTURA personalizada
                              FractionallySizedBox(
                                alignment: Alignment.center,
                                widthFactor: 0.80,
                                child: AppAltButton(
                                  label: 'Login com Facebook',
                                  onPressed: _loading ? null : () {},
                                  fullWidth: false,
                                  leading: Image.asset(
                                    'assets/icons/facebook_icon.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  pinLeading: true,
                                  reservedLeadingWidth: 52,
                                  textStyleOverride: socialTextStyle,
                                  // ⬇ altura só aqui:
                                  style: appAltButtonStyle(context).copyWith(
                                    minimumSize: MaterialStateProperty.all(
                                      const Size.fromHeight(64),
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        if (_loading) const Text('Enviando...'),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),

              // Rodapé CENTRALIZADO
              SafeArea(
                top: false,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final base = MediaQuery.of(context).size.width * 0.035;
                      final fontSize = base.clamp(14.0, 18.0);

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 12),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Não tem uma conta? ',
                              style: TextStyle(
                                fontSize: fontSize,
                                color: const Color(0xFF222222),
                                fontFamily: 'CodeProLC',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: Text(
                                'Inscreva-se',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'CodeProLC',
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF000080),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
