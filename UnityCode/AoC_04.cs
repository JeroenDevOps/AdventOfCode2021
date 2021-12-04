﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Mathematics;

public class AoC_04 : MonoBehaviour
{
    private List<int4> tableList = new List<int4>();
    private List<int4> tableList_original = new List<int4>();
    private List<int> exerciseInput = new List<int>{26,38,2,15,36,8,12,46,88,72,32,35,64,19,5,66,20,52,74,3,59,94,45,56,0,6,67,24,97,50,92,93,84,65,71,90,96,21,87,75,58,82,14,53,95,27,49,69,16,89,37,13,1,81,60,79,51,18,48,33,42,63,39,34,62,55,47,54,23,83,77,9,70,68,85,86,91,41,4,61,78,31,22,76,40,17,30,98,44,25,80,73,11,28,7,99,29,57,43,10};
    private int tableSize = 25;
    private int bingoCounter = 0;
    private int bingoCounter_old;
    private Vector3 bingoFoundOnTable = Vector3.zero; //Vector3 used instead of int3 because no boolean comparison possible on int3
    private int markedValue = -999;
    
    // Start is called before the first frame update
    void Start()
    {
        tableList = getTables();
        tableList_original = tableList;
    }

    void Update(){
        if(bingoFoundOnTable != Vector3.zero) {
            
        }
        if(Input.GetKeyDown(KeyCode.Backspace)){
            foreach(int4 value in getTableByTableNo(43,tableList)){
                Debug.Log(value);
            }
        }
        bool breakOnFirst = false; //set to true for exercise 4 part 1, false for exercise part 2
        bool removeBoardAfterBingo = true;
        if(Input.GetKeyDown(KeyCode.Space)){
            for(int i = 0; i < exerciseInput.Count; i++){
                if(breakOnFirst && bingoCounter >= 1) break;
                Debug.Log("Iteration " + i + " with value " + exerciseInput[i] + " with current bingoCounter " + bingoCounter);
                updateBingoTables(exerciseInput[i]);
                checkBingo();
                if(bingoCounter != bingoCounter_old){
                    Debug.Log("BINGO #" + bingoCounter + " found on " + bingoFoundOnTable);
                    int summedValues = 0;
                    for(int row = 0; row < 5; row++){
                        string stringToPrint = "Winning table row " + row + " : " ;
                        for(int column = 0; column < 5; column++){
                            foreach(int4 tableValue in getTableByTableNo((int) bingoFoundOnTable.x, tableList)){
                                if(tableValue.y == row && tableValue.z == column){
                                    stringToPrint += tableValue.w + " ";
                                    if(tableValue.w != markedValue){
                                        summedValues += tableValue.w;
                                    }
                                }
                                
                            }
                        }
                        Debug.Log(stringToPrint);
                    }
                    Debug.Log("Sum of unmarked number: " + summedValues);
                    Debug.Log("Multiplied by last called (" + exerciseInput[i] + ") = " + (summedValues * exerciseInput[i]));
                    if(removeBoardAfterBingo){
                        Debug.Log("Removed table: " + (int) bingoFoundOnTable.x);
                        foreach(int4 tableValue in getTableByTableNo((int) bingoFoundOnTable.x, tableList)){
                            tableList.Remove(tableValue);
                        }
                    }
                    i--; //repeat last interation for possible double bingo's
                }
                bingoCounter_old = bingoCounter;
            }
        }
    }

    private void updateBingoTables(int exerciseSingleInput){
        for(int j = 0; j < tableList.Count; j++){
            //if(tableList[j].w == exerciseInput[i]){
            if(tableList[j].w == exerciseSingleInput){ 
                tableList[j] = new int4(tableList[j].x, tableList[j].y, tableList[j].z, markedValue);
            }
        }
    }

    private void checkBingo(){
        for(int i = 0; i < (tableList.Count / tableSize); i++){
            List<int4> tableCurrent = new List<int4>();
            tableCurrent = getTableByTableNo(i, tableList);
            for(int row = 0; row < 5; row++){
                int counter = 0;
                foreach(int4 tableEntry in tableCurrent){
                    if(tableEntry.w == markedValue && tableEntry.y == row){
                        counter++;
                    }
                }
                if(counter == 5){
                    Debug.Log("BINGO: table " + i + " on row " + row);
                    bingoCounter++;
                    bingoFoundOnTable = new Vector3(i, row, 0);
                }
            }
            for(int column = 0; column < 5; column++){
                int counter = 0;
                foreach(int4 tableEntry in tableCurrent){
                    if(tableEntry.w == markedValue && tableEntry.z == column){
                        counter++;
                    }
                }
                if(counter == 5){
                    Debug.Log("BINGO: table " + i + " on column " + column);
                    bingoCounter++;
                    bingoFoundOnTable = new Vector3(i, 0, column);
                }
            }
        }

        
    }

    private List<int4> getTables(){
        List<int> tableInput = allTableInput();
        List<int4> fullTableList = new List<int4>();
        int tableNumber = 0;
        int listIterator = 0;
        for(int i = 0; i < (tableInput.Count / tableSize); i++){
            for(int row = 0; row < 5; row++){
                for(int column = 0; column < 5; column++){
                    int noInList = listIterator;
                    fullTableList.Add(new int4(tableNumber, row, column, tableInput[noInList] ));
                    listIterator++;
                }
            }
            tableNumber++;
        }
        return fullTableList;
    }

    private List<int4> getTableByTableNo(int tableNo, List<int4> inputTableList){
        List<int4> requestedTableList = new List<int4>();
        foreach(int4 tableEntry in inputTableList){
                if(tableEntry.x == tableNo){
                    requestedTableList.Add(tableEntry);
                }
            }

        return requestedTableList;
    }


    List<int> allTableInput(){
        List<int> tableInts = new List<int>{
            57,12,60,96,93,
            73,87,63,70,91,
            74,32,43,67,46,
            59,34,5,35,82,
            53,40,55,29,1,

            48,71,59,45,63,
            13,42,23,95,39,
            84,82,10,29,4,
            16,91,32,92,62,
            99,33,20,21,3,

            51,20,32,30,90,
            86,88,89,1,73,
            5,64,78,81,22,
            95,50,7,27,17,
            39,82,46,35,92,

            2,65,21,77,97,
            50,46,38,99,82,
            22,1,24,63,70,
            8,32,80,98,35,
            57,67,25,81,18,

            64,7,26,44,14,
            42,71,19,22,0,
            4,36,51,25,6,
            69,59,90,15,88,
            85,65,32,76,70,

            8,69,75,42,44,
            64,25,72,71,34,
            2,94,81,14,38,
            97,89,59,23,88,
            57,70,13,1,51,

            93,94,26,11,35,
            63,57,84,10,92,
            12,29,78,65,64,
            54,75,61,50,81,
            13,90,2,66,99,

            10,21,39,24,56,
            90,49,25,80,59,
            41,72,47,74,79,
            9,89,42,92,31,
            20,1,32,58,83,

            81,11,58,2,69,
            79,23,60,8,63,
            94,9,0,45,34,
            36,31,61,71,74,
            51,48,59,99,70,

            66,47,88,16,18,
            35,75,54,26,77,
            23,55,33,3,19,
            82,71,57,80,45,
            22,8,40,76,20,

            8,5,95,86,76,
            49,21,82,78,77,
            12,38,61,85,4,
            14,54,42,40,39,
            69,66,1,0,7,

            85,66,96,45,64,
            25,55,36,76,37,
            82,61,29,47,54,
            73,94,3,59,24,
            71,62,31,98,79,

            84,10,60,61,97,
            75,90,95,6,8,
            93,89,65,70,80,
            35,15,46,55,77,
            52,3,74,39,36,

            80,24,59,71,52,
            17,43,45,8,6,
            58,22,32,46,98,
            48,3,56,31,77,
            97,28,55,0,76,

            51,98,12,49,19,
            28,94,9,97,85,
            5,78,47,93,24,
            67,0,37,81,76,
            77,48,15,69,50,

            34,45,5,80,14,
            82,42,63,2,86,
            3,95,54,74,69,
            46,27,49,92,66,
            0,85,98,83,17,

            41,99,93,62,96,
            90,30,10,5,94,
            98,32,83,78,25,
            76,27,29,19,35,
            58,91,34,31,3,

            31,1,24,96,36,
            58,12,59,57,92,
            84,5,55,49,41,
            54,72,70,95,88,
            66,50,22,35,15,

            35,57,69,13,93,
            34,62,28,26,36,
            6,64,47,74,45,
            0,32,19,33,44,
            65,25,90,91,1,

            57,96,70,15,89,
            7,65,29,12,34,
            40,25,36,81,86,
            58,39,27,79,59,
            19,91,47,6,11,

            60,74,67,87,68,
            80,53,42,91,89,
            11,19,8,78,31,
            4,6,30,10,90,
            64,41,27,59,12,

            45,0,86,81,34,
            8,29,53,12,32,
            89,74,64,26,96,
            60,13,87,35,73,
            52,69,23,46,40,

            43,35,1,59,40,
            63,74,7,53,94,
            39,42,8,84,27,
            66,65,46,82,80,
            61,76,13,31,45,

            38,4,51,76,5,
            36,57,3,86,84,
            83,37,60,67,52,
            0,70,7,19,72,
            62,99,9,75,58,

            95,47,78,27,14,
            50,82,17,15,22,
            1,76,64,73,71,
            24,26,42,79,55,
            36,40,43,81,59,

            13,7,60,49,87,
            30,31,99,19,82,
            91,88,53,96,97,
            37,11,47,32,81,
            86,94,45,71,38,

            64,42,19,6,69,
            33,2,61,98,55,
            20,48,5,82,56,
            78,11,65,59,74,
            85,72,1,54,29,

            76,56,84,34,83,
            16,26,33,50,3,
            85,20,87,31,51,
            62,7,28,96,8,
            81,57,89,44,58,

            92,49,58,8,45,
            47,89,48,91,71,
            53,67,37,59,88,
            24,69,96,61,16,
            2,6,68,95,60,

            99,60,39,96,0,
            62,14,77,70,47,
            72,98,66,42,58,
            85,19,12,23,44,
            68,28,51,94,82,

            59,32,45,99,92,
            96,36,30,87,9,
            61,54,71,94,22,
            76,4,62,20,2,
            40,18,43,70,44,

            22,54,77,12,3,
            5,11,41,19,58,
            49,51,75,24,63,
            42,20,43,92,69,
            62,36,15,25,80,

            93,40,48,21,10,
            0,83,86,31,65,
            52,7,17,67,72,
            95,28,63,99,47,
            51,22,85,55,44,

            43,26,86,80,94,
            93,66,84,90,61,
            91,58,71,73,89,
            9,72,81,48,54,
            11,60,36,25,70,

            33,42,73,20,69,
            15,12,27,72,14,
            93,30,89,86,22,
            77,25,80,85,74,
            66,78,0,49,82,

            37,84,46,86,39,
            55,31,96,17,43,
            12,33,45,97,9,
            44,57,25,77,78,
            5,73,81,35,58,

            19,41,87,94,59,
            97,84,78,52,77,
            70,15,91,53,1,
            71,47,82,35,99,
            25,55,58,39,29,

            29,74,31,73,72,
            23,10,83,63,25,
            18,26,79,35,65,
            59,44,98,45,20,
            67,7,87,28,11,

            83,89,92,55,72,
            32,6,78,93,49,
            66,77,5,60,61,
            85,57,29,97,65,
            86,84,48,20,75,

            85,82,83,66,86,
            64,61,77,38,84,
            1,68,4,18,72,
            56,97,37,98,74,
            44,14,78,52,93,

            30,73,72,24,51,
            78,3,97,39,5,
            90,42,58,96,17,
            33,95,44,27,1,
            80,16,84,54,99,

            92,88,79,14,10,
            24,52,80,46,51,
            11,31,35,53,25,
            44,54,63,33,93,
            87,38,15,64,4,

            14,25,61,40,95,
            34,17,97,38,26,
            64,90,45,91,65,
            8,50,23,11,74,
            32,33,22,88,28,

            8,32,94,72,74,
            27,29,22,2,76,
            58,54,80,5,35,
            36,24,83,59,25,
            21,31,48,39,4,

            56,13,22,53,72,
            61,60,81,87,86,
            7,74,98,28,11,
            67,38,91,23,0,
            42,84,24,3,47,

            29,98,43,45,30,
            86,50,15,60,11,
            18,34,8,67,24,
            36,97,69,27,79,
            35,87,52,55,61,

            40,50,30,75,72,
            1,62,85,21,11,
            80,10,91,7,2,
            27,31,73,25,29,
            63,65,55,87,23,

            12,68,47,77,76,
            98,30,6,51,80,
            22,85,88,99,24,
            35,90,82,18,37,
            17,27,34,54,43,

            85,46,35,16,45,
            4,6,96,9,61,
            44,90,64,29,50,
            76,38,69,80,28,
            27,23,51,8,7,

            72,8,62,61,83,
            0,30,92,29,7,
            86,28,54,52,5,
            32,97,82,68,31,
            76,69,22,12,13,

            66,67,1,36,94,
            80,99,49,47,38,
            76,95,30,13,19,
            83,21,45,44,43,
            29,91,14,20,98,

            8,80,3,82,99,
            62,41,47,6,27,
            12,72,76,81,36,
            30,7,67,90,5,
            85,31,83,49,19,

            25,91,86,47,27,
            69,74,20,17,97,
            59,45,87,28,75,
            49,94,63,33,9,
            8,66,2,30,32,

            69,58,41,84,5,
            27,2,22,65,88,
            63,96,90,17,85,
            26,52,86,20,8,
            3,9,59,50,57,

            80,85,90,5,56,
            66,57,76,65,62,
            81,74,15,38,32,
            0,75,61,16,79,
            96,50,8,86,1,

            52,21,98,54,94,
            73,90,87,58,50,
            38,39,30,69,82,
            55,12,81,48,29,
            93,23,91,47,28,

            92,14,3,1,19,
            18,27,91,62,86,
            61,80,49,53,97,
            77,98,52,0,8,
            17,54,85,59,51,

            49,45,38,70,33,
            96,18,63,5,99,
            65,58,29,91,19,
            78,7,98,39,17,
            31,15,13,35,75,

            55,50,58,96,94,
            67,72,4,40,90,
            59,31,15,78,81,
            1,80,56,34,20,
            27,52,88,75,53,

            0,5,91,65,72,
            53,42,4,50,25,
            13,52,81,79,92,
            46,89,55,58,95,
            19,77,30,36,18,

            38,97,86,69,44,
            70,52,14,19,29,
            9,36,96,24,80,
            84,22,32,72,48,
            28,3,46,42,87,

            94,93,31,33,38,
            21,30,34,69,35,
            1,10,55,79,57,
            54,28,44,78,73,
            8,20,45,41,23,

            32,13,49,80,68,
            41,95,84,74,57,
            15,61,5,77,67,
            53,54,29,51,75,
            24,66,36,88,90,

            74,49,19,2,66,
            94,45,30,84,37,
            7,24,22,87,60,
            13,40,57,9,1,
            56,42,92,67,27,

            29,7,97,22,36,
            80,77,92,3,67,
            48,54,73,51,41,
            28,8,55,24,4,
            13,11,66,5,86,

            76,16,8,71,92,
            23,61,53,27,43,
            25,6,17,32,64,
            40,69,21,84,93,
            89,30,55,90,41,

            86,22,81,13,33,
            35,87,82,77,71,
            96,65,37,62,51,
            16,72,36,93,23,
            84,44,26,66,27,

            4,73,52,35,43,
            39,9,96,34,70,
            19,67,38,10,54,
            21,7,36,13,90,
            84,28,59,57,75,

            55,7,32,68,97,
            10,56,46,28,66,
            74,81,18,73,26,
            44,76,13,35,61,
            90,36,45,64,58,

            96,62,97,87,95,
            45,78,38,84,41,
            91,19,88,25,22,
            12,27,31,92,5,
            15,83,7,53,71,

            31,17,96,6,47,
            3,90,27,89,75,
            53,39,62,82,13,
            52,34,23,83,87,
            19,67,50,98,84,

            96,3,70,17,42,
            50,74,65,53,31,
            52,80,18,26,77,
            29,57,95,25,81,
            88,92,55,13,28,

            63,34,56,1,4,
            40,97,10,5,50,
            96,55,15,68,37,
            43,33,89,72,3,
            11,88,44,86,2,

            65,44,24,34,41,
            1,68,67,6,26,
            27,88,73,25,9,
            55,56,16,48,29,
            33,18,77,3,94,

            91,75,35,33,56,
            96,19,69,81,53,
            25,14,32,74,22,
            24,6,89,42,90,
            9,2,77,67,20,

            19,97,36,78,71,
            16,26,99,23,92,
            10,68,74,90,88,
            30,60,96,11,34,
            8,76,35,53,22,

            84,15,76,31,63,
            1,34,96,70,35,
            66,57,71,26,61,
            83,41,74,85,60,
            16,28,30,23,49,

            72,88,56,92,86,
            12,44,71,47,30,
            39,53,4,46,45,
            38,5,9,35,25,
            8,61,13,50,82,

            62,92,49,21,95,
            70,47,73,74,56,
            17,89,0,39,60,
            42,99,13,63,67,
            43,16,11,20,84,

            13,30,59,84,12,
            52,88,79,62,29,
            99,39,95,55,70,
            80,46,31,89,69,
            74,71,65,3,38,

            47,86,21,24,22,
            0,62,69,38,59,
            27,10,41,81,92,
            14,51,35,13,17,
            30,15,7,71,70,

            25,26,29,66,32,
            68,46,77,45,86,
            14,15,90,40,22,
            6,36,17,76,1,
            80,55,83,98,79,

            98,76,58,27,39,
            45,90,56,46,69,
            10,41,54,82,25,
            94,86,89,33,79,
            16,30,87,24,83,

            66,28,93,91,68,
            71,51,22,10,42,
            29,20,77,17,8,
            55,39,89,72,12,
            98,78,65,48,41,

            49,25,80,64,99,
            90,9,40,76,63,
            60,93,46,4,27,
            17,0,42,33,28,
            59,26,18,69,75,

            35,0,76,58,31,
            87,17,42,13,33,
            70,67,61,52,12,
            59,85,64,80,1,
            4,73,99,55,48,

            40,73,94,80,90,
            9,93,17,51,62,
            96,0,57,82,47,
            86,27,64,95,84,
            16,99,37,41,44,

            8,96,31,26,50,
            20,69,75,82,89,
            94,42,38,78,35,
            83,13,45,62,43,
            97,14,34,17,47,

            35,88,38,7,97,
            8,79,51,74,26,
            60,22,53,5,33,
            63,23,69,0,83,
            21,44,91,95,18,

            64,77,4,0,15,
            80,66,9,16,5,
            75,8,18,40,91,
            72,1,49,60,97,
            14,24,34,65,92,

            84,75,31,56,55,
            17,92,48,45,89,
            88,52,10,90,47,
            91,97,6,39,79,
            99,65,11,42,93,

            7,82,10,88,49,
            11,66,54,3,53,
            4,73,71,42,92,
            22,75,84,16,48,
            5,94,79,96,45,

            20,87,16,25,9,
            15,70,19,72,56,
            71,37,69,2,62,
            76,97,41,8,92,
            40,65,86,0,32,

            81,48,14,75,4,
            70,30,6,74,62,
            15,28,55,22,63,
            36,32,35,86,71,
            29,47,59,18,78,

            10,35,27,14,64,
            43,19,86,71,36,
            32,79,9,51,91,
            17,67,26,41,56,
            15,1,95,13,65,

            74,79,22,30,46,
            80,55,57,14,37,
            59,88,40,83,56,
            63,10,97,64,7,
            77,61,53,91,20,

            53,81,13,72,67,
            79,10,71,11,8,
            0,99,60,20,4,
            7,45,89,66,98,
            50,36,80,57,5,

            5,7,35,4,29,
            28,65,31,86,33,
            66,98,75,13,92,
            38,67,80,46,11,
            9,15,57,71,32,

            21,33,22,77,5,
            0,6,59,37,69,
            50,45,32,60,96,
            9,39,28,56,57,
            34,46,43,52,25,

            67,11,21,53,60,
            52,58,54,94,47,
            84,46,72,81,16,
            31,51,23,36,97,
            80,43,75,99,79


        };
        
        return tableInts;
    }

}
