

```
# import what we need
import pandas as pd
import numpy as np
import json  as js
```


```
# read json file 
fName = ('./Resources/purchase_data.json')
# Read with pandas
df = pd.read_json(fName)
```


```
# get file details - uncomment as required
df.head(5)
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
    </tr>
  </tbody>
</table>
</div>



# Player Count


```
# get total number of players
# df["SN"].value_counts() 
# 573
totPlayers = len(df.groupby(["SN"]).sum())
totPlayers
# 573
```




    573



# Purchasing Analysis (Total)


```
# Purchase analysis 
# Number of unique items - revisit this?
# df["Item ID"].value_counts() 
# 183
numItems = len((df.groupby("Item ID").count()))
numItems
# 183
# np.unique(df["Item ID"])
# Purchase analysis 
# Average Purchase Prise
avgPrise = round((df["Price"].mean()), 2)
avgPrise
#2.93
# Purchase analysis
# Total Number of Purchases
totPurch = df["Item ID"].count()
totPurch
# Purchase analysis
# Total Revenue
totRev = round(df["Price"].sum(), 2)
totRev
print("Total Number of Items    " + "Average Purchase Price  " + "Total Purchases  " + "Total Revenue")
print("--------------------------------------------------------------------------------------------")
print("                   "+ str(numItems) + "                     " + str(avgPrise)  + "              " 
      + str(totPurch) + "        " + str(totRev))
print("--------------------------------------------------------------------------------------------")
```

    Total Number of Items    Average Purchase Price  Total Purchases  Total Revenue
    --------------------------------------------------------------------------------------------
                       183                     2.93              780        2286.33
    --------------------------------------------------------------------------------------------
    

# Gender Demographics


```
## Gender Demographics
# percentage & Count of Male Players
maleCount = (df["Gender"] == "Male").sum()
malePerc = round((maleCount / totPurch) * 100, 2)
## Gender Demographics
# percentage & Count of female Players
femaleCount = (df["Gender"] == "Female").sum()
femalePerc = round((femaleCount / totPurch) * 100, 2)
## Gender Demographics
# percentage & Count of Other non-disclosed Players
otherCount = ((df["Gender"] != "Female") & (df["Gender"] != "Male")).sum()
otherPerc = round((otherCount / totPurch) * 100, 2)
print ("Male Count    " + "Male Percentage     " + "Female Count     "+ "Female Percentage     "+ "Other Count     " + "Other Percentage  ")
print ("-------------------------------------------------------------------------------------------------------------------------------")
print ("      ", maleCount,"            ", malePerc, "            ", femaleCount,"               ", 
       femalePerc,"             ", otherCount, "               ",otherPerc)
print ("-------------------------------------------------------------------------------------------------------------------------------")
```

    Male Count    Male Percentage     Female Count     Female Percentage     Other Count     Other Percentage  
    -------------------------------------------------------------------------------------------------------------------------------
           633              81.15              136                 17.44               11                 1.41
    -------------------------------------------------------------------------------------------------------------------------------
    

# Purchasing Analysis by Gender


```
# Purchasing Analysis Gender 
# create gender specific dataframes
maleOnly = df[df["Gender"] == "Male"]
femaleOnly = df[df["Gender"] == "Female"]
otherGender = df[(df["Gender"] != "Female") & (df["Gender"] != "Male")]
# Purchasing Analysis Gender 
# average purchase price by gender
avgMalePrice = 0.00
avgFemMalePrice = 0.00
avgOtherPrice = 0.00
avgMalePrice = round((maleOnly["Price"].sum()/maleOnly["Price"].count()), 2)
avgFemMalePrice = round((femaleOnly["Price"].sum()/femaleOnly["Price"].count()), 2)
avgOtherPrice = round((otherGender["Price"].sum()/otherGender["Price"].count()), 2)
# Purchasing Analysis Gender 
# Total Purchase Value by gender
totMaleValue   = round((maleOnly["Price"].sum()), 2)
totfemaleValue = round((femaleOnly["Price"].sum()), 2)
totOtherValue  = round((otherGender["Price"].sum()), 2)
print ("Avg Price - Male    " + "Avg Price - Female    " + "Avg Price - Other " + 
       " Total Value - Male   " + "Total Value - Female   " + "Total Value - Other")
print ("----------------------------------------------------------------------------------------------------------------------------")
print ("           ", avgMalePrice,"                " ,avgFemMalePrice,"               " ,avgOtherPrice, "           ",
      totMaleValue,"                ",totfemaleValue,"               ", totOtherValue )
print ("----------------------------------------------------------------------------------------------------------------------------")
```

    Avg Price - Male    Avg Price - Female    Avg Price - Other  Total Value - Male   Total Value - Female   Total Value - Other
    ----------------------------------------------------------------------------------------------------------------------------
                2.95                  2.82                 3.25             1867.68                  382.91                 35.74
    ----------------------------------------------------------------------------------------------------------------------------
    


```
# Purchasing Analysis Gender 
# Normalized Totals ? 
# --- Need to create a dataframe for Purchasing Analysis by Gender -----
```

# Age demographics


```
# create age bands / cohorts
# df["Age"].min() -- 7
# df["Age].max() -- 45
tenBelow       = df[df["Age"] <10]
ten2Fifteen    = df[(df["Age"] >= 10) & (df["Age"] < 15)]
fifteen2Twenty = df[(df["Age"] >= 15) & (df["Age"] < 20)]
twenty2Twenty5 = df[(df["Age"] >= 20) & (df["Age"] < 25)]
twenty52Thirty = df[(df["Age"] >= 25) & (df["Age"] < 30)]
thirty2Thirty5 = df[(df["Age"] >= 30) & (df["Age"] < 35)]
thirty52Fourty = df[(df["Age"] >= 35) & (df["Age"] < 40)]
foutryPlus     = df[df["Age"] >= 40 ]
# get counts by Age Bands can either use len(tenBelow) or tenBelow["].count()
tenBelowCount       = tenBelow["Age"].count() 
ten2FifteenCount    = ten2Fifteen["Age"].count() 
fifteen2TwentyCount = fifteen2Twenty["Age"].count() 
twenty2Twenty5Count = twenty2Twenty5["Age"].count() 
twenty52ThirtyCount = twenty52Thirty["Age"].count()
thirty2Thirty5Count = thirty2Thirty5["Age"].count() 
thirty52FourtyCount = thirty52Fourty["Age"].count()
foutryPlusCount     = foutryPlus["Age"].count() 
# Total Purchase Value by Age Bands
tenBelowTotPurch       = round((tenBelow["Price"].sum()),2)
ten2FifteenTotPurch    = round((ten2Fifteen["Price"].sum()),2)
fifteen2TwentyTotPurch = round((fifteen2Twenty["Price"].sum()),2)
twenty2Twenty5TotPurch = round((twenty2Twenty5["Price"].sum()),2)
twenty52ThirtyTotPurch = round((twenty2Twenty5["Price"].sum()),2)
thirty2Thirty5TotPurch = round((thirty2Thirty5["Price"].sum()),2)
thirty52FourtyTotPurch = round((thirty52Fourty["Price"].sum()),2) 
foutryPlusTotPurch     = round((foutryPlus["Price"].sum()),2) 
# Average Purchase Value by Age Bands
tenBelowAvgPurch       = round(tenBelowTotPurch / tenBelowCount,2)
ten2FifteenAvgPurch    = round(ten2FifteenTotPurch / ten2FifteenCount,2)
fifteen2TwentyAvgPurch = round(fifteen2TwentyTotPurch / fifteen2TwentyCount,2)
twenty2Twenty5AvgPurch = round(twenty2Twenty5TotPurch / twenty2Twenty5Count,2)
twenty52ThirtyAvgPurch = round(twenty52ThirtyTotPurch / twenty52ThirtyCount,2)
thirty2Thirty5AvgPurch = round(thirty2Thirty5TotPurch/ thirty2Thirty5Count,2)
thirty52FourtyAvgPurch = round(thirty52FourtyTotPurch/ thirty52FourtyCount,2) 
foutryPlusAvgPurch     = round(foutryPlusTotPurch/ foutryPlusCount,2) 
# Normalized Totals - Total REvenue / group counts 
tenBelowNormRev       = round((totRev / tenBelowCount), 2)
ten2FifteenNormRev    = round((totRev / ten2FifteenCount), 2)
fifteen2TwentyNormRev = round((totRev / fifteen2TwentyCount), 2)
twenty2Twenty5NormRev = round((totRev / twenty2Twenty5Count), 2)
twenty52ThirtyNormRev = round((totRev / twenty52ThirtyCount), 2)
thirty2Thirty5NormRev = round((totRev / thirty2Thirty5Count), 2)
thirty52FourtyNormRev = round((totRev / thirty52FourtyCount), 2)
foutryPlusNormRev     = round((totRev / foutryPlusCount), 2)
```

## "Purchase Count by Age Groups"


```
print("===================================================================================================================")
print("Below 10    "," 10 to 15 ","  15 to 20  ", "  20 to 25  ", "  25 to 30  " , "  30 to 35  ", "  35 to 40  ", " Above 40 ")
print("     ", tenBelowCount,"          ",ten2FifteenCount,"       ", fifteen2TwentyCount,"        ",twenty2Twenty5Count,
      "        ", twenty52ThirtyCount,"         ", thirty2Thirty5Count, "         ", thirty52FourtyCount, "        ", foutryPlusCount)
print("===================================================================================================================")
```

    ===================================================================================================================
    Below 10      10 to 15    15 to 20     20 to 25     25 to 30     30 to 35     35 to 40    Above 40 
          28            35         133          336          125           64           42          17
    ===================================================================================================================
    


```
# Top Spenders
#Identify the the top 5 spenders in the game by total purchase value, then list (in a table):
#SN
#Purchase Count
#Average Purchase Price
#Total Purchase Value
df2 = df[["SN","Price"]]
df2.insert(2,'Purch Cnt',1)
top5Spenders = ((df2.groupby("SN",as_index=True, sort=True, group_keys=True).sum().reset_index()).sort_values(["Price"],ascending=False)).head(5)
totalTopSpending = top5Spenders["Price"].sum()
top5Spenders.insert(3,'Total Purchase Value', (top5Spenders["Price"]*top5Spenders["Purch Cnt"]))
top5Spenders.insert(4, "Average Purchase", round((totalTopSpending/top5Spenders["Purch Cnt"]),2))
```

# Top 5 Spenders


```
print("         " + top5Spenders.to_string(index=False))
print("---------------------------------------------------------------------------------")
print("Totals:      " + str(round(totalTopSpending,2)) + "         " + 
      str(round(top5Spenders["Purch Cnt"].sum(),2))+ "                "+
      str(round(top5Spenders["Total Purchase Value"].sum(),3)))
print("----------------------------------------------------------------------------------")
```

             SN  Price  Purch Cnt  Total Purchase Value  Average Purchase
    Undirrala66  17.06          5                 85.30             13.53
       Saedue76  13.56          4                 54.24             16.92
    Mindimnya67  12.74          4                 50.96             16.92
     Haellysu29  12.73          3                 38.19             22.56
         Eoda93  11.58          3                 34.74             22.56
    ---------------------------------------------------------------------------------
    Totals:      67.67         19                263.43
    ----------------------------------------------------------------------------------
    


```
#Identify the 5 most popular items by purchase count, then list (in a table):
#Item ID
#Item Name
#Purchase Count
#Item Price
#Total Purchase Value
df3 = df[["Item ID"]]
df3.insert(1,'Purch Cnt',1)
df4 = (df3.groupby(["Item ID"]).sum().reset_index()).sort_values(["Purch Cnt"],ascending=False)
top5Items = df.groupby(["Item ID","Item Name"]).max().reset_index()
top5Items = pd.merge(top5Items,df4).sort_values(["Purch Cnt"],ascending=False).head(5)
top5Items = top5Items[["Item ID","Item Name","Purch Cnt", "Price"]]
top5Items.insert(4, "Total Purchase Value",top5Items["Purch Cnt"] * top5Items["Price"])
```

# Top 5 Items by Purchase Count


```
print (top5Items.to_string(index = False))
print ("------------------------------------------------------------------------------------------------------")
print ("                                      TOTALS:        " , str(top5Items["Purch Cnt"].sum())
        , "                      ", str(round(top5Items["Total Purchase Value"].sum(),2)) )
print ("------------------------------------------------------------------------------------------------------")
```

    Item ID                             Item Name  Purch Cnt  Price  Total Purchase Value
         39  Betrayal, Whisper of Grieving Widows         11   2.35                 25.85
         84                            Arcane Gem         11   2.23                 24.53
         31                             Trickster          9   2.07                 18.63
        175            Woeful Adamantite Claymore          9   1.24                 11.16
         13                              Serenity          9   1.49                 13.41
    ------------------------------------------------------------------------------------------------------
                                          TOTALS:         49                        93.58
    ------------------------------------------------------------------------------------------------------
    


```
#Identify the 5 most profitable items by total purchase value, then list (in a table):
#Item ID
#Item Name
#Purchase Count
#Item Price
#Total Purchase Value
df5 = df[["Item ID","Item Name","Price"]].sort_values(["Price"], ascending =False).drop_duplicates().head(5)
df6 = df[["Item ID"]]
df6.insert(1, "Purch Count", 1)
df6 = df6.groupby(["Item ID"],as_index =True).sum().reset_index()
top5PurchItems = pd.merge(df5, df6)
top5PurchItems.insert(4, "Purchase Value", top5PurchItems["Price"] * top5PurchItems["Purch Count"])
#top5PurchItems
```

# Top 5 Items by Purchase Value


```
print (top5PurchItems.to_string(index = False))
print ("------------------------------------------------------------------------------------------------------")
print ("                             TOTALS:                  " , str(top5PurchItems["Purch Count"].sum())
        , "         ", str(round(top5PurchItems["Purchase Value"].sum(),2)) )
print ("------------------------------------------------------------------------------------------------------")
```

    Item ID                                 Item Name  Price  Purch Count  Purchase Value
         32                                   Orenmir   4.95            6           29.70
        177  Winterthorn, Defender of Shifting Worlds   4.89            4           19.56
        103                            Singed Scalpel   4.87            6           29.22
        173                       Stormfury Longsword   4.83            5           24.15
         42                           The Decapitator   4.82            3           14.46
    ------------------------------------------------------------------------------------------------------
                                 TOTALS:                   24           117.09
    ------------------------------------------------------------------------------------------------------
    

# Conclusion - Based on the data set
## Most active gamers are Males between the age of 20 to 25 followed by 25 to 30
## Most popular game is Hatred (sad really ;)
## When creating a game name certainly matters! 


```

```
