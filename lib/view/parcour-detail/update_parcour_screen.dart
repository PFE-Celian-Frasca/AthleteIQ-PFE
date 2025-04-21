import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomFloatingButton.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class UpdateParcourScreen extends ConsumerWidget {
  UpdateParcourScreen({super.key});

  final _formUpdateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcourDetails = ref.watch(
      parcoursProvider.select((state) => state.maybeWhen(
            orElse: () => null,
            parcoursDetails: (parcour) => parcour,
          )),
    );

    final titleController =
        TextEditingController(text: parcourDetails?.parcours.title ?? '');
    final descriptionController =
        TextEditingController(text: parcourDetails?.parcours.description ?? '');
    ParcoursType type = parcourDetails?.parcours.type ?? ParcoursType.Public;

    Future<void> saveParcour() async {
      if (_formUpdateKey.currentState!.validate()) {
        final updatedParcour = parcourDetails!.parcours.copyWith(
            title: titleController.text,
            description: descriptionController.text,
            type: type);
        await ref
            .read(parcoursProvider.notifier)
            .updateParcours(updatedParcour);
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Modifier un parcours",
        hasBackButton: true,
        backIcon: Icons.close,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formUpdateKey,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CustomInputField(
                    context: context,
                    controller: titleController,
                    label: 'Titre',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                      }
                      return null;
                    },
                    icon: UniconsLine.map,
                  ),
                  SizedBox(height: 20.h),
                  CustomInputField(
                    context: context,
                    controller: descriptionController,
                    label: 'Description',
                    icon: UniconsLine.comment,
                    maxLines: 3,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      type = type == ParcoursType.Public
                          ? ParcoursType.Private
                          : ParcoursType.Public; // Toggle for demonstration
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Visibilité : ${type.toString().split('.').last}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Icon(
                            type == ParcoursType.Public
                                ? UniconsLine.globe
                                : UniconsLine.lock,
                            size: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: saveParcour,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icons.edit,
        iconColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
