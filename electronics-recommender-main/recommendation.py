#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from scipy.spatial.distance import pdist, squareform

# url = 'https://drive.google.com/file/d/10IoJoMLbLL5nPKJR9OxyvqjjQJnc2Go3/view?usp=sharing'
# url = 'https://drive.google.com/uc?id=' + url.split('/')[-2]
dfmeta = pd.read_csv("data/product.csv")

# url = 'https://drive.google.com/file/d/104BQyctJRjoNWc1JtOr8brgYMVKb34kR/view?usp=sharing'
# url = 'https://drive.google.com/uc?id=' + url.split('/')[-2]
dfreviews = pd.read_csv("data/product_rating.csv", dtype={"star_number": "int8", "user_id": "int32", "product_id": "int32"})

dfmeta = dfmeta[["id", "name"]]
dfreviews = dfreviews[["id", "product_id", "user_id", "star_number"]]

dfmeta.rename(columns={'id': 'productid', 'name': 'title'}, inplace=True)
dfreviews.rename(columns={'product_id': 'productid', 'star_number': 'rating', 'user_id': 'userid'}, inplace=True)


dfreviews.loc[dfreviews['rating'] == 5, 'rating'] *= 2
dfreviews.loc[dfreviews['rating'] == 4, 'rating'] *= 1.5

product_ratings = pd.merge(dfreviews, dfmeta, on='productid', how='inner')

product_ratings = product_ratings.drop_duplicates()

df = product_ratings[['userid', 'productid', 'rating']]

df = df.dropna()

counts1 = df['userid'].value_counts()
counts = df['productid'].value_counts()

df1 = df[df['userid'].isin(counts1[counts1 >= 0].index)]
df1 = df1[df1['productid'].isin(counts[counts >= 10].index)]

df1.drop_duplicates(subset=['userid', 'productid'], keep=False, inplace=True)
df1[df1.duplicated(['userid', 'productid'], keep=False)]

ratingsd = df1.pivot(index='userid', columns='productid', values='rating')
ratingsd = ratingsd.fillna(0)
# ratingsd = ratingsd.T

# traind, testd = train_test_split(ratingsd, test_size=0.30, random_state=42)

# train = traind.values
# test = testd.values

np.seterr(divide='ignore', invalid='ignore')

def adjusted_cosine(ratingMatrix):
    M = ratingMatrix
    M_u = M.mean(axis=1)
    item_mean_subtracted = M - M_u[:, None]
    similarity_matrix = 1 - squareform(pdist(item_mean_subtracted.T, 'cosine'))
    return similarity_matrix


def predict_item(ratings, similarity):
    return ratings.dot(similarity) / np.array([np.abs(similarity).sum(axis=1)])


item_sim = adjusted_cosine(ratingsd.values)
item_prediction = predict_item(ratingsd.values, item_sim)


item_prediction_df = pd.DataFrame(item_prediction, index=ratingsd.index, columns=ratingsd.columns)
item_prediction_df = item_prediction_df.T

count = df1.groupby("productid", as_index=False).mean()
items_df = count[['productid']]


def recommend(predictions_df, itm_df, original_ratings_df, num_recommendations, ruserId):
    # Get and sort the user's predictions
    sorted_user_predictions = predictions_df[ruserId].squeeze().sort_values(ascending=False)

    # Get the user's data and merge in the item information.
    user_data = original_ratings_df[original_ratings_df.userid == ruserId]
    #     user_full = (user_data.merge(itm_df, how = 'left', left_on = 'userid', right_on = 'productid').
    #                      sort_values(['rating'], ascending=False)
    #                  )

    prod_df = df1[['userid', 'productid']]
    prod_df = prod_df[prod_df['userid'] == ruserId]
    # prod_list = prod_df['title'].to_list()

    # print('User {0} đã đánh giá {1} sản phẩm:'.format(ruserId, user_data.shape[0]))
    # for p in prod_list:
    #     print('-------------------------------------------------')
    #     print(p)
    #
    # print('*************************************************')
    # print('Gợi ý {0} sản phẩm:'.format(num_recommendations))

    # Recommend the highest predicted rating items that the user hasn't bought yet.
    recommendations = (itm_df[~itm_df['productid'].isin(user_data['productid'])].
                           merge(pd.DataFrame(sorted_user_predictions).reset_index(), how='left',
                                 left_on='productid',
                                 right_on='productid').
                           rename(columns={ruserId: 'Predictions'}).
                           sort_values('Predictions', ascending=False).
                           iloc[:num_recommendations, :-1]
                           )
    # topk = recommendations.merge(original_ratings_df, how='left', on='productid').drop_duplicates(
    #     ['productid', 'title'])[['productid', 'title']]

    return recommendations["productid"].tolist()

# print((recommend(item_prediction_df, items_df, df1, 10,6599406)))

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

my_file = open("stopwords.txt", "r", encoding="utf-8")
content = my_file.read()
stopwords = content.split("\n")
my_file.close()

tf = TfidfVectorizer(analyzer='word',ngram_range=(1, 2),min_df=0.1, stop_words=stopwords)
tfidf_matrix = tf.fit_transform(dfmeta['title'])
CB_sim = linear_kernel(tfidf_matrix, tfidf_matrix)

titles = dfmeta['productid']
indices = pd.Series(dfmeta.index, index=dfmeta['title'])

def CB_recommend(id):
    index = dfmeta[dfmeta["productid"] == id].index.values.astype(int)[0]
    title = dfmeta.iloc[index]['title']

    idx = indices[title]
    sim_scores = list(enumerate(CB_sim[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    sim_scores = sim_scores[1:21]
    book_indices = [i[0] for i in sim_scores]
    return titles.iloc[book_indices].tolist()

def result(user_id, n):
    original_list = recommend(item_prediction_df, items_df, df1, n, user_id)
    delim = ","

    temp = list(map(str, original_list))

    result = delim.join(temp)

    # keys = []
    # for id in range(n):
    #     keys.append("id")
    #
    # result = dict(zip(original_list, keys))

    return result

def CB_result(user_id):
    original_list = CB_recommend(user_id)
    delim = ","

    temp = list(map(str, original_list))

    result = delim.join(temp)

    # keys = []
    # for id in range(n):
    #     keys.append("id")
    #
    # result = dict(zip(original_list, keys))

    return result