import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ─── Side Panel ────────────────────────────────────────────────────────────────

class SidePanel extends StatefulWidget {
  const SidePanel({super.key});

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  int _tab = 0;
  int? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPanel,
      child: Column(children: [
        // ── Tab header ──────────────────────────────────────────────────────
        Container(
          height: 36,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kBorder)),
          ),
          child: Row(children: [
            PanelTab(label: 'EXPLORER', index: 0, current: _tab,
                onTap: (i) => setState(() => _tab = i)),
            PanelTab(label: 'GIT',      index: 1, current: _tab,
                onTap: (i) => setState(() => _tab = i)),
            PanelTab(label: 'SEARCH',   index: 2, current: _tab,
                onTap: (i) => setState(() => _tab = i)),
          ]),
        ),
        // ── Body ────────────────────────────────────────────────────────────
        Expanded(child: switch (_tab) {
          1    => const _GitPanel(),
          2    => const _SearchPanel(),
          _    => _FileTree(
              nodes: kDemoTree,
              selected: _selectedFile,
              onSelect: (i) => setState(() => _selectedFile = i),
            ),
        }),
      ]),
    );
  }
}

// ─── File Tree ─────────────────────────────────────────────────────────────────

class _FileTree extends StatelessWidget {
  final List<FileNode> nodes;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _FileTree({
    required this.nodes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 4),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'PROJECT',
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: kTextDim,
              fontFamily: 'monospace',
            ),
          ),
        ),
        ...List.generate(nodes.length, (i) => _FileRow(
          node: nodes[i],
          selected: selected == i,
          onTap: () => onSelect(i),
        )),
      ],
    );
  }
}

class _FileRow extends StatefulWidget {
  final FileNode node;
  final bool selected;
  final VoidCallback onTap;

  const _FileRow({
    required this.node,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_FileRow> createState() => _FileRowState();
}

class _FileRowState extends State<_FileRow> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          color: widget.selected
              ? kAccent.withOpacity(0.15)
              : _hov ? kBorder.withOpacity(0.5) : Colors.transparent,
          padding: EdgeInsets.only(
            left: 12.0 + widget.node.depth * 16.0,
            right: 8, top: 5, bottom: 5,
          ),
          child: Row(children: [
            Text(widget.node.icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
            Text(
              widget.node.name,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: widget.selected ? kAccent : kText,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Git Panel ─────────────────────────────────────────────────────────────────

class _GitPanel extends StatelessWidget {
  const _GitPanel();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('STAGED CHANGES'),
        _gitItem('A', 'editor.dart',  const Color(0xFFA6E3A1)),
        const SizedBox(height: 10),
        _sectionLabel('CHANGES'),
        _gitItem('M', 'main.dart',    const Color(0xFFFFCB6B)),
        _gitItem('M', 'app.dart',     const Color(0xFFFFCB6B)),
        _gitItem('D', 'old.dart',     const Color(0xFFFF5370)),
      ],
    );
  }

  Widget _sectionLabel(String s) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(s, style: const TextStyle(
      fontSize: 10, letterSpacing: 1.4, color: kTextDim, fontFamily: 'monospace',
    )),
  );

  Widget _gitItem(String status, String name, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Container(
        width: 18, height: 18,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(child: Text(status, style: TextStyle(
          fontSize: 10, color: color, fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ))),
      ),
      const SizedBox(width: 8),
      Text(name, style: const TextStyle(
        fontSize: 12, fontFamily: 'monospace', color: kText,
      )),
    ]),
  );
}

// ─── Search Panel ──────────────────────────────────────────────────────────────

class _SearchPanel extends StatefulWidget {
  const _SearchPanel();

  @override
  State<_SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<_SearchPanel> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Search field
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: kBg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: kBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: [
            const Text('🔍', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
            Expanded(child: TextField(
              controller: _ctrl,
              style: const TextStyle(
                fontSize: 12, fontFamily: 'monospace', color: kText,
              ),
              cursorColor: kAccent,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search files...',
                hintStyle: TextStyle(
                  fontSize: 12, fontFamily: 'monospace', color: kLineNum,
                ),
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 7),
              ),
            )),
          ]),
        ),
        const SizedBox(height: 12),
        // Placeholder results
        if (_ctrl.text.isEmpty)
          Text('Type to search across all files.',
            style: const TextStyle(
              fontSize: 11, fontFamily: 'monospace', color: kTextDim,
            ),
          ),
      ]),
    );
  }
}
