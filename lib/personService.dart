import 'package:ornek_test/DatabaseHelper.dart';
import 'package:ornek_test/person.dart';

class PersonService {
  static Future<bool> createPerson(Person model)async{
    bool isSaved=false;
    int inserted=await Databasehelper.insert("person", model);
    isSaved = inserted==1 ? true :false; 
    
    return isSaved;
  }

  static Future<List<Person>> getPersons()async{

    List<Map<String,dynamic>> result = await Databasehelper.query("person");


    return result.map((e)=>Person.fromJson(e)).toList();

  }
}

