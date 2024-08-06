class Todo {
  final String id;
  final String title;
  final String desc;
  final bool check;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.check,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? desc,
    bool? check,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      check: check ?? this.check,
    );
  }
}

class TodoRequirement {
  final bool titleIsError;
  final bool descIsError;

  TodoRequirement({
    required this.titleIsError,
    required this.descIsError,
  });
}
