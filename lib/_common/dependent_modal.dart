import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/components/decoration_text_field.dart';
import 'package:flutter_medicare_reminder/models/user.dart';
import 'package:flutter_medicare_reminder/services/dependent_service.dart';
import 'package:uuid/uuid.dart';

showDependentModal(BuildContext context, {UserModel? user}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return DependentModal(
        userModel: user,
      );
    },
  );
}

class DependentModal extends StatefulWidget {
  final UserModel? userModel;
  const DependentModal({super.key, this.userModel});

  @override
  State<DependentModal> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DependentModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool isLoading = false;
  bool register = true;

  final DependentService _dependentService = DependentService();

  @override
  void initState() {
    if (widget.userModel != null) {
      _nameCtrl.text = widget.userModel!.name;
      _emailCtrl.text = widget.userModel!.email;
      _passwordCtrl.text = widget.userModel!.password;
    }
    super.initState();
  }

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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.userModel != null)
                            ? 'Editar ${widget.userModel!.name}'
                            : 'Adicionar dependente',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(15, 0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: getAuthenticationInputDecoration('Nome'),
                      validator: (String? value) {
                        if (value == null || value.length < 3) {
                          return 'Nome inválido!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: getAuthenticationInputDecoration('E-mail'),
                      validator: (String? value) {
                        if (value == null ||
                            value.length < 5 ||
                            !value.contains('@') ||
                            !value.contains('.')) {
                          return 'E-mail inválido!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: getAuthenticationInputDecoration('Senha'),
                      validator: (String? value) {
                        if (value == null || value.length < 5) {
                          return 'Senha inválida!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendClick();
                  },
                  child: (isLoading)
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.grey[800],
                          ),
                        )
                      : Text(
                          (widget.userModel != null)
                              ? 'Atualizar dependente'
                              : 'Cadastrar dependente',
                          style: const TextStyle(color: Colors.black),
                        ),
                ),
                Visibility(
                  visible: (widget.userModel != null),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red[100]),
                      shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () {
                      deleteClick();
                    },
                    child: const Text(
                      'Excluir dependente',
                      style:
                          TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendClick() {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String email = _emailCtrl.text;
    String password = _passwordCtrl.text;

    UserModel user = UserModel(
      id: const Uuid().v1(),
      name: name,
      email: email,
      password: password,
    );

    if (widget.userModel != null) {
      user.id = widget.userModel!.id;
    }

    _dependentService.registerDependent(user).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
    });
  }

  deleteClick() {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String email = _emailCtrl.text;
    String password = _passwordCtrl.text;

    UserModel user = UserModel(
      id: widget.userModel!.id,
      name: name,
      email: email,
      password: password,
    );

    _dependentService.deleteDependent(dependentId: user.id).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
