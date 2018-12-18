# Go to https://apps.twitter.com

# Information from Twitter
api_key ="tp2btICEp9x5CVI8oIttz8z58"
api_secret="UHNX2wsSBGnGPhzFOMmOyQjJYgTKwNHMQH3YLFn6BHpEgNk7Ka"
access_token="979040708760780800-QYOMlvSLRRsjt40l8wr3Tsxd6DeYu8H"
access_token_secret="wNKO33c4ujVWieUwWzkeeSwRR7lfQRlltVLK2UO1RXs2M"

#Load Library
library(twitteR)
setup_twitter_oauth(api_key, api_secret, access_token,access_token_secret)


# Getting Tweets
con = searchTwitter('$#CongressNeVachanNibhaya', n=1000, lang='en')
con
tweetsdf = twListToDF(con)
write.csv(tweetsdf, file ='D:/Tweets/cong.csv', row.names=F)
tweet = read.csv('D:/Tweets/cong.csv')


# Read file
con =read.csv(file.choose(), header =T)
str(con)

# Build corpus
library(tm)
corpus = iconv(con$text,to="ISO-8859-1")
corpus = Corpus(VectorSource(corpus))
inspect(corpus[1:5])

# Clean text
corpus =tm_map(corpus, tolower)
corpus =tm_map(corpus, removePunctuation)
corpus =tm_map(corpus, removeNumbers)
cleanset  =tm_map(corpus, removeWords, stopwords('english'))
cleanset =tm_map(cleanset, stripWhitespace)

cleanset = tm_map(cleanset, PlainTextDocument)
inspect(cleanset[1:5])


# Term document matrix
tdm = TermDocumentMatrix(cleanset)
tdm

tdm= as.matrix(tdm)
tdm[1:10, 1:20]

# Bar Plot
w =rowSums(tdm)
w =subset(w, w>=1)
w

# Saving the Barplot
png("D:/Tweets/barplot.png")
barplot(w, las =2, col=rainbow(20))
dev.off()


# Wordcloud
library(wordcloud)
w =sort(rowSums(tdm), decreasing = TRUE)
set.seed(375)
wordcloud( word = names(w), freq= w, max.words=50, random.order = F, min.freq =10, rotateRatio = 0.2,colors= brewer.pal(8, 'Dark2'), scale =c(2.5, 0.1))

library(wordcloud2)
w = data.frame(names(w),w)
colnames(w) = c('word', 'freq')
wordcloud2(w, size =0.3, shape ='star', rotateRatio = 0.1, minSize=1)



# Sentimental Analysis
library(syuzhet)
library(lubridate)
library(ggplot2)
library(reshape2)
library(dplyr)


# Read File
con =read.csv(file.choose(), header = T)
tweets = iconv(con$text, to ="UTF-8")

# Obtain Sentiment Scores
s =get_nrc_sentiment(tweets)
head(s)
tweets[1]
get_nrc_sentiment('Farm')

# Barplot
barplot(colSums(s), las =2, col= rainbow(10), ylab= 'Count', main= 'Sentiment Scores for Congress Ne Vachan Nibhaya')
