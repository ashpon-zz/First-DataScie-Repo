
#import what we need
import os
import csv
import sys
from contextlib import redirect_stdout

# setup inpuy file path 
#inDir = "c:\Rutgers\python\homework\python-challenge"
fInPath_1 = os.path.join( "InData",'budget_data_1.csv')
fInPath_2 = os.path.join( "InData",'budget_data_2.csv')
fBud = ''
cho = 0
print("for sample processing choose 1 for: " + fInPath_1)
print("for other  processing choose 2 for: " + fInPath_2)
cho = input("Choose the Files to process from above: ")
fPath = ""

if int(cho) == 1:
    fBud = open(fInPath_1, 'r')
    #Open file budget 1 and process it
    fBudReader = csv.reader(fBud, delimiter=',')
elif int(cho) == 2:
    fBud = open(fInPath_2, 'r')
    #Open file budget 2 and process it
    fBudReader = csv.reader(fBud, delimiter=',')
else:
    print ("My king you have chosen wisely but can't work with it!")
    sys.exit()



# skip the header
next(fBudReader)

# define Global Vars
fData = list(fBudReader)
fBud_count = len(fData)
fBud.close()
total = 0 
runAvg = 0
recNum = 0
frstRec = True 
xRev = 0.00
minRev = 0.00
priorMonth = ""
maxMonth = ""
minMonth = ""

# as time permits, add a directory scanner and create a dynamic selection array
# this will help determine all available data sets to work on

if int(cho) == 1:
    fBud = open(fInPath_1, 'r')
    #Open file budget 1 and process it
    fBudReader = csv.reader(fBud, delimiter=',')
    fPath = fInPath_1
elif int(cho) == 2:
    fBud = open(fInPath_2, 'r')
    #Open file budget 2 and process it
    fBudReader = csv.reader(fBud, delimiter=',')
    fPath =fInPath_2

# # open file again? why though
# fBud = open("pyBank/budget_data_2.csv", 'r')
# fBudReader = csv.reader(fBud, delimiter=',')
next(fBudReader)

print(" ")
print ("-------------------------------------------------------------")
print ("            Welcome to my Revenue Analyzer                   ")
print ("-------------------------------------------------------------")
print ("        Processing Data file: " + fPath) 
print ("-------------------------------------------------------------")

for rec in fBudReader:
    total += float(rec[1])
    
    #if very first record / second line skip this
    if (frstRec):
        xRev = (rec[1])
        minRev = (rec[1])
        priorMonth = rec[0]
        maxMonth = rec[0]
        minMonth = rec[0]
        runAvg = 0.00
        #print("First Record: " + rec[0] + " " + str(xRev) + " " + str(minRev))
        priorRev = float(rec[1])
        frstRec = False
    else:
        #print("In Else Part 1 " + str(xRev) + " "+ str(rec[1]))
    
        if (float(minRev)  >= float(rec[1])):
            minRev = rec[1]
            minMonth = rec[0]

        if(float(xRev) <= float(rec[1])):
            xRev = rec[1]
            maxMonth = rec[0]
    
        runAvg += (float(rec[1]) - priorRev) 
        priorRev = float(rec[1])
        recNum += 1

print("                   Financial Analysis               ")
print("--------------------------------------------------------------")
print(" ")
print("                Total Months: " + str(fBud_count))
print("               Total Revenue: $"+ str(total))
print("      Average Revenue Change: "+  str(runAvg/recNum))
print("Greatest Increase In Revenue: " + maxMonth + " " + str(xRev))
print("Greatest Decrease In Revenue: " + minMonth + " " + str(minRev))
print(" ")
print ("-------------------------------------------------------------")
print ("Creating - OutData/RevAnalysis.txt")
print ("-------------------------------------------------------------")

# export a txt file with results
# may not have been something exactly on your minds guys but trying this
with open('OutData/RevAnalysis.txt', 'w') as f:
    with redirect_stdout(f):
        print (" ")
        print ("-------------------------------------------------------------")
        print ("            Welcome to my Revenue Analyzer                   ")
        print ("-------------------------------------------------------------")
        print ("        Processing Data file: " + fPath) 
        print ("-------------------------------------------------------------")
        print ("                   Financial Analysis               ")
        print ("-------------------------------------------------------------")
        print (" ")
        print ("                Total Months: " + str(fBud_count))
        print ("               Total Revenue: $"+str(total))
        print ("      Average Revenue Change: "+ str(runAvg/recNum))
        print ("Greatest Increase In Revenue: " + maxMonth + " " + str(xRev))
        print ("Greatest Decrease In Revenue: " + minMonth + " " + str(minRev))
        print (" ")
        print ("-------------------------------------------------------------")