import 'package:flutter/material.dart';

/// HomePage
/// - Fundo: preto (placeholder para o Mapa futuramente)
/// - Topo: botão redondo de Menu (esq.) e Pesquisa (dir.) com ícone laranja #FF5800
/// - Abaixo: "opções deslizantes" pequenas (chips/cards) em uma faixa superior;
///   o restante da tela fica livre para o mapa.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Quase colado no topo, mas respeitando o notch/status bar
    final double topBarY = mq.viewPadding.top + 4;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const _SideMenu(), // menu lateral (versão branca)
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // TODO: Substituir por widget de mapa (GoogleMap/Mapbox) futuramente
          const _PlaceholderBackground(),

          // Camada de UI sobre o mapa
          SafeArea(
            top: false, // não adiciona padding no topo
            child: Stack(
              children: [
                // ===== Botão redondo: MENU (esquerda) =====
                Positioned(
                  left: 16,
                  top: topBarY,
                  child: _RoundIconButton(
                    icon: Icons.menu,
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    tooltip: 'Abrir menu',
                    bgColor: Colors.white,
                    iconColor: const Color(0xFFFF5800),
                  ),
                ),

                // ===== Botão redondo: PESQUISA (direita) =====
                Positioned(
                  right: 16,
                  top: topBarY,
                  child: _RoundIconButton(
                    icon: Icons.search,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesquisar…')),
                      );
                    },
                    tooltip: 'Pesquisar',
                    bgColor: Colors.white,
                    iconColor: const Color(0xFFFF5800),
                  ),
                ),

                // ===== Faixa superior com "opções deslizantes" (chips/cards pequenos) =====
                Positioned(
                  left: 0,
                  right: 0,
                  top: topBarY + 68,
                  child: SizedBox(
                    height: 50,
                    child: _QuickActionsBar(
                      actions: _quickActions,
                      onTap: (item) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Abrir: ${item.label}')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão redondo padrão
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Color bgColor;
  final Color iconColor;

  const _RoundIconButton({
    required this.icon,
    this.onTap,
    this.tooltip,
    this.bgColor = Colors.white,
    this.iconColor = const Color(0xFF000080),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? '',
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================
/// Side Menu (branco, estilo do print)
/// ======================
class _SideMenu extends StatelessWidget {
  const _SideMenu({
    this.onSelect,
    this.avatarAsset,
    this.userName = 'João Smith',
    this.notificationsCount = 0,
  });

  final ValueChanged<String>? onSelect;
  final String? avatarAsset;
  final String userName;
  final int notificationsCount;

  static const Color _brandBlue = Color(0xFF000080);
  static const Color _brandOrange = Color(0xFFFF5800);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 320,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Fechar',
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // Avatar centralizado
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEFEFEF),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: avatarAsset != null
                      ? Image.asset(
                          avatarAsset!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.black45,
                          ),
                        )
                      : const Icon(Icons.person,
                          size: 48, color: Colors.black45),
                ),
                const SizedBox(height: 12),

                // Nome centralizado
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _brandBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    fontFamily: 'CodeProLC', // remova se não estiver usando
                  ),
                ),
                const SizedBox(height: 20),

                // Itens do menu (como no print)
                _MenuTile(
                  icon: Icons.history,
                  label: 'Histórico de Pedidos',
                  onTap: () => _tap(context, 'historico'),
                ),
                _MenuTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notificações',
                  badge: notificationsCount,
                  badgeColor: _brandOrange,
                  onTap: () => _tap(context, 'notificacoes'),
                ),
                _MenuTile(
                  icon: Icons.local_offer_outlined,
                  label: 'Promoções',
                  onTap: () => _tap(context, 'promocoes'),
                ),
                _MenuTile(
                  icon: Icons.group_add_outlined,
                  label: 'Indique & Ganhe',
                  onTap: () => _tap(context, 'indique'),
                ),
                _MenuTile(
                  icon: Icons.settings_outlined,
                  label: 'Configurações',
                  onTap: () => _tap(context, 'configuracoes'),
                ),

                const Spacer(),

                // Botão Sair (pill laranja)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelect?.call('sair');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: const StadiumBorder(),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Sair',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'CodeProLC',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tap(BuildContext context, String key) {
    Navigator.of(context).pop();
    onSelect?.call(key);
  }
}

/// Item do menu com ícone, label e badge opcional (para Notificações)
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.badge = 0,
    this.badgeColor = const Color(0xFFFF5800),
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final int badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Ícone + badge
            SizedBox(
              width: 28,
              height: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.circle, size: 0),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(icon, size: 22, color: Colors.black87),
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'CodeProLC', // remova se não usar
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder para o fundo (depois vira o widget do mapa)
class _PlaceholderBackground extends StatelessWidget {
  const _PlaceholderBackground();
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Colors.black);
  }
}

// =============================
// Quick Actions (chips/cards)
// =============================

/// Agora cada ação recebe o caminho do ícone local (asset)
class _QuickActionItem {
  final String assetPath;
  final String label;
  const _QuickActionItem(this.assetPath, this.label);
}

/// Edite os caminhos conforme seus arquivos reais
const List<_QuickActionItem> _quickActions = [
  _QuickActionItem('assets/icons/basketball.png', 'Esportes'),
  _QuickActionItem('assets/icons/music.png', 'Músicas'),
  _QuickActionItem('assets/icons/food.png', 'Comida'),
  _QuickActionItem('assets/icons/food.png', 'Teste'),
  _QuickActionItem('assets/icons/food.png', 'Teste2'),
  _QuickActionItem('assets/icons/food.png', 'Teste3'),
];

class _QuickActionsBar extends StatelessWidget {
  final List<_QuickActionItem> actions;
  final ValueChanged<_QuickActionItem>? onTap;
  const _QuickActionsBar({required this.actions, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: actions.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, i) => _QuickActionCard(
        item: actions[i],
        onTap: () => onTap?.call(actions[i]),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickActionItem item;
  final VoidCallback? onTap;
  const _QuickActionCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.25),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 50,
          width: 130,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Image.asset(
                  item.assetPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8E8E9D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'CodeProLC',
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
