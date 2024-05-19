class Person {
   String id;
   String username;
   String email;

   @override
  String toString() {
    return 'Person{id: $id, username: $username, email: $email, birthDate: $birthDate, phone: $phone, sex: $sex, image: $image}';
  }

   String birthDate;
   String phone;
   String sex;
   String image;

   Person({
    required String id,
    required String username,
    required String email,
    required String birthDate,
    required String phone,
    required String sex,
    required String image,
  })  : id = id,
        username = username,
        email = email,
        birthDate = birthDate,
        phone = phone,
        sex = sex,
        image = image;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['IdUser'],
      username: json['Username'],
      email: json['E-mail'],
      birthDate: json['Birthdate'],
      phone: json['Phone'],
      sex: json['Sex'],
      image: json['imageAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdUser': id,
      'Username': username,
      'E-mail': email,
      'Birthdate': birthDate,
      'Phone': phone,
      'Sex': sex,
      'imageAvatar': image,
    };
  }




}
