# dart_tasks 📋

A command-line task manager built in **pure Dart** — no packages, no dependencies. Built as the Hour 1 capstone of the [Flutter Senior Developer Roadmap](https://github.com), covering every core Dart language concept in one cohesive project.

```
[DONE]    1. Learn Dart null safety       | Due: No due date  | Tags: no tags
[PENDING] 2. Build CLI app                | Due: 2026/04/01   | Tags: flutter, dart
[DONE]    3. Read clean architecture book | Due: No due date  | Tags: reading
[PENDING] 4. Watch Riverpod tutorial      | Due: 2026/04/05   | Tags: flutter, state
```

---

## What this covers

| Concept | Where it's used |
|---|---|
| **Null safety** `?` `?.` `??` | `Task.dueDate` — nullable field, `formattedDue` getter |
| **`var` / `final` / `const`** | Status labels are `const`, task fields are `final`, `_nextId` is `var` |
| **`List` / `Map` / `Set`**| `_tasks`, `getSummary()`, `getAllUniqueTags()` |
| **`.where()` `.map()` `.fold()`** | All query methods — no for-loops |
| **Closures** | `filterByStatus()` returns a closure that captures `status` |
| **Arrow functions `=>`** | Every single-expression method and getter |

---

## Getting started

**Requirements:** Dart SDK 3.x — [install here](https://dart.dev/get-dart)

```bash
# Clone the repo
git clone https://github.com/your-username/dart_tasks.git
cd dart_tasks

# Run
dart run main.dart

# Or paste main.dart directly into dartpad.dev
```

---

## Project structure

```
dart_tasks/
└── main.dart
    ├── constants        # statusPending, statusDone, noDate, noTags
    ├── class Task       # data model with null safety + computed getters
    ├── class TaskManager# all logic — mutations + functional queries
    └── main()           # demo usage of every feature
```

Single-file by design — this is an Hour 1 learning project. Hour 2 will split it into proper files with mixins and extensions.

---

## The Task model

```dart
class Task {
  final int          id;
  final String       title;     // non-nullable — always required
  String             status;    // mutable — changes when marked done
  final String?      dueDate;   // nullable — optional
  final List<String> tags;

  // ?. safely accesses dueDate — ?? catches the null
  String get formattedDue => dueDate?.replaceAll('-', '/') ?? noDate;

  // ternary fits cleanly in a single arrow expression
  String get tagLine => tags.isNotEmpty ? tags.join(', ') : noTags;

  @override
  String toString() =>
      '[${status.toUpperCase()}] $id. $title | Due: $formattedDue | Tags: $tagLine';
}
```

---

## API reference

### Mutations

```dart
manager.addTask('Build CLI app', dueDate: '2026-04-01', tags: ['flutter']);
manager.markDone(1);
```

### Queries

```dart
manager.getPending()        // List<Task>  — tasks with status 'pending'
manager.getDone()           // List<Task>  — tasks with status 'done'
manager.getByTag('flutter') // List<Task>  — tasks containing a tag
manager.getTitles()         // List<String>— all titles as formatted strings
manager.getDoneTitles()     // List<String>— done titles prefixed with ✓
manager.countDone()         // int         — count via .fold()
manager.getSummary()        // Map<String, int> — counts grouped by status
manager.getAllUniqueTags()  // Set<String> — deduplicated tags
manager.getTopTag()         // String?     — most used tag (nullable)
```

### Display

```dart
manager.printList(manager.getPending(), header: 'Pending');
manager.printSummary();
```

---

## Sample output

```
=== All Tasks ===
[PENDING] 1. Learn Dart null safety       | Due: No due date | Tags: no tags
[PENDING] 2. Build CLI app                | Due: 2026/04/01  | Tags: flutter, dart
[PENDING] 3. Read clean architecture book | Due: No due date | Tags: reading
[PENDING] 4. Watch Riverpod tutorial      | Due: 2026/04/05  | Tags: flutter, state
[PENDING] 5. Write unit tests             | Due: No due date | Tags: dart, testing

=== Completed ===
✓ Learn Dart null safety
✓ Read clean architecture book

=== Flutter Tasks ===
[PENDING] 2. Build CLI app           | Due: 2026/04/01 | Tags: flutter, dart
[PENDING] 4. Watch Riverpod tutorial | Due: 2026/04/05 | Tags: flutter, state

--- Summary ---
  pending  : 3 task(s)
  done     : 2 task(s)
  completed: 2 of 5
  all tags : flutter, dart, reading, state, testing
  top tag  : flutter
```

---

## Key patterns explained

**Why `const []` as a default parameter:**
```dart
void addTask(String title, {List<String> tags = const []})
```
Using `const []` means Dart reuses a single compile-time object for every call that omits `tags`. A plain `[]` would allocate a new list object on every call.

**Why `fold` instead of `reduce`:**
```dart
// reduce crashes on empty lists — fold is always safe
int countDone() =>
    _tasks.fold(0, (count, t) => t.status == statusDone ? count + 1 : count);
```

**Closures closing over outer scope:**
```dart
// filterByStatus returns a function — the returned closure
// permanently captures the value of 'status'
bool Function(Task) filterByStatus(String status) =>
    (task) => task.status == status;

List<Task> getPending() => _tasks.where(filterByStatus(statusPending)).toList();
```

---

## What's next — Hour 2

This app is the foundation for Hour 2: OOP & Functional Patterns. Planned additions:

- `Serializable` mixin — export/import tasks as JSON
- `List<Task>` extension — add `.pending`, `.done`, `.byTag()` directly on the list
- `Task.fromJson()` factory constructor
- Separate files per class

---

## Built as part of

**Flutter Senior Developer Roadmap** — a structured 20-hour plan to go from Dart beginner to senior-level Flutter engineer.

```
Hour 1  → Dart fundamentals        ← you are here
Hour 2  → OOP & functional patterns
Hour 3  → Async Dart & streams
...
Hour 20 → Capstone: full feature
```

---

