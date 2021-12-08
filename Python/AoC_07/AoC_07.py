import csv
import numpy as np

with open('AoC_07_data.csv', newline = '') as csvfile:
    table = csv.reader(csvfile, delimiter=',')
    for row in table:
        realData = row 
for i in range(len(realData)):
    realData[i] = int (realData[i])   
    
testData = [16,1,2,0,4,2,7,1,2,14]

# data = testData
data = realData
data = np.array(data)

## part 1
target = np.percentile(data, 50)
print ("target = " + str(target))

fuel = 0
for i in range(len(data)):
    fuel = fuel + abs(data[i] - target)
print ("Fuel consumed = " + str(fuel))

## part 2
fuelList = []
for target in range(min(data), max(data)):
    fuel = 0
    for i in range(len(data)):
        distance = abs(data[i] - target)
        for dist in range(distance+1):
            fuel = fuel + dist
    fuelList.append(fuel)
print("minimum fuel: ", min(fuelList) )



