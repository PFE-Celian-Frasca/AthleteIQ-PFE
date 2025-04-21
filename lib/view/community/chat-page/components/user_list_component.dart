import 'package:athlete_iq/view/community/providers/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserListComponent extends HookConsumerWidget {
  const UserListComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListProvider);
    final userListNotifier = ref.read(userListProvider.notifier);
    final scrollController = useScrollController();
    final searchController = useTextEditingController();

    useEffect(() {
      void loadInitialUsers() {
        if (state.users.isEmpty && !state.isLoading && state.hasMore) {
          userListNotifier.loadUsers();
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => loadInitialUsers());
      return null;
    }, const []);

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent &&
            !state.isLoading &&
            state.hasMore) {
          userListNotifier.loadUsers();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, state.hasMore, state.isLoading]);

    useEffect(() {
      void onSearchChanged() {
        if (searchController.text.trim().isEmpty && state.isSearchActive) {
          userListNotifier.resetPagination();
        } else {
          userListNotifier.searchUsers(searchController.text.trim());
        }
      }

      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController.text]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: state.isLoading && state.users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.errorMessage != null
                  ? Center(child: Text("Erreur: ${state.errorMessage}"))
                  : state.users.isEmpty
                      ? const Center(child: Text("Aucun utilisateur trouvé."))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount:
                              state.users.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (_, index) {
                            if (index == state.users.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return ListTile(
                              title: Text(state.users[index].pseudo),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
