import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:foodlove/models/task.dart';
import 'dart:collection';
import 'package:foodlove/models/profile.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String userName;
  String url;
  bool pro;

  Future<void> setName() async {
    String name =
        loggedInUser.email.substring(0, loggedInUser.email.indexOf('@'));
    await _firestore
        .collection("profiles")
        .document(loggedInUser.email)
        .setData({'email': loggedInUser.email,'name' : name,'pro' : false});
  }

  Future<void> setProfile(name, url) async {
    name = name[0].toUpperCase() + name.substring(1);
    await _firestore
        .collection("profiles")
        .document(loggedInUser.email)
        .updateData({
      'name': name,
      'url': url,
    });
    await getProfile();
    notifyListeners();
  }

  Future<void> setPro() async {
    await _firestore
        .collection("profiles")
        .document(loggedInUser.email)
        .updateData({
      'pro': true,
    });
  }

  Future<void> getProfile() async {
    final items = await _firestore.collection('profiles').getDocuments();
    for (var message in items.documents) {
      if (message.data['email'] == loggedInUser.email) {
        final profile = Profile(
            name: message.data['name'],
            url: message.data['url'],
            email: message.data['email'],
            pro: message.data['pro']);
        userName = message.data['name'];
        url = message.data['url'];
        pro = message.data['pro'];
      }
    }
    notifyListeners();
  }

  String get getEmail {
    return loggedInUser.email;
  }

  Future<void> getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    await listStream();
  }

  void signOut() {
    _auth.signOut();
    print('sign out');
    url = null;
    pro = false;
    userName = '';
    _tasks.clear();
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  String get userEmail {
    return loggedInUser.email;
  }

  int get taskCount {
    return _tasks.length;
  }

  Future<void> addTask(String newTaskTitle, String newTaskTitleQ) async {
    await _firestore
        .collection('list')
        .document(DateTime.now().toString())
        .setData({
      'email': loggedInUser.email,
      'name': newTaskTitle,
      'quantity': newTaskTitleQ,
    });
    await listStream();
    notifyListeners();
  }

  Future<void> copyTask(String newTaskTitle, String newTaskTitleQ) async {
    await _firestore
        .collection('list')
        .document(DateTime.now().toString())
        .setData({
      'email': loggedInUser.email,
      'name': newTaskTitle,
      'quantity': newTaskTitleQ,
    });
  }

  Future<void> copyStream() async {
    await listStream();
    notifyListeners();
  }

  Future<void> listStream() async {
    _tasks.clear();
    final items = await _firestore.collection('list').getDocuments();
    for (var message in items.documents) {
      if (message.data['email'] == loggedInUser.email) {
        final task = Task(
            name: message.data['name'],
            quantity: message.data['quantity'],
            objectId: message.documentID);
        _tasks.add(task);
      }
    }
    notifyListeners();
  }

  Future<void> deleteTask(String objectId, Task task) async {
    _tasks.remove(task);
    await _firestore.collection('list').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        if (ds.documentID == objectId) {
          ds.reference.delete();
        }
      }
    });
    print('delete');
    notifyListeners();
  }

  Future<void> clearList() async {
    await _firestore.collection('list').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        if (ds.data['email'] == loggedInUser.email) {
          ds.reference.delete();
        }
      }
    });
    print('clear');
    _tasks.clear();
    notifyListeners();
  }
}
