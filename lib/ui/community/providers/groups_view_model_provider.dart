import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/Groups.dart' as groupsModel;
import '../../providers/loading_provider.dart';

final groupsViewModelProvider = ChangeNotifierProvider.autoDispose(
      (ref) => GroupsViewModel(ref),
);

class GroupsViewModel extends ChangeNotifier {
  final Ref _ref;
  GroupsViewModel(this._ref);

}