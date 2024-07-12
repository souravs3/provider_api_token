class Attendee {
  final String salutation;
  final String firstName;
  final String middleName;
  final String lastName;
  final String name;
  final String email;
  final String city;
  final String country;
  final String photo;
  final String designation;
  final String affiliation;

  Attendee({
    required this.salutation,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.city,
    required this.country,
    required this.photo,
    required this.designation,
    required this.affiliation,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      salutation: json['salutation'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      name: json['name'],
      email: json['email'],
      city: json['city'],
      country: json['country'],
      photo: json['photo'],
      designation: json['designation'],
      affiliation: json['affiliation'],
    );
  }
}
