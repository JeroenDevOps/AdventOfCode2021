# import csv
# with open('AoC_06_data.csv', newline = '') as csvfile:
#     realData = csv.reader(csvfile, delimiter=',')
    
testData = [3,4,3,1,2]
realData = [1,1,1,1,1,5,1,1,1,5,1,1,3,1,5,1,4,1,5,1,2,5,1,1,1,1,3,1,4,5,1,1,2,1,1,1,2,4,3,2,1,1,2,1,5,4,4,1,4,1,1,1,4,1,3,1,1,1,2,1,1,1,1,1,1,1,5,4,4,2,4,5,2,1,5,3,1,3,3,1,1,5,4,1,1,3,5,1,1,1,4,4,2,4,1,1,4,1,1,2,1,1,1,2,1,5,2,5,1,1,1,4,1,2,1,1,1,2,2,1,3,1,4,4,1,1,3,1,4,1,1,1,2,5,5,1,4,1,4,4,1,4,1,2,4,1,1,4,1,3,4,4,1,1,5,3,1,1,5,1,3,4,2,1,3,1,3,1,1,1,1,1,1,1,1,1,4,5,1,1,1,1,3,1,1,5,1,1,4,1,1,3,1,1,5,2,1,4,4,1,4,1,2,1,1,1,1,2,1,4,1,1,2,5,1,4,4,1,1,1,4,1,1,1,5,3,1,4,1,4,1,1,3,5,3,5,5,5,1,5,1,1,1,1,1,1,1,1,2,3,3,3,3,4,2,1,1,4,5,3,1,1,5,5,1,1,2,1,4,1,3,5,1,1,1,5,2,2,1,4,2,1,1,4,1,3,1,1,1,3,1,5,1,5,1,1,4,1,2,1]

#data = testData
data = realData

## Part 1
# x= 0
# days = 256
# while x < days:
#     for i in range(len(data)):
#         if data[i] == 0:
#             data[i] = 6
#             data.append(8)
#         else:
#             data[i] = int (data[i]) - 1
#     x = x + 1
# print(len(data))


## Part 2: obviously stolen
from collections import Counter

lifes = dict(Counter(data))

days = 256
for day in range(1, days+1):
    lifes = {l: (0 if lifes.get(l+1) is None else lifes.get(l+1)) for l in range(-1, 8)}
    # make all 8s -1 because we create new fish with 8 after it reaches 0
    lifes[8] = lifes[-1]
    # add new lifes to that are exhausted
    lifes[6] += lifes[-1]
    # reset exhausted lifes
    lifes[-1] = 0 

print("\n" + str (sum(lifes.values())) + "\n")