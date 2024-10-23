// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';
import 'widgets.dart';

class ConsoleWidget extends StatefulWidget {
  final bool showDivider;
  final ValueNotifier<String> output;

  const ConsoleWidget({
    this.showDivider = true,
    required this.output,
    super.key,
  });

  @override
  State<ConsoleWidget> createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends State<ConsoleWidget> {
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    widget.output.addListener(_scrollToEnd);
  }

  @override
  void dispose() {
    widget.output.removeListener(_scrollToEnd);
    scrollController?.dispose();
    scrollController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: widget.output,
      builder: (context, value, _) => Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: SelectableText(
              value,
              maxLines: null,
              style: GoogleFonts.robotoMono(
                fontSize: theme.textTheme.bodyMedium?.fontSize,
              ),
            ),
          ).sizedBox(width: double.infinity, height: double.infinity),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MiniIconButton(
                icon: Icons.playlist_remove,
                tooltip: 'Clear console',
                onPressed: value.isEmpty ? null : _clearConsole,
              ),
            ],
          ).padding(padding: const EdgeInsets.all(denseSpacing)),
        ],
      ),
    ).container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: widget.showDivider
            ? Border(
                top: Divider.createBorderSide(
                context,
                width: 8.0,
                color: theme.colorScheme.surface,
              ))
            : null,
      ),
    );
  }

  void _clearConsole() {
    widget.output.value = '';
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController?.animateTo(
        scrollController!.position.maxScrollExtent,
        duration: animationDelay,
        curve: animationCurve,
      );
    });
  }
}
