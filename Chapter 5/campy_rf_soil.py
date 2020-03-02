import pandas as pd
import numpy as np
from collections import Counter
from pprint import pprint

#import time

import matplotlib.pyplot as plt

from scipy.stats import randint as sp_randint

from imblearn.over_sampling import SMOTE

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import RandomizedSearchCV
from sklearn.model_selection import train_test_split

from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.metrics import classification_report
from sklearn.metrics import roc_curve, roc_auc_score

import joblib

import sys
sys.path.append('/Users/cegolden/Projects/Weather/Model_Development/')


#to determine run time of script
#start = time.time()

#define function that loads data via LoadData function
def LoadData():
    global X_train, X_test, y_train, y_test, soil
    global feature_columns, n_features, response_column

    full = pd.read_excel("/Users/cegolden/Projects/Weather/Model_Development/Copy_of_Meteorological_poultry_data.xlsx", sheet_name = "Campylobacter")

    #delete indicator variables
    full = full.drop(full.columns[[0, 1, 2, 4, 5, 7]], axis=1)

    #split data into soil and feces
    soil = full[full.SampleType == 'Soil']

    #drop sample type for each data set
    soil = soil.drop(soil.columns[0], axis=1)

    #get column names and store them
    feature_columns = list(soil.columns)
    feature_columns.remove('CampyCef')
    response_column = ['CampyCef']

    #get number of features
    n_features = len(feature_columns)

    #split up into x and y where y is response variable
    #.values turns df into array
    X_soil = soil.drop('CampyCef', axis=1).values
    y_soil = soil['CampyCef']

    #convert + into 1 and - into 0 and make this column an array
    y_soil = y_soil.map({'+': 1, '-': 0}).values


    #split into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X_soil, y_soil, test_size = 0.2, random_state = 120, stratify = y_soil)
    print('Original dataset shape %s' % Counter(y_train))
    
    #apply smote to training data to fix for minority sample imbalance
    sm = SMOTE(random_state = 1213)
    X_train, y_train = sm.fit_resample(X_train, y_train)
    print('Oversampled dataset shape %s' % Counter(y_train))

    return

def ModelFit():
    global best_model

    #contruct hyperparameter grid
    param_dist = {"max_depth": [3, 10, 20, 70, None],
                  "max_features": [2, 10, 41, 80],
                  "min_samples_split": sp_randint(2, 11),
                  "min_samples_leaf": sp_randint(1, 11),
                  #"bootstrap": [True, False],
                  "criterion": ["gini", "entropy"],
                  "n_estimators": [100, 300, 500, 800, 1000]}
    pprint(param_dist)

    #define random forest classifier function
    rf = RandomForestClassifier(random_state = 120)

    #search across 1000 randomized combinations in the above grid
    estimator = RandomizedSearchCV(estimator = rf, param_distributions = param_dist, n_iter = 1000, cv = 10, verbose = 10, random_state = 1213, scoring = 'roc_auc', n_jobs = -1)

    #fit the model
    grid_result = estimator.fit(X_train, y_train)

    #find and define best estimator based on grid search
    best_model = grid_result.best_estimator_
    print('\nbest_model:\n', best_model)

    #predict y based on test data
    y_pred = grid_result.predict(X_test)

    #accuracy score
    print('accuracy score:', accuracy_score(y_test, y_pred))

    #confusion matrix
    tn, fp, fn, tp = confusion_matrix(y_test, y_pred).ravel()
    print(tn,fp,fn,tp)

    #classification report
    print('\nclassification report:\n',classification_report(y_test, y_pred))

    #AUC and ROC curve
    y_pred_prob = grid_result.predict_proba(X_test)[:,1]
    auc = roc_auc_score(y_test, y_pred_prob)
    print('auc:', auc)

    false_positive, true_positive, _ = roc_curve(y_test, y_pred_prob)

    font = {'fontname':'Helvetica'}
    plt.figure()
    plt.plot([0, 1], [0, 1], 'k--')
    plt.plot(false_positive, true_positive, color='black')
    plt.xlabel('False positive rate', **font)
    plt.ylabel('True positive rate', **font)
    plt.savefig('soil_roc.png', dpi=300)
    plt.show()

    # Save the model as a pickle in a file 
    joblib.dump(grid_result, 'campy_rf_soil_smote.pkl')
    
    #determine top features and plot
    feature_importances = grid_result.best_estimator_.feature_importances_
    column_names=list(soil)
    del column_names[-0]
    importance = pd.DataFrame(feature_importances, index=column_names, columns=["Importance"])
    sort_importance = importance.sort_values(by=['Importance'], ascending = False)
    sort_column_names = sort_importance.index.values.tolist()
    mult = 100/(sort_importance['Importance'].iloc[0])
    sort_imp_mult = sort_importance * mult
    
    top_imp = sort_imp_mult['Importance'].iloc[0:15].tolist()
    top_column_names = sort_column_names[0:15]
    top_column_names = ['AverageTemperatureOneDayBefore',
                         'MaxHumidityTwoDayBefore',
                         'MaxTemperatureOneDayBefore',
                         'AvgMinTemperature1.7',
                         'AvgPrecipitation1.7',
                         'AvgMaxGustSpeed1.3',
                         'AvgAverageTemperature1.2',
                         'AvgMinTemperature1.4',
                         'AvgMinTemperature1.2',
                         'AvgAverageHumidity1.6',
                         'AvgMinTemperature1.6',
                         'AvgMaxGustSpeed1.2',
                         'MaximumWindSpeedOneDayBefore',
                         'AvgMaxWindSpeed1.7',
                         'AvgAverageHumidity1.7']
    
    y_ticks = np.arange(0, len(top_column_names))
    fig, ax = plt.subplots()
    ax.barh(y_ticks, top_imp, color = "dimgray")
    ax.set_yticklabels(top_column_names, **font)
    ax.set_yticks(y_ticks)
    plt.xlabel('Relative Importance', **font)
    fig.tight_layout()
    plt.gca().invert_yaxis()
    plt.savefig('soil_var.png', dpi=300)
    plt.show()
    
    return

LoadData()
ModelFit()

#to determine run time of script
#print('This program took {0:0.1f} seconds'.format(time.time() - start))