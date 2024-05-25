import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/_common/snackBar.dart';
import 'package:flutter_medicare_reminder/components/decoration_text_field.dart';
import 'package:flutter_medicare_reminder/screens/dependent_screen.dart';
import 'package:flutter_medicare_reminder/services/authentication_service.dart';
import 'package:flutter_medicare_reminder/services/dependent_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool register = false;
  bool userType = false; //False = Usuário principal | True = Usuário dependente
  bool _obscureTextPass = true;
  bool _obscureTextConfirmPass = true;

  final _formKey = GlobalKey<FormState>();
  String? _pass;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthenticationService _authService = AuthenticationService();
  final DependentService _dependentService = DependentService();

  void _toggleObscureText(String field) {
    setState(() {
      if (field == 'password') {
        _obscureTextPass = !_obscureTextPass;
      } else if (field == 'confirmPassword') {
        _obscureTextConfirmPass = !_obscureTextConfirmPass;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/medicare_logo.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: register,
                    child: TextFormField(
                      controller: _userController,
                      decoration: getAuthenticationInputDecoration('Usuário'),
                      validator: (String? value) {
                        if (value == null || value.length < 5) {
                          return 'Usuário inválido!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
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
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        getAuthenticationInputDecoration('Senha').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => _toggleObscureText('password'),
                      ),
                    ),
                    obscureText: _obscureTextPass,
                    validator: (String? value) {
                      if (value == null || value.length < 5) {
                        return 'Senha inválida!';
                      }
                      _pass = value;
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: register,
                    child: TextFormField(
                      decoration:
                          getAuthenticationInputDecoration('Confirmar senha')
                              .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              _toggleObscureText('confirmPassword'),
                        ),
                      ),
                      obscureText: _obscureTextConfirmPass,
                      validator: (String? value) {
                        if (_pass != value) {
                          return 'Senha não é igual!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: !register,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              'Principal',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        Switch(
                            value: userType,
                            onChanged: (value) {
                              setState(() {
                                userType = !userType;
                              });
                            },
                            activeColor: userType
                                ? Colors.grey[600]
                                : Colors.white // Define a cor quando ligado
                            ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Dependente',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        buttonClick();
                      } else {}
                    },
                    child: Text(
                      (!register) ? 'Entrar' : 'Cadastrar',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        register = !register;
                      });
                    },
                    child: Text(
                      (!register)
                          ? 'Ainda não tenho cadastro'
                          : 'Já tenho cadastro',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buttonClick() {
    String name = _userController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    if (register) {
      _authService
          .registerUser(
              name: name, email: email, password: password, context: context)
          .then(
        (String? error) {
          if (error != null) {
            showSnackBar(context: context, text: error);
          } else {
            showSnackBar(
                context: context,
                text: "Cadastro efetuado com sucesso",
                isError: false);
          }
        },
      );
    } else {
      if (!userType) {
        _authService
            .loginUser(email: email, password: password)
            .then((String? error) {
          if (error != null) {
            showSnackBar(context: context, text: error);
          }
        });
      } else {
        loginDependent(email, password);
      }
    }
  }

  loginDependent(String email, String password) async {
    Map<String, dynamic> loginValido =
        await _dependentService.loginDependent(email, password);
    if (!mounted) return;
    if (loginValido['valid']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DependentScreen(userModel: loginValido['user'], idParent: loginValido['idParent'],),
        ),
      );
    } else {
      print('loginInvalido');
    }
  }
}
