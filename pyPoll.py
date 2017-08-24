# script to go through pollin results in order to help the god Old Uncle Cleetus

# import what we want
#import what we need
import os
import csv
import sys
from contextlib import redirect_stdout

# WE WILL try lists this time
voters = []
counties = []
candidates = []

# setup input file path 

fElect = ''
cho = 0
print("for sample processing choose 1 ")
print("for real processing choose 2  ")
cho = input("Choose the Files to process from above: ")
fName = ""
headerRow = True

if int(cho) == 1:
    fName = 'election_data_1.csv'

elif int(cho) == 2:
    fName = 'election_data_2.csv'

else:
    print ("My king you have chosen wisely but can't work with it!")
    sys.exit()

fInPath = os.path.join("InData",fName)

print("Will be processing - " + fInPath)

with open (fInPath, newline="") as inFile:
    fReader = csv.reader(inFile, delimiter = ',')
    if (headerRow):
        next(fReader)
        headerRow = True
    
    for rec in fReader:
        # create voter list
        voters.append(rec[0])

        # create counties list
        counties.append(rec[1])

        # create candidate list
        candidates.append(rec[2])

# create a list of unique candidates
finCandidates = []
dupCandidates = []
tempVotes =  []
totVotes = []
tally = 0
candVotes = []

#print ("Len : " + str(len(candidates)))
for cand in candidates:
    # check if first element
    if (len(finCandidates) == 0):
        # add very first element 
        finCandidates.append(cand)
        totVotes.append(1)
    else:
        if (cand in finCandidates):
            #do nothing
            dupCandidates.append(cand)
        else:
            finCandidates.append(cand)

#print("Lenght finCadidates: " +str(len(finCandidates)))
#   print (finCandidates)
vote = ''
totalVotes = 0

#loop thru for the candidates votes
for rec in finCandidates:
    tally = 0
    #print('rec: ' + rec)
    for vote in candidates:
        #print("Vote: " + vote)
        
        if (rec == vote):
            tally += 1
    
    # add tally to the list
    totVotes.append(tally)

#print (totVotes)
# for some reason I have to delete the first elemet WHY?
del totVotes[0]

candVotes = zip(finCandidates, totVotes)
for rec in candVotes:
    totalVotes += rec[1]

print(" ")
print("------------------------------")
print("        Election Results")
print("------------------------------")
print ("Total Votes:" + str(totalVotes))
print("------------------------------")
print("")
candVotes = zip(finCandidates, totVotes)
for rec in candVotes:
    #percVotes = int((rec[1]/totalVotes)*100)
    print(rec[0] + ': '+ str(int((rec[1]/totalVotes)*100)) +  "% ("+ str(rec[1])+")")
print("")
print("------------------------------------------")
print("Creating - OutData/UncleCleetusResults.txt")
print("-------------------------------------------")

#finally export to txt file
with open('OutData/UncleCleetusResults.txt', 'w') as f:
    with redirect_stdout(f):
        print("------------------------------")
        print("        Election Results")
        print("------------------------------")
        print ("    Total Votes:" + str(totalVotes))
        print("------------------------------")
        candVotes = zip(finCandidates, totVotes)
        for rec in candVotes:
            #percVotes = int((rec[1]/totalVotes)*100)
            print("    " + rec[0] + ': '+ str(round((rec[1]/totalVotes)*100, 2)) +  "% ("+ str(rec[1])+")")
            print("------------------------------")   