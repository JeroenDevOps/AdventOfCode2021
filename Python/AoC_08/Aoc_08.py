import csv

testdata = []
with open('AoC_08_testdata.csv', newline = '') as csvfile:
    table = csv.reader(csvfile, delimiter= '\n')
    for row in table:
        testdata.append(row)

realdata = []
with open('AoC_08_data.csv', newline = '') as csvfile:
    table = csv.reader(csvfile, delimiter= '\n')
    for row in table:
        realdata.append(row)
     
# data = testdata
data = realdata     


## part 1
# values with unique segment amounts: 1, 4, 7, 8
value0 = [1,2,3,5,6,7]
value1 = [3,6]
value2 = [1,3,4,5,7]
value3 = [1,3,4,6,7]
value4 = [2,3,4,6]
value5 = [1,2,4,6,7]
value6 = [1,2,4,5,6,7]
value7 = [1,3,6]
value8 = [1,2,3,4,5,6,7]
value9 = [1,2,3,4,6,7]
values = [value0, value1, value2, value3, value4, value5, value6, value7, value8, value9]
uniqueLengths = [len(values[1]), len(values[4]), len(values[7]), len(values[8])]
# for i in range(len(values)):
#     print(i, "  ", len(values[i]))
count = 0
for row in data:
    for i in row:
        count += sum(len(k) in uniqueLengths for k in (str(i).split('|'))[1].split(' '))
print(count)




## part 2
def setTranslationTable(fullInputString, fullOutputString):
    translationTable = [[0,''],[1,''], [2,''], [3,''], [4,''],[5,''],[6,''],[7,''],[8,''],[9,'']]
    iteration = 0
    
    waitUniques = True
    isTableComplete = False
    inputList = [input for input in fullInputString.split(' ')]
    
    while isTableComplete == False:
        iteration += 1
        if iteration >= 20:
            isTableComplete = True
            
        if translationTable[1][1] != '' and translationTable[4][1] != '' and translationTable[7][1] != '' and translationTable[8][1] != '':
                waitUniques = False
        for i in range(len(inputList)):
            input = ''.join(sorted(inputList[i]))
            if len(input) in uniqueLengths and waitUniques == True:
                if len(input) == 2:
                    translationTable[1] = [1, input]
                elif len(input) == 4:
                    translationTable[4] = [4, input]
                elif len(input) == 3:
                    translationTable[7] = [7, input]
                elif len(input) == 7:
                    translationTable[8] = [8, input]
            elif waitUniques == False:
                if len(input) == 6:
                    # values: 0 or 6 or 9
                    matches = 0
                    for letter in list(input):
                        if letter in translationTable[1][1]:
                            matches += 1
                    if matches == len(translationTable[1][1]):
                        matches = 0
                        for letter in list(input):
                            if letter in translationTable[4][1]:
                                matches += 1
                        if matches == len(translationTable[4][1]):
                            translationTable[9] = [9, input]
                        else :
                            translationTable[0] = [0, input]
                    else :
                        translationTable[6] = [6, input]
                elif len(input) == 5:
                    # values: 2 or 3 or 5
                    matches = 0
                    for letter in list(input):
                        if letter in translationTable[1][1]:
                            matches += 1
                    if matches == len(translationTable[1][1]):
                        translationTable[3] = [3, input]
                    elif translationTable[6][1] != '':
                        matches = 0
                        for letter in list(input):
                            if letter in translationTable[6][1]:
                                matches += 1
                        if matches == len(input):
                            translationTable[5] = [5, input]
                        else :
                            translationTable[2] = [2, input]
        if isTableComplete == False:
            filledCount = 0
            for content in translationTable:
                if content[1] != '':
                    filledCount += 1
            if filledCount == 10:
                isTableComplete = True 
    
    ## use translation table  
    outputList = [output for output in fullOutputString.split(' ')]
    outputRealString = ''
    for i in range(len(outputList)):
        output = ''.join(sorted(outputList[i]))
        for value in translationTable:
            if value[1] == output:
                outputRealString += str(value[0])
                break
    return int(outputRealString)
                    

returnValue = 0
sumValue = 0
for row in data:
    dataValues = (str(row).removeprefix('[\'').removesuffix('\']')).split(' | ')
    returnValue = setTranslationTable(dataValues[0], dataValues[1])
    sumValue += returnValue
    
print (sumValue)
    