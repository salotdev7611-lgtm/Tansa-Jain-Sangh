import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import 'Add_Relation.dart';


class Person {
  String id;
  String name;
  String mobile;
  String? imagePath;
  String? relation; // Relation from the "self" node
  List<String> childrenIds;
  String? parentId;
  String? spouseId; // New: ID of the spouse

  Person({
    required this.id,
    required this.name,
    required this.mobile,
    this.imagePath,
    this.relation,
    this.childrenIds = const [],
    this.parentId,
    this.spouseId, // Initialize spouseId
  });

  Person copyWith({
    String? name,
    String? mobile,
    String? imagePath,
    String? relation,
    List<String>? childrenIds,
    String? parentId,
    String? spouseId, // Include spouseId in copyWith
  }) {
    return Person(
      id: id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      imagePath: imagePath ?? this.imagePath,
      relation: relation ?? this.relation,
      childrenIds: childrenIds ?? this.childrenIds,
      parentId: parentId ?? this.parentId,
      spouseId: spouseId ?? this.spouseId, // Copy spouseId
    );
  }
}

class FamilyTreePainter2 extends CustomPainter {
  final Map<String, Offset> nodePositions; // Center positions of nodes
  final Map<String, List<String>> treeStructure; // ParentId to list of childIds
  final Map<String, String?> spouseLinks; // personId to spouseId

  // Constants for node dimensions (needed for calculating connection points)
  static const double nodeWidth = 100.0;
  static const double nodeHeight = 140.0;
  static const double nodeRadius = 30.0; // From CircleAvatar

  FamilyTreePainter2({
    required this.nodePositions,
    required this.treeStructure,
    required this.spouseLinks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey[700]! // Slightly darker color
      ..strokeWidth = 2 // Slightly thicker line
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Optional: round caps for cleaner ends

    // --- Draw Parent-Child Lines (90-degree connections) ---
    treeStructure.forEach((parentId, childrenIds) {
      final parentCenter = nodePositions[parentId];
      if (parentCenter != null) {
        // Calculate the bottom-center point of the parent node
        final parentBottomCenter = Offset(parentCenter.dx-10, parentCenter.dy + nodeHeight / 2 - nodeRadius); // Below the circle

        // If the parent has a spouse, we might want to draw the line from the middle of the couple.
        // For simplicity here, we draw from the parent's bottom.
        // A more advanced layout would compute a "marriage line" midpoint.

        // Draw a short vertical line down from the parent
        // This is where children lines will branch off
        final verticalLineFromParentEnd = Offset(parentBottomCenter.dx, parentBottomCenter.dy + 30); // Extend 30 units down

        // Draw this initial vertical segment
        canvas.drawLine(parentBottomCenter, verticalLineFromParentEnd, paint);

        // Sort children to ensure consistent line drawing if their horizontal order matters
        childrenIds.sort((a, b) => (nodePositions[a]?.dx ?? 0).compareTo(nodePositions[b]?.dx ?? 0));

        // Draw horizontal line to connect all children to the parent's vertical line
        if (childrenIds.isNotEmpty) {
          final firstChildCenter = nodePositions[childrenIds.first];
          final lastChildCenter = nodePositions[childrenIds.last];

          if (firstChildCenter != null && lastChildCenter != null) {
            final childLineY = verticalLineFromParentEnd.dy; // Same Y-coordinate for the horizontal segment

            // Determine the start and end X for the horizontal line connecting all children
            // This horizontal line should span from the leftmost child's X to the rightmost child's X,
            // or at least from the parent's vertical line to the furthest child.
            final childrenMinX = childrenIds
                .map((id) => nodePositions[id]?.dx ?? 0)
                .reduce((a, b) => a < b ? a : b);
            final childrenMaxX = childrenIds
                .map((id) => nodePositions[id]?.dx ?? 0)
                .reduce((a, b) => a > b ? a : b);

            final horizontalLineStartX = (parentBottomCenter.dx < childrenMinX)
                ? parentBottomCenter.dx
                : (childrenMinX - (nodeWidth / 2) + 10); // Extend a bit left of child
            final horizontalLineEndX = (parentBottomCenter.dx > childrenMaxX)
                ? parentBottomCenter.dx
                : (childrenMaxX + (nodeWidth / 2) - 10); // Extend a bit right of child

            // Draw the horizontal line from parent's vertical line to cover all children
            // This is a simplified approach, a common marriage line would be the ideal.
            // Let's connect parent's stem to the 'mid' point of children, and then extend.
            // A common approach is a shared horizontal line for all siblings.
            // For simplicity, connect parent's vertical stem to the horizontal line spanning children.

            // Find the horizontal position of the parent's vertical stem
            double parentStemX = parentBottomCenter.dx;

            // Draw horizontal line segment from parent's stem to the left-most child's X
            // Then from parent's stem to the right-most child's X
            for (String childId in childrenIds) {
              final childCenter = nodePositions[childId];
              if (childCenter != null) {
                final childTopCenter = Offset(childCenter.dx-10, childCenter.dy - nodeHeight / 2 + nodeRadius); // Above the circle

                // Draw horizontal segment from parent's vertical stem to child's X
                canvas.drawLine(Offset(parentStemX, verticalLineFromParentEnd.dy), Offset(childTopCenter.dx, verticalLineFromParentEnd.dy), paint);

                // Draw vertical segment from horizontal line to child
                canvas.drawLine(Offset(childTopCenter.dx, verticalLineFromParentEnd.dy), childTopCenter, paint);
              }
            }
          }
        }
      }
    });

    // --- Draw Spouse Lines (Horizontal connections) ---
    spouseLinks.forEach((personId, spouseId) {
      if (spouseId != null && nodePositions.containsKey(personId) && nodePositions.containsKey(spouseId)) {
        final personCenter = nodePositions[personId]!;
        final spouseCenter = nodePositions[spouseId]!;

        // Determine the two points for the horizontal line segment between spouses.
        // We want the line to connect their nearest horizontal edges.
        // Assuming person is to the left of spouse, or vice versa, based on rendering order.

        // Connect the right edge of the left person to the left edge of the right person.
        Offset startPoint, endPoint;
        if (personCenter.dx < spouseCenter.dx) {
          // Person is to the left of spouse
          startPoint = Offset(personCenter.dx + nodeWidth / 2 - nodeRadius, personCenter.dy-50); // Right edge of person's circle
          endPoint = Offset(spouseCenter.dx - nodeWidth / 2 + nodeRadius, spouseCenter.dy-50); // Left edge of spouse's circle
        } else {
          // Spouse is to the left of person
          startPoint = Offset(spouseCenter.dx + nodeWidth / 2 - nodeRadius, spouseCenter.dy-50); // Right edge of spouse's circle
          endPoint = Offset(personCenter.dx - nodeWidth / 2 + nodeRadius, personCenter.dy-50); // Left edge of person's circle
        }
        canvas.drawLine(startPoint, endPoint, paint);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever data or positions change
  }
}


class FamilyTreePainter extends CustomPainter {
  final Map<String, Offset> nodePositions;
  final Map<String, List<String>> treeStructure; // Parent to children
  final Map<String, String?> spouseLinks; // New: personId to spouseId

  FamilyTreePainter({
    required this.nodePositions,
    required this.treeStructure,
    required this.spouseLinks, // Pass spouse links
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw parent-child lines (vertical connections)
    treeStructure.forEach((parentId, childrenIds) {
      final parentPosition = nodePositions[parentId];
      if (parentPosition != null) {
        // Find children and draw lines from parent to each child
        // This still assumes a simple vertical connection.
        // For children with two parents, lines would ideally merge from parents to a common point, then down to children.
        // For simplicity, we'll draw from parent to child directly for now.
        for (var childId in childrenIds) {
          final childPosition = nodePositions[childId];
          if (childPosition != null) {
            // Draw a line from parent's bottom-center to child's top-center
            final startPoint = Offset(parentPosition.dx, parentPosition.dy + 50); // Assuming node height is 100
            final endPoint = Offset(childPosition.dx, childPosition.dy - 50); // Assuming node height is 100
            canvas.drawLine(startPoint, endPoint, paint);
          }
        }
      }
    });

    // Draw spouse lines (horizontal connections)
    spouseLinks.forEach((personId, spouseId) {
      if (spouseId != null && nodePositions.containsKey(personId) && nodePositions.containsKey(spouseId)) {
        final personPosition = nodePositions[personId]!;
        final spousePosition = nodePositions[spouseId]!;

        // Draw a horizontal line between the centers of the spouse nodes
        // Adjust these offsets to place the line correctly, e.g., slightly below the center
        // or directly between their centers.
        final startPoint = Offset(personPosition.dx + 50, personPosition.dy); // Assuming node width 100
        final endPoint = Offset(spousePosition.dx - 50, spousePosition.dy); // Assuming node width 100
        canvas.drawLine(startPoint, endPoint, paint);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Import your custom widgets
// import 'person_node.dart';
// import 'family_tree_painter.dart';
// import 'person.dart';

class FamilyTreePage2 extends StatefulWidget {
  @override
  _FamilyTreePage2State createState() => _FamilyTreePage2State();
}

class _FamilyTreePage2State extends State<FamilyTreePage2> {
  Map<String, Person> _people = {};
  String? _rootPersonId;

  Map<String, Offset> _nodePositions = {};
  GlobalKey _treeViewKey = GlobalKey();

  bool isSpouse = false;

  // Constants for node dimensions and spacing
  static const double nodeWidth = 180.0;
  static const double nodeHeight = 160.0;
  static const double horizontalSpacing = 0.0; // Increased spacing for spouses
  static const double verticalSpacing = 10.0;

  @override
  void initState() {
    super.initState();
    _initializeFamilyTree();
  }

  void _initializeFamilyTree() {
    var uuid = Uuid();
    String selfId = uuid.v4();
    _people[selfId] = Person(id: selfId, name: 'Self', relation: 'Self',mobile: "+917485964152");
    _rootPersonId = selfId;
    setState(() {});
  }

  // --- CRUD Operations ---

  void _addPerson({required String parentId, String? name, String? relation,String? mobile,required bool isSpouse}) async {
    print("All Members : ${_people.toString()}");
    var uuid = Uuid();
    String newPersonId = uuid.v4();

    String? personName = name;
    String? personMobile = mobile;
    String? personRelation = relation;
    String? imagePath;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempName = '';
        String tempRelation = '';
        String tempMobile = '';
        return AlertDialog(
          title: Text(isSpouse ? 'Add Spouse' : 'Add New Person'),
          content: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => tempName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Mobile'),
                onChanged: (value) => tempMobile = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Checkbox(
                        value: isSpouse,
                        onChanged: (value) {
                          setState(() {
                            isSpouse = value!;
                          });
                        },
                      );
                    },
                  ),
                  Text(
                      "Spouse"
                  )
                ],
              ),
              if (!isSpouse) // Relation is more relevant for children/parents
                TextField(
                  decoration: InputDecoration(labelText: 'Relation (e.g., Son, Daughter)'),
                  onChanged: (value) => tempRelation = value,
                ),
              SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () async {
              //     final picker = ImagePicker();
              //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              //     if (pickedFile != null) {
              //       imagePath = pickedFile.path;
              //     }
              //   },
              //   child: Text('Pick Image'),
              // ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (tempName.isNotEmpty) {
                  personName = tempName;
                  personMobile = tempMobile;
                  personRelation = isSpouse ? tempRelation : tempRelation; // Default relation for spouse
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );

    if (personName != null && personName!.isNotEmpty) {
      setState(() {
        _people[newPersonId] = Person(
          id: newPersonId,
          name: personName!,
          mobile: personMobile!,
          imagePath: imagePath,
          relation: personRelation,
        );

        if (isSpouse) {
          // Link the new person as spouse to the parentId
          _people[parentId] = _people[parentId]!.copyWith(spouseId: newPersonId);
          _people[newPersonId] = _people[newPersonId]!.copyWith(spouseId: parentId);
        } else {
          // Link new person as child
          _people[newPersonId] = _people[newPersonId]!.copyWith(parentId: parentId);
          _people[parentId] = _people[parentId]!.copyWith(
            childrenIds: List.from(_people[parentId]!.childrenIds)..add(newPersonId),
          );
        }
      });
    }
  }

  void _editPerson(String personId) async {
    Person? personToEdit = _people[personId];
    if (personToEdit == null) return;

    String? newName = personToEdit.name;
    String? newRelation = personToEdit.relation;
    String? newImagePath = personToEdit.imagePath;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${personToEdit.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: personToEdit.name),
                onChanged: (value) => newName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Relation'),
                controller: TextEditingController(text: personToEdit.relation),
                onChanged: (value) => newRelation = value,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    newImagePath = pickedFile.path;
                  }
                },
                child: Text('Change Image'),
              ),
              if (newImagePath != null)
                Image.file(File(newImagePath!), height: 50, width: 50, fit: BoxFit.cover),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _people[personId] = personToEdit.copyWith(
                    name: newName,
                    relation: newRelation,
                    imagePath: newImagePath,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removePerson(String personId) {
    if (personId == _rootPersonId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot remove the root person.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove this person and all their descendants? This will also unlink their spouse if any.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Remove'),
              onPressed: () {
                setState(() {
                  _deletePersonRecursive(personId);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePersonRecursive(String personId) {
    // Unlink spouse if exists
    String? spouseId = _people[personId]?.spouseId;
    if (spouseId != null && _people.containsKey(spouseId)) {
      _people[spouseId] = _people[spouseId]!.copyWith(spouseId: null);
    }

    // Remove from parent's children list
    String? parentId = _people[personId]?.parentId;
    if (parentId != null && _people.containsKey(parentId)) {
      _people[parentId] = _people[parentId]!.copyWith(
        childrenIds: List.from(_people[parentId]!.childrenIds)..remove(personId),
      );
    }

    // Recursively delete children
    List<String> childrenToDelete = List.from(_people[personId]?.childrenIds ?? []);
    for (String childId in childrenToDelete) {
      _deletePersonRecursive(childId);
    }

    _people.remove(personId);
    _nodePositions.remove(personId);
  }

  // --- Layout Logic ---
  // This is the most complex part and will require significant changes.
  // We need to group spouses together and then place their children below them.

  List<Widget> _buildFamilyTreeNodes() {
    List<Widget> nodes = [];
    _nodePositions.clear(); // Clear previous positions

    if (_rootPersonId == null || !_people.containsKey(_rootPersonId!)) {
      return nodes;
    }

    // A more sophisticated layout algorithm is needed here.
    // For now, we'll aim for a simple layered approach, grouping spouses.

    // This map will store which persons have already been placed to avoid duplicates
    Set<String> placedPersons = {};

    // Queue for BFS traversal
    Queue<String> queue = Queue<String>();
    queue.add(_rootPersonId!);
    placedPersons.add(_rootPersonId!);

    // A map to store the level of each person/couple
    Map<String, int> levels = {_rootPersonId!: 0};

    // Store a list of persons/couples at each level for layout
    Map<int, List<String>> personsAtLevel = {0: [_rootPersonId!]};

    // Calculate levels for all reachable people first
    while (queue.isNotEmpty) {
      String currentPersonId = queue.removeFirst();
      int currentLevel = levels[currentPersonId]!;

      // Add spouse to queue if not already processed and belongs to this level
      String? spouseId = _people[currentPersonId]?.spouseId;
      if (spouseId != null && _people.containsKey(spouseId) && !placedPersons.contains(spouseId)) {
        levels[spouseId] = currentLevel; // Spouse is at the same level
        placedPersons.add(spouseId);
        // Do not add spouse to queue for level calculation, but ensure they are included in layout
        // A better approach might be to have "couple nodes" in the layout queue.
      }

      // Add children to the next level
      for (String childId in _people[currentPersonId]?.childrenIds ?? []) {
        if (!placedPersons.contains(childId)) {
          levels[childId] = currentLevel + 1;
          queue.add(childId);
          placedPersons.add(childId);
          personsAtLevel.update(currentLevel + 1, (list) => list..add(childId),
              ifAbsent: () => [childId]);
        }
      }
    }

    // Now, iterate through levels and arrange nodes.
    double currentY = 50.0; // Starting Y position

    int maxLevel = levels.values.isEmpty ? 0 : levels.values.reduce(max);

    for (int level = 0; level <= maxLevel; level++) {
      List<String> currentLevelPersons = [];
      // Collect all people at this level, including their spouses if they have one.
      levels.forEach((personId, lvl) {
        if (lvl == level) {
          if (!currentLevelPersons.contains(personId)) {
            currentLevelPersons.add(personId);
            String? spouseId = _people[personId]?.spouseId;
            if (spouseId != null && _people.containsKey(spouseId) && levels[spouseId] == level) {
              if (!currentLevelPersons.contains(spouseId)) {
                currentLevelPersons.add(spouseId);
              }
            }
          }
        }
      });

      // Sort persons by their original ID for consistent horizontal ordering (optional)
      currentLevelPersons.sort();

      // Calculate the total width required for this level
      double totalLevelWidth = currentLevelPersons.length * nodeWidth +
          (currentLevelPersons.length - 1) * horizontalSpacing;

      // Center the level horizontally
      double currentX = (MediaQuery.of(context).size.width - totalLevelWidth) / 2;
      if (currentX < 20) currentX = 20; // Ensure some left padding

      // Keep track of spouse pairs to ensure they are laid out next to each other
      Set<String> placedThisLevel = {};

      for (String personId in currentLevelPersons) {
        if (placedThisLevel.contains(personId)) {
          continue; // Already processed as part of a couple
        }

        Person person = _people[personId]!;
        String? spouseId = person.spouseId;
        Person? spouse;
        if (spouseId != null && _people.containsKey(spouseId) && !placedThisLevel.contains(spouseId)) {
          spouse = _people[spouseId]!;
        }

        // Position the current person
        double nodeX = currentX;
        double nodeY = currentY;

        _nodePositions[personId] = Offset(nodeX + nodeWidth / 2, nodeY + nodeHeight / 2);
        nodes.add(
          Positioned(
            left: nodeX,
            top: nodeY,
            child: PersonNode(
              id: person.id,
              name: person.name,
              mobile: person.mobile,
              imagePath: person.imagePath,
              relation: person.relation,
              onAddChild: () => _addPerson(parentId: person.id,isSpouse: isSpouse),
              onEditPerson: () => _editPerson(person.id),
              onRemovePerson: () => _removePerson(person.id),
            ),
          ),
        );
        placedThisLevel.add(personId);
        currentX += nodeWidth + (horizontalSpacing / 2); // Space for person + half spacing for potential spouse

        // Position the spouse if exists and not yet placed
        if (spouse != null) {
          double spouseNodeX = currentX;
          _nodePositions[spouse!.id] = Offset(spouseNodeX + nodeWidth / 2, nodeY + nodeHeight / 2);
          nodes.add(
            Positioned(
              left: spouseNodeX,
              top: nodeY,
              child: PersonNode(
                id: spouse.id,
                name: spouse.name,
                mobile: spouse.mobile,
                imagePath: spouse.imagePath,
                relation: spouse.relation,
                onAddChild: () => _addPerson(parentId: spouse!.id,isSpouse: isSpouse),
                onEditPerson: () => _editPerson(spouse!.id),
                onRemovePerson: () => _removePerson(spouse!.id),
              ),
            ),
          );
          placedThisLevel.add(spouse.id);
          currentX += nodeWidth + (horizontalSpacing / 2); // Space for spouse + half spacing
        }
        currentX += horizontalSpacing; // Additional spacing between couples/individuals
      }
      currentY += nodeHeight + verticalSpacing; // Move to the next level
    }

    return nodes;
  }

  // Helper to get the tree structure for the painter
  Map<String, List<String>> _getTreeStructure() {
    Map<String, List<String>> structure = {};
    _people.forEach((id, person) {
      if (person.childrenIds.isNotEmpty) {
        structure[id] = person.childrenIds;
      }
    });
    return structure;
  }

  // New helper for spouse links for the painter
  Map<String, String?> _getSpouseLinks() {
    Map<String, String?> links = {};
    _people.forEach((id, person) {
      if (person.spouseId != null) {
        // Add link only once for a pair (e.g., from person to spouse, not spouse to person too)
        if (!links.containsKey(person.spouseId)) {
          links[id] = person.spouseId;
        }
      }
    });
    return links;
  }

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    // Recalculate dimensions based on current people data
    // double treeWidth = _calculateTreeWidth();
    // double treeHeight = _calculateTreeHeight();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Fam",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        actions: [
          GestureDetector(
              onTap: (){
                Get.to(AddRelation(),transition: Transition.fadeIn,duration: Duration(milliseconds: 400));
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: appColors.selectedColor.value
                  ),
                  child: SvgPicture.string(AppSvgs.add,height: 30,width: 30,color: AppColors.white,))),
          SizedBox(width: 16,)
        ],
      ),
      body: Column(
        children: [

        ],
      ),
      // body: SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: Container(
      //       key: _treeViewKey,
      //       width: treeWidth,
      //       height: treeHeight,
      //       child: Stack(
      //         children: [
      //           // Custom painter for lines
      //           CustomPaint(
      //             painter: FamilyTreePainter2(
      //               nodePositions: _nodePositions,
      //               treeStructure: _getTreeStructure(),
      //               spouseLinks: _getSpouseLinks(), // Pass spouse links
      //             ),
      //             child: Container(),
      //           ),
      //           // Render all the person nodes
      //           ..._buildFamilyTreeNodes(),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_rootPersonId == null) {
      //       _initializeFamilyTree();
      //     } else {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('Long-press a person to add a child or spouse, or to edit/remove.')),
      //       );
      //     }
      //   },
      //   child: Icon(Icons.info), // Changed to info, as add is via long press
      // ),
    );
  }

  // --- Dimension Calculations ---
  // These need to be updated to account for spouse groups.

  double _calculateTreeWidth() {
    // This is still a simplification. A proper layout algorithm would determine this.
    // For now, let's estimate based on the widest level considering spouses.
    int maxNodesOrCouplesInLevel = 0;
    Map<int, List<String>> personsAtLevel = {};

    if (_rootPersonId != null && _people.containsKey(_rootPersonId!)) {
      Queue<String> queue = Queue<String>();
      queue.add(_rootPersonId!);
      Map<String, int> levels = {_rootPersonId!: 0};
      Set<String> visited = { _rootPersonId! }; // Track visited for BFS

      while(queue.isNotEmpty) {
        String currentId = queue.removeFirst();
        int currentLevel = levels[currentId]!;

        // Add spouse if exists and at the same level
        String? spouseId = _people[currentId]?.spouseId;
        if (spouseId != null && _people.containsKey(spouseId) && !visited.contains(spouseId)) {
          levels[spouseId] = currentLevel;
          visited.add(spouseId);
        }

        // Add to personsAtLevel for width calculation
        personsAtLevel.update(currentLevel, (list) => list..add(currentId), ifAbsent: () => [currentId]);
        if (spouseId != null && _people.containsKey(spouseId) && levels[spouseId] == currentLevel) {
          // Ensure spouse is also counted for the level if they are truly at this level
          if (!personsAtLevel[currentLevel]!.contains(spouseId)) {
            personsAtLevel[currentLevel]!.add(spouseId);
          }
        }


        for (String childId in _people[currentId]!.childrenIds) {
          if (!visited.contains(childId)) {
            levels[childId] = currentLevel + 1;
            queue.add(childId);
            visited.add(childId);
          }
        }
      }
    }

    personsAtLevel.forEach((level, personsInThisLevel) {
      // Count effective "slots" - a single person is one slot, a couple is two slots
      // This is a rough heuristic.
      int effectiveSlots = 0;
      Set<String> processedForWidth = {};
      for (String personId in personsInThisLevel) {
        if (!processedForWidth.contains(personId)) {
          effectiveSlots++; // Count the person
          processedForWidth.add(personId);
          String? spouseId = _people[personId]?.spouseId;
          if (spouseId != null && personsInThisLevel.contains(spouseId) && !processedForWidth.contains(spouseId)) {
            effectiveSlots++; // Count the spouse if they are also in this level
            processedForWidth.add(spouseId);
          }
        }
      }
      if (effectiveSlots > maxNodesOrCouplesInLevel) {
        maxNodesOrCouplesInLevel = effectiveSlots;
      }
    });

    return (maxNodesOrCouplesInLevel * nodeWidth) + (maxNodesOrCouplesInLevel - 1) * horizontalSpacing + 100;
  }

  double _calculateTreeHeight() {
    int maxDepth = 0;
    if (_rootPersonId != null && _people.containsKey(_rootPersonId!)) {
      Queue<String> queue = Queue<String>();
      queue.add(_rootPersonId!);
      Map<String, int> levels = {_rootPersonId!: 0};
      Set<String> visited = {_rootPersonId!}; // Track visited nodes

      while(queue.isNotEmpty) {
        String currentId = queue.removeFirst();
        int currentLevel = levels[currentId]!;
        if (currentLevel > maxDepth) {
          maxDepth = currentLevel;
        }

        // Process spouse for level if exists and not visited, but spouse doesn't increase depth
        String? spouseId = _people[currentId]?.spouseId;
        if (spouseId != null && _people.containsKey(spouseId) && !visited.contains(spouseId)) {
          levels[spouseId] = currentLevel; // Spouse is at the same level
          visited.add(spouseId);
        }

        for (String childId in _people[currentId]!.childrenIds) {
          if (!visited.contains(childId)) {
            levels[childId] = currentLevel + 1;
            queue.add(childId);
            visited.add(childId);
          }
        }
      }
    }
    return (maxDepth + 1) * (nodeHeight + verticalSpacing) + 100;
  }
}

class PersonNode extends StatefulWidget {
  final String id;
  final String name;
  final String mobile;
  final String? imagePath;
  final String? relation;
  final VoidCallback onAddChild;
  final VoidCallback onEditPerson;
  final VoidCallback onRemovePerson;

  const PersonNode({
    Key? key,
    required this.id,
    required this.name,
    required this.mobile,
    this.imagePath,
    this.relation,
    required this.onAddChild,
    required this.onEditPerson,
    required this.onRemovePerson,
  }) : super(key: key);

  @override
  State<PersonNode> createState() => _PersonNodeState();
}

class _PersonNodeState extends State<PersonNode> {

  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showNodeOptions(context);
      },
        child: SizedBox(
          width: 140,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Bottom green container
              Container(
                margin: EdgeInsets.only(top: 40), // Move down to make space for circle
                decoration: BoxDecoration(
                  color: appColors.selectedColor.value,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .body2Bold
                            .copyWith(color: AppColors.white, fontSize: 16),
                      ),
                      if (widget.relation != null) SizedBox(height: 4),
                      if (widget.relation != null)
                        Text(
                          widget.relation!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .body2Light
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),

              // Circle Avatar Overlapping
              Positioned(
                top: -5,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/images/person.jpg"),
                  ),
                ),
              )
            ],
          ),
        ),

    );
  }

  void _showNodeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text('Add Child'),
                onTap: () {
                  Navigator.pop(bc);
                  widget.onAddChild();
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Person'),
                onTap: () {
                  Navigator.pop(bc);
                  widget.onEditPerson();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove Person'),
                onTap: () {
                  Navigator.pop(bc);
                  widget.onRemovePerson();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}