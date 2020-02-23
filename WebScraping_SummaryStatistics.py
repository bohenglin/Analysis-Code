#Bo Lin (1329002), Ray Shi(1328997)
#Project data summary statistics, DATA 201B
#TUFTS UNIV, 2019-11-24
#----------------------------------------------------------------------

#import libraries
import pandas as pd
import re
import requests
from bs4 import BeautifulSoup


#create a table to hold all useful data:
page=requests.get('http://www.espn.com/mlb/history/leaders/_/breakdown/season/year/2019')
content= BeautifulSoup(page.text,'html.parser')
header = content.find('tr',attrs={'class':'colhead'})
columns = [col.get_text() for col in header.find_all('td')]
table = pd.DataFrame(columns=columns)

#get the page
for i in range(1,331,50):
    page = requests.get('http://www.espn.com/mlb/history/leaders/_/breakdown/season/year/2019/start/{}'.format(i))

#load the page text
    content = BeautifulSoup(page.text,'html.parser')
#    header = content.find('tr',attrs={'class':'colhead'})
#    columns = [col.get_text() for col in header.find_all('td')]

#get all players
    players = content.find_all('tr', attrs={'class':re.compile('row player-10-')})

    for p in players:
        value = [stat.get_text() for stat in p.find_all('td')]
        df = pd.DataFrame(value).transpose()
        df.columns = columns
        table = pd.concat([table,df],ignore_index = True)
    
#write out the table into csv for future use
table.to_csv(r'C:\Users\bohen\Desktop\US\TUFTS\TUFTS\Academic\DATA 201B\project\PlayerData.csv', index=False, encoding='utf-8')

#get the summary statistics
import statistics as st
#min, means, max, standard deviation for numeric variables
raw = pd.read_csv('PlayerData.csv')

#create a table for summary statistics
col = ['variable','min','mean','max','stdev']
Var = ['YRS','G','AB','R','H','2B','3B','HR','RBI','BB','SO','SB','CS','BA']
sumtab = pd.DataFrame(columns=col)
for v in range(len(Var)):
    sumtab.loc[v] = [ Var[v], min(raw[Var[v]]),st.mean(raw[Var[v]]),max(raw[Var[v]]),st.stdev(raw[Var[v]])]

#write out the table into csv for submission
sumtab.to_csv(r'C:\Users\bohen\Desktop\US\TUFTS\TUFTS\Academic\DATA 201B\project\SummaryStatistics.csv', index=False, encoding='utf-8')

#suppose we want to see if there is relation between BA, and R(run), and H(hit)
BA_HandR = raw.plot.scatter(x='R', y='BA',c='H')
#In this plot, the heteroscedasticity suggests that R is not the only major determinant of BA.
#However, it is clear that as R (x-axis) increases, the standard deviation among the data points are much smaller
#Also, as H increases (intensity of the points), they tend to be more around regions where BA is large
# Both H and R are playing positive relations with BA from this plot

BA_YrsandG = raw.plot.scatter(x='RBI',y='BA',c='G')
#In this plot, it is also clear that as RBI (x-axis) increases, BA will increase by diminishing standard deviations
# among the data points. However, the as the number of games increases (intensity of each point), there is no visually
# obvious trend in BA. Dark points are scattered in bother high BA region and low BA regions

#or we can plot a pca contribution to see what factors contribute to BA the most
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

X = raw.iloc[:,2:14].copy()
Y = raw.iloc[:,15].copy()
X_standard = StandardScaler().fit_transform(X)
pca = PCA(n_components = 3)
PCs = pca.fit_transform(X_standard)
projected_data = pd.concat([pd.DataFrame(data=PCs,columns = ["PC1","PC2","PC3"]),Y],axis= 1)

import matplotlib.pyplot as plt
plt.matshow(pca.components_,cmap='viridis')
plt.yticks([0,1,2],['PC1','PC2','PC3'],fontsize=10)
plt.colorbar()
plt.xticks(range(12),['YRS','G','AB','R','H','2B','3B','HR','RBI','BB','SO','SB','CS'],rotation=65,ha='left')
plt.show()
#The PCA weight shows AB, R, H and RBI contribute heavily
#subsequent contributors are 3B and SB
# PC3 has a power contributor YRS (which is the worst contributor in PC2)



