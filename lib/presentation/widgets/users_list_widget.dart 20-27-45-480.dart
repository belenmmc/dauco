import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/presentation/blocs/delete_user_bloc.dart';
import 'package:dauco/presentation/pages/edit_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListWidget extends StatefulWidget {
  final List<UserModel> users;
  final double screenWidth;
  final int? selectedIndex;
  final Function(int) onItemSelected;
  final Function() onNextPage;
  final Function() onPreviousPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String searchQuery;
  final VoidCallback onRefreshUsers;

  const UsersListWidget({
    super.key,
    required this.users,
    required this.screenWidth,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.searchQuery,
    required this.onRefreshUsers,
  });

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  static const _cardColor = Color.fromARGB(255, 247, 238, 255);
  static const _buttonColor = Color.fromARGB(255, 97, 135, 174);
  static const _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _buildUsersList(),
          if (widget.users.isNotEmpty) _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    final query = widget.searchQuery.toLowerCase();

    final filteredUsers = query.isEmpty
        ? widget.users
        : widget.users.where((user) {
            return user.email.toLowerCase().contains(query) ||
                user.name.toLowerCase().contains(query) ||
                user.managerId.toString().toLowerCase().contains(query);
          }).toList();

    return Expanded(
      child: filteredUsers.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) =>
                  _buildUserCard(filteredUsers[index]),
            ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          child: AnimatedContainer(
            duration: _animationDuration,
            margin:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 150.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _cardColor,
            ),
            padding: const EdgeInsets.all(10.0),
            child: _UserItem(
                user: user,
                screenWidth: widget.screenWidth,
                onRefreshUsers: widget.onRefreshUsers),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 2.0, top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: widget.hasPreviousPage ? widget.onPreviousPage : null,
            color: widget.hasPreviousPage
                ? _buttonColor
                : _buttonColor.withOpacity(0.5),
          ),
          const SizedBox(width: 20),
          _PaginationButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: widget.hasNextPage ? widget.onNextPage : null,
            color: widget.hasNextPage
                ? _buttonColor
                : _buttonColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No hay usuarios',
        style: TextStyle(
          color: Color.fromARGB(255, 43, 45, 66),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  final UserModel user;
  final double screenWidth;
  final VoidCallback onRefreshUsers;

  const _UserItem({
    required this.user,
    required this.screenWidth,
    required this.onRefreshUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'Id: ${user.managerId}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 97, 135, 174)),
              tooltip: 'Editar usuario',
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserPage(user: user),
                  ),
                );

                if (updated == true) {
                  onRefreshUsers();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete,
                  color: Color.fromARGB(255, 56, 78, 100)),
              tooltip: 'Eliminar usuario',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: Text(
                        '¿Estás seguro de que deseas eliminar a ${user.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context
                              .read<DeleteUserBloc>()
                              .add(DeleteUserEvent(email: user.email));
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final Color color;

  const _PaginationButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
        minimumSize: const Size.square(40),
        disabledBackgroundColor: color,
        disabledForegroundColor: Colors.white,
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}
