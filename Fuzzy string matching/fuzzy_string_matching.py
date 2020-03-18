# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 18:10:02 2020

@author: Alex Chunet
"""

import pandas as pd
from fuzzywuzzy import fuzz

file=r'D:\Documents\ArcGIS\Twitter Model\Data-fusion-project-master\accounts-locations-shp\account_location_tagged.xls'

df = pd.read_excel(file)

def match1(row):
    return fuzz.token_sort_ratio(row['administrative_area_level_1_long'],row['NAME_1'])

def match2(row):
    return fuzz.token_sort_ratio(row['administrative_area_level_2_long'],row['NAME_2'])

df['match_adm1'] = df.apply(match1, axis=1)
df['match_adm2'] = df.apply(match2, axis=1)
     
df.to_excel("account-locations-fmatch.xlsx")  
