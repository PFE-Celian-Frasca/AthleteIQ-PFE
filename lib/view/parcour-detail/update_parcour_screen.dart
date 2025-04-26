import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/resources/components/Button/custom_floating_button.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/resources/components/ChoiceChip/custom_choice_chip.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_notifier.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';

class UpdateParcourScreen extends HookConsumerWidget {
  final String parcourId;
  UpdateParcourScreen({required this.parcourId, super.key});

  final _formUpdateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateParcourNotifierProvider(parcourId));

    return Scaffold(
      appBar: CustomAppBar(
        title: "Modifier un parcours",
        hasBackButton: true,
        backIcon: Icons.close,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: _formUpdateKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        _buildTitleInput(context, ref, state),
                        _buildDescriptionInput(context, ref, state),
                        SizedBox(height: 20.h),
                        CustomChoiceChipSelector<ParcourVisibility>(
                          title: 'Type de parcours',
                          options: const {
                            ParcourVisibility.public: 'Public',
                            ParcourVisibility.private: 'Privé',
                            ParcourVisibility.shared: 'Partagé',
                          },
                          selectedValue: state.parcourType,
                          onSelected: (ParcourVisibility value) {
                            ref
                                .read(updateParcourNotifierProvider(parcourId)
                                    .notifier)
                                .setParcourType(value);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        SizedBox(height: 10.h),
                        if (state.parcourType == ParcourVisibility.shared)
                          _buildFriendsSelector(context, state, ref),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: _buildSubmitButton(context, state, ref),
    );
  }

  Widget _buildFriendsSelector(
      BuildContext context, UpdateParcourState state, WidgetRef ref) {
    return Column(
      children: [
        Text(
          "Partager avec des amis",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: state.friends.isNotEmpty
              ? GenericListComponent<UserModel>(
                  onItemSelected: (UserModel friend) {
                    if (state.friendsToShare.contains(friend.id)) {
                      ref
                          .read(
                              updateParcourNotifierProvider(parcourId).notifier)
                          .removeFriendToShare(friend.id);
                    } else {
                      ref
                          .read(
                              updateParcourNotifierProvider(parcourId).notifier)
                          .addFriendToShare(friend.id);
                    }
                  },
                  selectedIds: state.friendsToShare,
                  excludeId: state.owner?.id ?? '',
                  items: state.friends,
                  idExtractor: (friend) => friend.id,
                  buildItem: (context, friend) => Text(friend.pseudo),
                  icon: const Icon(Icons.person),
                )
              : const Center(child: Text("Aucun ami à afficher")),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, UpdateParcourState state, WidgetRef ref) {
    return CustomFloatingButton(
      onPressed: () async {
        if (state.parcourType == ParcourVisibility.shared &&
            state.friendsToShare.isEmpty) {
          ref.watch(internalNotificationProvider).showErrorToast(
              "Veuillez sélectionner des amis avec qui partager votre parcours.");
          return;
        }
        ref
            .read(updateParcourNotifierProvider(parcourId).notifier)
            .updateParcours(context);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: state.isLoading ? null : Icons.check,
      iconColor: state.isLoading
          ? Colors.transparent
          : Theme.of(context).colorScheme.onPrimary,
      loadingWidget: state.isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : null,
    );
  }

  Widget _buildTitleInput(
      BuildContext context, WidgetRef ref, UpdateParcourState state) {
    return CustomInputField(
      label: 'Titre',
      keyboardType: TextInputType.text,
      icon: UniconsLine.map,
      controller: TextEditingController(text: state.title),
      onChanged: (value) => ref
          .read(updateParcourNotifierProvider(parcourId).notifier)
          .setTitle(value),
      validator: (value) =>
          value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
      context: context,
    );
  }

  Widget _buildDescriptionInput(
      BuildContext context, WidgetRef ref, UpdateParcourState state) {
    return CustomInputField(
      label: 'Description',
      icon: UniconsLine.comment,
      controller: TextEditingController(text: state.description),
      onChanged: (value) => ref
          .read(updateParcourNotifierProvider(parcourId).notifier)
          .setDescription(value),
      validator: (value) => null, // No validation needed for description
      context: context,
    );
  }
}
