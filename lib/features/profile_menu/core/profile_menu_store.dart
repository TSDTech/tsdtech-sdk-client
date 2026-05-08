import 'package:mobx/mobx.dart';

part 'profile_menu_store.g.dart';

class ProfileMenuStore = _ProfileMenuStore with _$ProfileMenuStore;

abstract class _ProfileMenuStore with Store {
	@observable
	String name = '';

	@observable
	String secondName = '';

	@observable
	String email = '';

	@observable
	String password = '';

	@observable
	String phone = '';

	@observable
	String cpf = '';

	@action
	void setUserData({
		required String name,
		required String secondName,
		required String email,
		required String phone,
		required String cpf,
	}) {
		this.name = name;
		this.secondName = secondName;
		this.email = email;
		this.phone = phone;
		this.cpf = cpf;
	}

	@action
	Future<void> updateProfile() async {
		// Implementar chamada ao backend para atualizar cadastro
		// Exemplo: await api.updateProfile(...);
	}
}