import 'package:flutter/material.dart';

showUserModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return const UserModal();
    },
  );
}

class UserModal extends StatefulWidget {
  const UserModal({super.key});

  @override
  State<UserModal> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UserModal> {
  TextEditingController fkUser = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Adicionar dependente',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Transform.translate(
                  offset: const Offset(15, 0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Column(
              children: [],
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Cadastrar dependente',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
