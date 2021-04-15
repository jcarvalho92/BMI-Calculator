//
//  DbHelper.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2020-12-11.
//  Copyright © 2020 Juliana de Carvalho. All rights reserved.
//  Student Id: 30113760
//  Final Test

import Foundation

class DBHelper{

  init()
  {
      db = openDatabase()
      //dropStepsCountTable()
      createTable()

  }
    
   var db:OpaquePointer?
  func openDatabase() -> OpaquePointer?
  {
      var db: OpaquePointer? = nil
      if sqlite3_open(dataFilePath(), &db) != SQLITE_OK
      {
          sqlite3_close(db)
          print("error opening database")
          return nil
      }
      else
      {
          print("Successfully opened connection to database")
          return db
      }
  }

  func createTable() {
    //creating BMI table
      let createTableString = "CREATE TABLE IF NOT EXISTS BMI " +
                              "(NAME CHAR(100), AGE INT, GENDER CHAR(6), CHOOSENUNIT CHAR(8), WEIGHT DOUBLE , HEIGHT DOUBLE, DATE CHAR(20), BMISCORE DOUBLE );"
      var createTableStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
      {
          if sqlite3_step(createTableStatement) == SQLITE_DONE
          {
              print("bmi table created.")
          } else {
              print("bmi table could not be created.")
          }
      } else {
          print("CREATE TABLE statement could not be prepared.")
      }
      sqlite3_finalize(createTableStatement)
    //creating StepsCount table
    let createStepsTableString = "CREATE TABLE IF NOT EXISTS StepsCount " +
                            "(STEPS DOUBLE, DATE CHAR(20), GOAL DOUBLE );"
    var createStepsTableStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, createStepsTableString, -1, &createStepsTableStatement, nil) == SQLITE_OK
    {
        if sqlite3_step(createStepsTableStatement) == SQLITE_DONE
        {
            print("StepsCount table created.")
        } else {
            print("StepsCount table could not be created.")
        }
    } else {
        print("CREATE TABLE statement could not be prepared.")
    }
    sqlite3_finalize(createStepsTableStatement)
  }

  func dropTable() {
      let dropTableString = "DROP TABLE IF EXISTS BMI ;"
      var dropTableStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, dropTableString, -1, &dropTableStatement, nil) == SQLITE_OK
      {
          if sqlite3_step(dropTableStatement) == SQLITE_DONE
          {
              print("bmi table droped.")
          } else {
              print("bmi table could not be droped.")
          }
      } else {
          print("DROP TABLE statement could not be prepared.")
      }
      sqlite3_finalize(dropTableStatement)
    
    let dropStepsTableString = "DROP TABLE IF EXISTS StepsCount ;"
    var dropStepsTableStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, dropStepsTableString, -1, &dropStepsTableStatement, nil) == SQLITE_OK
    {
        if sqlite3_step(dropStepsTableStatement) == SQLITE_DONE
        {
            print("stepsCount table droped.")
        } else {
            print("stepsCount table could not be droped.")
        }
    } else {
        print("DROP TABLE statement could not be prepared.")
    }
    sqlite3_finalize(dropStepsTableStatement)
  }
    
  func dropStepsCountTable() {
      
      let dropStepsTableString = "DROP TABLE IF EXISTS StepsCount ;"
      var dropStepsTableStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, dropStepsTableString, -1, &dropStepsTableStatement, nil) == SQLITE_OK
      {
          if sqlite3_step(dropStepsTableStatement) == SQLITE_DONE
          {
              print("stepsCount table droped.")
          } else {
              print("stepsCount table could not be droped.")
          }
      } else {
          print("DROP TABLE statement could not be prepared.")
      }
      sqlite3_finalize(dropStepsTableStatement)
  }

  func insert(name: String, age: Int, gender: String, choosenUnit: String, weight: Double, height: Double, date: String, bmiScore: Double)
  {
      
      let insertStatementString = "INSERT INTO BMI (NAME, AGE, GENDER, CHOOSENUNIT, WEIGHT, HEIGHT, DATE, BMISCORE) VALUES ('\(name)', \(age), '\(gender)', '\(choosenUnit)', \(weight), \(height), '\(date)', \(bmiScore));"
      var insertStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
          if sqlite3_step(insertStatement) == SQLITE_DONE {

              print("Successfully inserted row.")
          } else {
              print("Could not insert row.")
          }
      } else {
          print("INSERT statement could not be prepared.")
      }
      sqlite3_finalize(insertStatement)
  }
    
  func insertSteps(steps: Double, date: String, goal: Double)
  {
    
        let insertStatementString = "INSERT INTO StepsCount (STEPS, DATE, GOAL)  " +
            " SELECT \(steps), '\(date)', '\(goal)' " +
            " WHERE NOT EXISTS(SELECT 1 FROM StepsCount WHERE date = '\(date)' );"

    
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {

                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
  }

    func update(newWeight:Double, newDate:String, newScore: Double, name: String, date: String)
    {

        let updateStatementString = "UPDATE BMI SET WEIGHT = '\(newWeight)' , BMISCORE = '\(newScore)' , DATE = '\(newDate)'    WHERE NAME = '\(name)' AND DATE = '\(date)' ;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
  
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    func updateGoal(goal: Double)
    {

        let updateStatementString = "UPDATE StepsCount SET GOAL = '\(goal)'   ;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
  
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    
  func read() -> [BMI] {
      let queryStatementString = "SELECT NAME, AGE, GENDER, CHOOSENUNIT, WEIGHT, HEIGHT, DATE, BMISCORE FROM BMI "
      var queryStatement: OpaquePointer? = nil
      var bmiData : [BMI] = []
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
            let age = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
            let gender = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
            let choosenUnit = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
            let weight = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
            let height = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
            let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
            let bmiScore = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
            bmiData.append(BMI(name: name, age: Int(age)!, gender: gender, choosenUnit: choosenUnit, weight: Double(weight)!, height: Double(height)!, date: date, bmiScore: Double(bmiScore)!))
            print("Query Result:")
            print("\(bmiScore) | \(weight) | \(height)")
          }
      } else {
          print("SELECT statement could not be prepared")
      }
      sqlite3_finalize(queryStatement)
      return bmiData
  }
    
    func readSteps() -> [Step] {
        let queryStatementString = "SELECT  STEPS, DATE, GOAL FROM StepsCount "
        var queryStatement: OpaquePointer? = nil
        var stepData : [Step] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
             
              let steps = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
              let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
              let goal = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                stepData.append(Step(qtySteps: Double(steps)!, dateSteps: date, goal: Double(goal)!))
              //print("Query Result:")
              //print("\(steps) | \(date)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return stepData
    }

    func delete(name:String, weight: Double, date: String) {
      let deleteStatementStirng = "DELETE FROM BMI WHERE NAME = '\(name)' AND WEIGHT = '\(weight)' AND DATE = '\(date)' ;"
      var deleteStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
              print("Successfully deleted row.")
          } else {
              print("Could not delete row.")
          }
      } else {
          print("DELETE statement could not be prepared")
      }
      sqlite3_finalize(deleteStatement)
  }
 

  func dataFilePath() -> String {
          let urls = FileManager.default.urls(for:
              .documentDirectory, in: .userDomainMask)
          var url:String?
          url = urls.first?.appendingPathComponent("data.plist").path
          return url!
  }
}
