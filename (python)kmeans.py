#BOHENG LIN
#2020-6-22
#TUFTS UNIV

        
#Import libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn.metrics as skm
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler


#Reading the dataset from the online source
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"
colnames=["ID","Diagnosis",
       "Mean_Radius","Mean_Texture","Mean_Perimeter","Mean_Area","Mean_Smoothness",
       "Mean_Compactness","Mean_Concavity","Mean_ConcavityPoints","Mean_Symmetry",
       "Mean_FractalDimension","SE_Radius,","SE_Texture","SE_Perimeter","SE_Area","SE_Smoothness",
       "SE_Compactness","SE_Concavity","SE_ConcavityPoints","SE_Symmetry","Se_FractalDimension",
       "Worst_Radius,","Worst_Texture","Worst_Perimeter","Worst_Area","Worst_Smoothness",
       "Worst_Compactness","Worst_Concavity","Worst_ConcavityPoints","Worst_Symmetry",
       "Worst_FractalDimension"]
data = pd.read_csv(url,names=colnames)


#Plot 30 histograms on a single figure.
#The prevalences of Malignant and Benign are plotted against each of the 30 variables/columns in the dataset
fig,axes = plt.subplots(6,5,figsize=(50,60))
ax=axes.ravel()

for i in range(2,32):
    _,binss = np.histogram(data.iloc[:,i],bins=10)
    M = Mali.iloc[:,i].values
    B = Beni.iloc[:,i].values
    ax[i-2].hist(M,bins=binss,color='r',alpha=0.5)
    ax[i-2].hist(B,bins=binss,color='g',alpha=0.3)
    ax[i-2].set_title(data.columns[i],fontsize=15)
    ax[i-2].axes.get_xaxis().set_visible(True)
    ax[i-2].set_yticks(())
ax[0].legend(['Malignant','Benign'],loc="best",fontsize=15)
plt.savefig("All_plots.png",dpi=500)


#Creating two subsets data, Malignant and Benign based on Diagnosis
Mali = data.loc[data["Diagnosis"] == 'M']
Beni = data.loc[data["Diagnosis"] == 'B']

# Principal Component Analysis Using Existing Functions
X = data.iloc[:,2:31]   #feature
Y = data.Diagnosis      #diagnosis

#Standardize the feature
X_standard = StandardScaler().fit_transform(X)

#Obtaining first 10 Principal Components
pca = PCA(n_components = 10)
PCs = pca.fit_transform(X_standard)
projected_data = pd.concat([pd.DataFrame(data=PCs,
                                         columns = ["PC1","PC2","PC3",
                                                    "PC4","PC5","PC6",
                                                    "PC7","PC8","PC9","PC10"]),
                            Y],axis= 1)

#Obtaining explained variance ratio for each principal component
print(pca.explained_variance_ratio_)
print(sum(pca.explained_variance_ratio_)*100)
plt.figure()
plt.plot(pca.explained_variance_ratio_)



    #GRAPHING 
#set up diagnosis with colors
diagnosis = list(data.Diagnosis.unique())
Colors = ['#ff0000','#28B463'] #color code

#2D graph
fig = plt.figure(figsize =(10,10))
ax = fig.add_subplot(1,1,1)
ax.set_xlabel('PC1',fontsize =15)
ax.set_ylabel('PC2',fontsize =15)
ax.set_title('First 2 Principal Components',fontsize = 30)

Pair = zip(diagnosis,Colors)
for d, Color in Pair:
    keepi = projected_data['Diagnosis'] == d
    ax.scatter(projected_data.loc[keepi,'PC1'],
               projected_data.loc[keepi,'PC2'],
               c = Color,
               s = 90)          
ax.legend(['Malignant','Benign'])
ax.grid()
#plt.savefig('2D_plot.png',dpi=500)

#2D plot shows that both benign and malignant have similar spread/trend in the
#dataset, where most of them are clustered together at bottom left and tend
# to spread out top right, though with different angles




# actual labels in 2D
fig = plt.figure(figsize =(10,10))
ax = fig.add_subplot(1,1,1)
ax.set_xlabel('PC1',fontsize =15)
ax.set_ylabel('PC2',fontsize =15)
ax.set_title('First 2 Principal Components',fontsize = 30)

Pair = zip(diagnosis,Colors)
for d, Color in Pair:
    keepi = projected_data['Diagnosis'] == d
    ax.scatter(projected_data.loc[keepi,'PC1'],
               projected_data.loc[keepi,'PC2'],
               c = Color,
               s = 90)          
ax.legend(['Malignant','Benign'])
ax.grid()

# using KMeans to re label the data
# remove label and leave only the first 2 PC

NoLdata = projected_data.iloc[:,0:2].copy()


centro = np.array([(np.random.uniform(min(NoLdata.iloc[:,0]),
                                      max(NoLdata.iloc[:,0])),
                    np.random.uniform(min(NoLdata.iloc[:,1]), 
                                      max(NoLdata.iloc[:,1])),
                        ),
                   (np.random.uniform(min(NoLdata.iloc[:,0]),
                                      max(NoLdata.iloc[:,0])),
                    np.random.uniform(min(NoLdata.iloc[:,1]), 
                                      max(NoLdata.iloc[:,1])))])

grouping = skm.pairwise_distances_argmin(NoLdata,centro)  
labels = np.unique(grouping)   #label starts from 0, goes up by 1
X = np.column_stack([NoLdata,grouping]).copy()  
diff = 1
iteration = 0
newcentro = centro.copy()
while (diff > 10**(-3)) and (iteration < 100):
    iteration +=1
    oldcentro=newcentro.copy()
    for l in labels:
        centro_x = X[X[:,-1]==l][:,0].mean()   
        centro_y = X[X[:,-1]==l][:,1].mean()   
        newcentro[l][0]=centro_x      #update newcentro's x values 
        newcentro[l][1]=centro_y      #update newcentro's y values
        grouping = skm.pairwise_distances_argmin(X[:,0:2],newcentro)
kmX = np.column_stack([X[:,0:2],grouping])

#plot the visual result

fig = plt.figure(figsize =(10,10))
ax = fig.add_subplot(1,1,1)
ax.set_xlabel('PC1',fontsize =15)
ax.set_ylabel('PC2',fontsize =15)
ax.set_title('Classified Data',fontsize = 30)
ax.scatter(kmX[kmX[:,2]==0][:,0],kmX[kmX[:,2]==0][:,1],color='green')
ax.scatter(kmX[kmX[:,2]==1][:,0],kmX[kmX[:,2]==1][:,1],color='red')
ax.legend(['Benign','Malignant'])
ax.grid()


# assess misclassification rate using KMeans with 2 PCs:
Result = []
for i in range(len(kmX)):
    if (kmX[i][-1] == 0) and (projected_data['Diagnosis'][i]=='B'): 
        Result += [1]
    elif (kmX[i][-1] == 1) and (projected_data['Diagnosis'][i]=='M'):
        Result+= [1]
    else: Result += [0]

AccRate = sum(Result)/len(Result) *100
print(str(AccRate)+"% accuracy rate")

#Repeat the algorithm 100 times
CrRate=[]
count=0

while count <100:
    count += 1
    NoLdata = projected_data.iloc[:,0:2].copy()


    centro = np.array([(np.random.uniform(min(NoLdata.iloc[:,0]),
                                      max(NoLdata.iloc[:,0])),
                    np.random.uniform(min(NoLdata.iloc[:,1]), 
                                      max(NoLdata.iloc[:,1])),
                        ),
                   (np.random.uniform(min(NoLdata.iloc[:,0]),
                                      max(NoLdata.iloc[:,0])),
                    np.random.uniform(min(NoLdata.iloc[:,1]), 
                                      max(NoLdata.iloc[:,1])))])

    grouping = skm.pairwise_distances_argmin(NoLdata,centro)  
    labels = np.unique(grouping)   #label starts from 0, goes up by 1
    X = np.column_stack([NoLdata,grouping]).copy()  
    diff = 1
    iteration = 0
    newcentro = centro.copy()
    while (diff > 10**(-3)) and (iteration < 100):
        iteration +=1
        oldcentro=newcentro.copy()
        for l in labels:
            centro_x = X[X[:,-1]==l][:,0].mean()   
            centro_y = X[X[:,-1]==l][:,1].mean()   
            newcentro[l][0]=centro_x      #update newcentro's x values 
            newcentro[l][1]=centro_y      #update newcentro's y values
            grouping = skm.pairwise_distances_argmin(X[:,0:2],newcentro)
    kmX = np.column_stack([X[:,0:2],grouping])

# assess misclassification rate using KMeans with 2 PCs:
    Result = []
    for i in range(len(kmX)):
        if (kmX[i][-1] == 0) and (projected_data['Diagnosis'][i]=='B'): 
            Result += [1]
        elif (kmX[i][-1] == 1) and (projected_data['Diagnosis'][i]=='M'):
            Result+= [1]
        else: Result += [0]
    AccRate = sum(Result)/len(Result) *100
    CrRate += [AccRate]
    
plt.figure()
plt.plot(CrRate)




# construct own spatial distance function
# for the centroid cloest to each data point, index of the 
# centroid is added to the last column with the data point
# return a matrix where the last column is the index of the
# nearest centroid
def spadist(X,Y):
    #X is n by m array of data points
    #Y is z by m array of centroids
    Label = []
    error = []
    for point in X:
        distance= []
        for c in range(len(Y)):
            d0 = sum(np.square(np.subtract(point,Y[c])))
            distance += [d0]
            error += [d0]
        L = [i for i, j in enumerate(distance) if j == min(distance)]
        Label += [L]
    result = np.column_stack([X, Label])
    return result, error
        

def MultiDimKMean(X, p, it=100,k=2):
# X is the data, p is number of dimension, 
# it is the number of iterations, k is number of cluster
#return datapoints with labels, and centroid coordinates
    count = 0
    centro= np.array([[np.random.rand() for i in range(p)] for j in range(k)])
    label = [i for i in range(p)] #labels are 0, 1, 2 ... etc.
    while count < it:
        count += 1
        new_X,Y = spadist(X, centro)
        new_centro = centro.copy()
        for i in range(len(centro)): #centroid 1, centroid 2...
            for j in range(len(centro[0])): # column 1, 2...
                new_centro[i][j] = new_X[new_X[:,-1]== i][:,j].mean()
        centro = new_centro.copy()
    return new_X, new_centro


# Repeat KMeans using 5 PCs, 2 clusters:
pc5x = np.array(projected_data.iloc[:,0:5].copy())
Error5pc = []
count = 0
Result5=[]
CrRate5=[]
while count < 200:
    count += 1
    new5,pc5cen = MultiDimKMean(pc5x,5)
    tem, error5 = spadist(pc5x,pc5cen)
#    Error5pc += [sum(error5)]
    for i in range(len(new5)):
        if (new5[i][-1] == 0) and (projected_data['Diagnosis'][i]=='B'): 
            Result5 += [1]
        elif (new5[i][-1] == 1) and (projected_data['Diagnosis'][i]=='M'):
            Result5 += [1]
        else: Result5 += [0]
    AccRate5 = sum(Result5)/len(Result5) *100
    CrRate5 += [AccRate5]
plt.figure()
plt.suptitle('KMeans Accuracy Rate on 5PCs', fontsize=20)
plt.plot(CrRate5)



# Repeat KMeans using 10 PCs, 2 clusters:
pc10x = np.array(projected_data.iloc[:,0:10].copy())
Error10pc = []
count = 0
Result10=[]
CrRate10=[]
while count < 200:
    count += 1
    new10,pc10cen = MultiDimKMean(pc10x,10)
    tem, error10 = spadist(pc10x,pc10cen)
#    Error5pc += [sum(error5)]
    for i in range(len(new10)):
        if (new10[i][-1] == 0) and (projected_data['Diagnosis'][i]=='B'): 
            Result10 += [1]
        elif (new10[i][-1] == 1) and (projected_data['Diagnosis'][i]=='M'):
            Result10+= [1]
        else: Result10 += [0]
    AccRate10 = sum(Result10)/len(Result10) *100
    CrRate10 += [AccRate10]
plt.figure()
plt.suptitle('KMeans Accuracy Rate on 10PCs', fontsize=20)
plt.plot(CrRate10)
