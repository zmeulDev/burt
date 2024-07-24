import 'package:burt/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExpenseService {
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Expense expense) async {
    await expenseCollection.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    await expenseCollection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String expenseId) async {
    await expenseCollection.doc(expenseId).delete();
  }

  Stream<List<Expense>> getExpensesByUser(String userId) {
    return expenseCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromDocument(doc)).toList();
    });
  }

  Future<Expense> getExpenseById(String expenseId) async {
    DocumentSnapshot doc = await expenseCollection.doc(expenseId).get();
    return Expense.fromDocument(doc);
  }

  Stream<Expense> getExpenseStreamById(String expenseId) {
    return expenseCollection.doc(expenseId).snapshots().map((doc) => Expense.fromDocument(doc));
  }
}
