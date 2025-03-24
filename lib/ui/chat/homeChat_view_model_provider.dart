import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home/providers/timer_provider.dart';
import '../providers/loading_provider.dart';

class HomeChatViewModel extends ChangeNotifier {
  final Ref _ref;
  HomeChatViewModel(this._ref);

  Loading get _loading => _ref.read(loadingProvider);
  Stream? groups;

}