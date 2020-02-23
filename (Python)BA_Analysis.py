#Bo Lin (1329002), Ray Shi(1328997)
#Linear and Ridge Regression, DATA 201B
#TUFTS UNIV, 2019-12-08
#----------------------------------------------------------------------

#import libraries
import pandas as pd
from sklearn.model_selection import train_test_split

#Read in data and drop unuseful col
data = pd.read_csv("PlayerData.csv")
data.drop(['Unnamed: 0'],axis=1,inplace=True)
data.drop(['PLAYER'],axis=1,inplace=True)
data.drop(['H'],axis=1,inplace=True)
data.drop(['AB'],axis=1,inplace=True)

#Split BA from others
Xs = data.drop(['BA'],axis=1)
y = data['BA'].values.reshape(-1,1)

#import library for ridge
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import Ridge

#Do ridge
ridge = Ridge()
parameters = {'alpha': [1e-15,1e-10,1e-8,1e-4,1e-3,1e-2,1,5,10,20]}
ridge_regressor = GridSearchCV(ridge,parameters,scoring = 'neg_mean_squared_error',cv=5)
ridge_regressor.fit(Xs,y)
#print out best params and the MSE
print(ridge_regressor.best_params_)
print(ridge_regressor.best_score_)

#Split data into test and training sets
X_train,X_test,y_train,y_test = train_test_split(Xs,y,test_size=0.3,
                                                 random_state = 0)
#Based on best params=20, do a ridge with alpha=20; get scores
rr20 = Ridge(alpha=20)
rr20.fit(X_train,y_train)
Ridge_train_score = rr20.score(X_train,y_train)
Ridge_test_score = rr20.score(X_test,y_test)

print ("Ridge regression train score with alpha=20:", Ridge_train_score)
print ("Ridge regression test score with alpha=20:", Ridge_test_score)

#Do linear regression
from sklearn.linear_model import LinearRegression
lr = LinearRegression()
lr.fit(X_train,y_train)
lr_test_score = lr.score(X_test,y_test)
lr_train_score = lr.score(X_train,y_train)
print ("Linear regression train score:", lr_train_score)
print ("Linear regression test score:", lr_test_score)

#Examine the PCA contribution by each variable
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

pcaX = data.iloc[:,0:11].copy()
pcaY = data.iloc[:,11].copy()
pcaX_standard = StandardScaler().fit_transform(pcaX)
pca = PCA(n_components = 3)
PCs = pca.fit_transform(pcaX_standard)
projected_data = pd.concat([pd.DataFrame(data=PCs,columns = ["PC1","PC2","PC3"]),pcaY],axis= 1)

#Variance explained by top PCs
ExplainedRatio = pca.explained_variance_ratio_
for i in range(3):
    print("PC" + str(i+1) + " explains " + str(ExplainedRatio[i] *100)[0:6] + "% of variance in BA")


import matplotlib.pyplot as plt
plt.matshow(pca.components_,cmap='viridis')
plt.yticks([0,1,2],['PC1','PC2','PC3'],fontsize=10)
plt.colorbar()
plt.xticks(range(11),['YRS','G','R','2B','3B','HR','RBI','BB','SO','SB','CS'],rotation=65,ha='left')
plt.show()
