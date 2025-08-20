// lib/modules/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joinfy/capitalize_words_formatter.dart';
import 'package:joinfy/theme/text_styles.dart';
import 'package:joinfy/theme/colors.dart';
import 'package:joinfy/ui/widgets/app_buttons.dart';

const String kEyeOpenPng = 'assets/icons/eye_open.png';
const String kEyeClosedPng = 'assets/icons/eye_close.png';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Informe seu nome completo';
    if (!value.contains(' ')) return 'Inclua pelo menos um sobrenome';
    return null;
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
    if (value.isEmpty) return 'Crie uma senha';
    if (value.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _passwordCtrl.text) return 'As senhas não coincidem';
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
      const SnackBar(content: Text('Cadastro enviado! (mock)')),
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

    // mesmo estilo usado na LoginPage para os botões sociais
    final socialTextStyle = AppTextStyles.headingLC
        .copyWith(fontSize: 16, fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: Image.asset('assets/icons/arrow.png', width: 24, height: 24),
          ),
        ),
        title: null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Inscreva-se',
                style: AppTextStyles.headingLC.copyWith(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _loading,
        child: Column(
          children: [
            /// conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        inputFormatters: [CapitalizeWordsFormatter()],
                        decoration: _dec(
                          'Nome completo',
                          prefix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/icons/user@2x.png',
                                width: 18, height: 18),
                          ),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: spacing),
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
                      TextFormField(
                        controller: _passwordCtrl,
                        textInputAction: TextInputAction.next,
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
                      ),
                      const SizedBox(height: spacing),
                      TextFormField(
                        controller: _confirmCtrl,
                        textInputAction: TextInputAction.done,
                        obscureText: _obscureConfirm,
                        decoration: _dec(
                          'Confirme a senha',
                          prefix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/icons/lock.png',
                                width: 18, height: 16),
                          ),
                          suffix: IconButton(
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 44, minHeight: 44),
                            tooltip: _obscureConfirm ? 'Mostrar' : 'Ocultar',
                            icon: Image.asset(
                              _obscureConfirm ? kEyeClosedPng : kEyeOpenPng,
                              width: 18,
                              height: 18,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        validator: _validateConfirm,
                        onFieldSubmitted: (_) => _onSubmit(),
                      ),
                      const SizedBox(height: spacing * 1.5),

                      /// Botão principal responsivo
                      FractionallySizedBox(
                        widthFactor: appButtonWidthFactor(context),
                        child: AppPrimaryButton(
                          label: 'INSCREVA-SE',
                          onPressed: _loading ? null : _onSubmit,
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

                      /// Botão alternativo — Google (80% de largura + altura maior)
                      FractionallySizedBox(
                        widthFactor: 0.80,
                        child: AppAltButton(
                          label: 'Login com Google',
                          onPressed: _loading ? null : () {},
                          fullWidth: false,
                          leading: Image.asset('assets/icons/google_icon.png',
                              width: 35, height: 35),
                          pinLeading: true,
                          reservedLeadingWidth: 50,
                          textStyleOverride: socialTextStyle,
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
                      const SizedBox(height: 10),

                      /// Botão alternativo — Facebook (80% de largura + altura maior)
                      FractionallySizedBox(
                        widthFactor: 0.80,
                        child: AppAltButton(
                          label: 'Login com Facebook',
                          onPressed: _loading ? null : () {},
                          fullWidth: false,
                          leading: Image.asset('assets/icons/facebook_icon.png',
                              width: 35, height: 35),
                          pinLeading: true,
                          reservedLeadingWidth: 52,
                          textStyleOverride: socialTextStyle,
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

                      const SizedBox(height: 8),
                      if (_loading) const Text('Enviando...'),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

            /// Rodapé com fonte responsiva
            SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 4% da largura, limitado entre 14 e 18
                  final base = MediaQuery.of(context).size.width * 0.035;
                  final fontSize = base.clamp(14.0, 18.0);

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: const Color(0xFF222222),
                            fontFamily: 'CodeProLC',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            'Entrar',
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
          ],
        ),
      ),
    );
  }
}
