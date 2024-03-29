
magazine <- read.csv(file = "C:/temp/magazineluiza_original.csv", sep = ';',
                     dec = '.', encoding = 'UTF-8')[ ,c('comentario')]

# Limpeza de dados - Extrair dados ausentes (Na) e eventuais dados inconsistentes

magazine


magazine_dataset <- magazine[!(is.na(magazine$comentario) | magazine$comentario==""), ]




magazine_dataset$comentario
# Integra��o de Dados - Agrupamento dos coment�rios baseando-se em determinados itens(produtos)

library(dplyr)
magazine_group <- magazine %>% 
        group_by(categoria) %>%
        count(categoria,sort = TRUE)  %>%
        filter(n >= 100) %>%
        ungroup()

magazine_grouped <- magazine_dataset[magazine_dataset$categoria %in%
                                             magazine_group$categoria,]



#Transforma��o de Dados - Criar uma estrutura de dados adequada (mais conveniente) para an�lise de dados (text mining)


magazine_group %>% print(n = 100)
magazine_grouped 

# Agrupamento das categorias

# eletrodomestico <- magazine_grouped[magazine_grouped$categoria %in% c("Fog�o","Cooktop","Geladeira / Refrigerador","Depurador de Ar", "Cooktop 5 Bocas",
#                                                                       "Micro-ondas","Forno El�trico","Tanquinho","Freezer","Geladeira / Refrigerador Inverse",
#                                                                       "Coifa de Parede","Forno a G�s","Fornos e Pe�as","Centr�fuga de Roupas","Frigobar",
#                                                                       "Coifas e Depuradores", "Secadora de Roupas", "Lava e Seca", "Tanquinho e Pe�as", "Lava-Lou�as" ),]
# 
# 
# eletronico <- magazine_grouped[magazine_grouped$categoria %in% c("Smart TV","Samsung Galaxy", "Celular LG", "Galaxy A31","iPhone 6s e 6s Plus", "Galaxy A51",
#                                                                  "Galaxy A10s","Galaxy A01","Smartphone","Motorola","LG K51s","Galaxy A11","Moto E6S",
#                                                                  "Quantum","Galaxy M31","Moto G9 Play","LG K8"),]

fogao <- magazine_grouped[magazine_grouped$categoria %in% c("Fog�o"),] # 3074
maquina_lavar <- magazine_grouped[magazine_grouped$categoria %in% c("M�quina de Lavar"),] # 1225
cooktop <- magazine_grouped[magazine_grouped$categoria %in% c("Cooktop","Cooktop 5 Bocas"),] # 1188
geladeira <- magazine_grouped[magazine_grouped$categoria %in% c("Geladeira / Refrigerador"),] # 815
depurador <- magazine_grouped[magazine_grouped$categoria %in% c("Depurador de Ar"),] # 775

smart_tv <- magazine_grouped[magazine_grouped$categoria %in% c("Smart TV"),] # 1258
smartphone_samsung <- magazine_grouped[magazine_grouped$categoria %in% c("Samsung Galaxy","Galaxy A31",
                                                                         "Galaxy A51","Galaxy A10s",
                                                                         "Galaxy A01","Galaxy A11",
                                                                         "Galaxy M31"),] # 602 
smartphone_lg <- magazine_grouped[magazine_grouped$categoria %in% c("Celular LG","LG K51s","LG K8"),]
smartphone_motorola <- magazine_grouped[magazine_grouped$categoria %in% c("Motorola","Moto E6S",
                                                                          "Moto G9 Play"),]
smartphone_iphone <- magazine_grouped[magazine_grouped$categoria %in% c("iPhone 6s e 6s Plus"),]

# Instalando pacotes que ser�o utilizados na cria��o do corpus

install.packages('devtools')
install.packages("slam")
install.packages("NLP")
install.packages("tm", dependencies = TRUE, repos="http://R-Forge.R-project.org")

# palavras sem valor sem�ntico para an�lise (stopwords) que ser�o removidas nos coment�rios
stopwords_atualizada <- c("a",
                          "acerca",
                          "adeus",
                          "agora",
                          "ainda",
                          "alem",
                          "algmas",
                          "algo",
                          "algumas",
                          "alguns",
                          "ali",
                          "al�m",
                          "ambas",
                          "ambos",
                          "ano",
                          "anos",
                          "antes",
                          "ao",
                          "aonde",
                          "aos",
                          "apenas",
                          "apoio",
                          "apontar",
                          "apos",
                          "ap�s",
                          "aquela",
                          "aquelas",
                          "aquele",
                          "aqueles",
                          "aqui",
                          "aquilo",
                          "as",
                          "assim",
                          "atrav�s",
                          "atr�s",
                          "at�",
                          "a�",
                          "baixo",
                          "bastante",
                          "bem",
                          "boa",
                          "boas",
                          "bom",
                          "bons",
                          "breve",
                          "cada",
                          "caminho",
                          "catorze",
                          "cedo",
                          "cento",
                          "certamente",
                          "certeza",
                          "cima",
                          "cinco",
                          "coisa",
                          "com",
                          "como",
                          "comprido",
                          "conhecido",
                          "conselho",
                          "contra",
                          "contudo",
                          "corrente",
                          "cuja",
                          "cujas",
                          "cujo",
                          "cujos",
                          "custa",
                          "c�",
                          "da",
                          "daquela",
                          "daquelas",
                          "daquele",
                          "daqueles",
                          "dar",
                          "das",
                          "de",
                          "debaixo",
                          "dela",
                          "delas",
                          "dele",
                          "deles",
                          "demais",
                          "dentro",
                          "depois",
                          "desde",
                          "desligado",
                          "dessa",
                          "dessas",
                          "desse",
                          "desses",
                          "desta",
                          "destas",
                          "deste",
                          "destes",
                          "deve",
                          "devem",
                          "dever�",
                          "dez",
                          "dezanove",
                          "dezasseis",
                          "dezassete",
                          "dezoito",
                          "dia",
                          "diante",
                          "direita",
                          "dispoe",
                          "dispoem",
                          "diversa",
                          "diversas",
                          "diversos",
                          "diz",
                          "dizem",
                          "dizer",
                          "do",
                          "dois",
                          "dos",
                          "doze",
                          "duas",
                          "durante",
                          "d�",
                          "d�o",
                          "d�vida",
                          "e",
                          "ela",
                          "elas",
                          "ele",
                          "eles",
                          "em",
                          "embora",
                          "enquanto",
                          "entao",
                          "entre",
                          "ent�o",
                          "era",
                          "eram",
                          "essa",
                          "essas",
                          "esse",
                          "esses",
                          "esta",
                          "estado",
                          "estamos",
                          "estar",
                          "estar�",
                          "estas",
                          "estava",
                          "estavam",
                          "este",
                          "esteja",
                          "estejam",
                          "estejamos",
                          "estes",
                          "esteve",
                          "estive",
                          "estivemos",
                          "estiver",
                          "estivera",
                          "estiveram",
                          "estiverem",
                          "estivermos",
                          "estivesse",
                          "estivessem",
                          "estiveste",
                          "estivestes",
                          "estiv�ramos",
                          "estiv�ssemos",
                          "estou",
                          "est�",
                          "est�s",
                          "est�vamos",
                          "est�o",
                          "eu",
                          "exemplo",
                          "falta",
                          "far�",
                          "favor",
                          "faz",
                          "fazeis",
                          "fazem",
                          "fazemos",
                          "fazer",
                          "fazes",
                          "fazia",
                          "fa�o",
                          "fez",
                          "fim",
                          "final",
                          "foi",
                          "fomos",
                          "for",
                          "fora",
                          "foram",
                          "forem",
                          "forma",
                          "formos",
                          "fosse",
                          "fossem",
                          "foste",
                          "fostes",
                          "fui",
                          "f�ramos",
                          "f�ssemos",
                          "geral",
                          "grande",
                          "grandes",
                          "grupo",
                          "ha",
                          "haja",
                          "hajam",
                          "hajamos",
                          "havemos",
                          "havia",
                          "hei",
                          "hoje",
                          "hora",
                          "horas",
                          "houve",
                          "houvemos",
                          "houver",
                          "houvera",
                          "houveram",
                          "houverei",
                          "houverem",
                          "houveremos",
                          "houveria",
                          "houveriam",
                          "houvermos",
                          "houver�",
                          "houver�o",
                          "houver�amos",
                          "houvesse",
                          "houvessem",
                          "houv�ramos",
                          "houv�ssemos",
                          "h�",
                          "h�o",
                          "iniciar",
                          "inicio",
                          "ir",
                          "ir�",
                          "isso",
                          "ista",
                          "iste",
                          "isto",
                          "j�",
                          "lado",
                          "lhe",
                          "lhes",
                          "ligado",
                          "local",
                          "logo",
                          "longe",
                          "lugar",
                          "l�",
                          "maior",
                          "maioria",
                          "maiorias",
                          "mais",
                          "mal",
                          "mas",
                          "me",
                          "mediante",
                          "meio",
                          "menor",
                          "menos",
                          "meses",
                          "mesma",
                          "mesmas",
                          "mesmo",
                          "mesmos",
                          "meu",
                          "meus",
                          "mil",
                          "minha",
                          "minhas",
                          "momento",
                          "muito",
                          "muitos",
                          "m�ximo",
                          "m�s",
                          "na",
                          "nada",
                          "nao",
                          "naquela",
                          "naquelas",
                          "naquele",
                          "naqueles",
                          "nas",
                          "nem",
                          "nenhuma",
                          "nessa",
                          "nessas",
                          "nesse",
                          "nesses",
                          "nesta",
                          "nestas",
                          "neste",
                          "nestes",
                          "no",
                          "noite",
                          "nome",
                          "nos",
                          "nossa",
                          "nossas",
                          "nosso",
                          "nossos",
                          "nova",
                          "novas",
                          "nove",
                          "novo",
                          "novos",
                          "num",
                          "numa",
                          "numas",
                          "nunca",
                          "nuns",
                          "n�o",
                          "n�vel",
                          "n�s",
                          "n�mero",
                          "o",
                          "obra",
                          "obrigada",
                          "obrigado",
                          "oitava",
                          "oitavo",
                          "oito",
                          "onde",
                          "ontem",
                          "onze",
                          "os",
                          "ou",
                          "outra",
                          "outras",
                          "outro",
                          "outros",
                          "para",
                          "parece",
                          "parte",
                          "partir",
                          "paucas",
                          "pegar",
                          "pela",
                          "pelas",
                          "pelo",
                          "pelos",
                          "perante",
                          "perto",
                          "pessoas",
                          "pode",
                          "podem",
                          "poder",
                          "poder�",
                          "podia",
                          "pois",
                          "ponto",
                          "pontos",
                          "por",
                          "porque",
                          "porqu�",
                          "portanto",
                          "posi��o",
                          "possivelmente",
                          "posso",
                          "poss�vel",
                          "pouca",
                          "pouco",
                          "poucos",
                          "povo",
                          "primeira",
                          "primeiras",
                          "primeiro",
                          "primeiros",
                          "promeiro",
                          "propios",
                          "proprio",
                          "pr�pria",
                          "pr�prias",
                          "pr�prio",
                          "pr�prios",
                          "pr�xima",
                          "pr�ximas",
                          "pr�ximo",
                          "pr�ximos",
                          "puderam",
                          "p�de",
                          "p�e",
                          "p�em",
                          "quais",
                          "qual",
                          "qualquer",
                          "quando",
                          "quanto",
                          "quarta",
                          "quarto",
                          "quatro",
                          "que",
                          "quem",
                          "quer",
                          "quereis",
                          "querem",
                          "queremas",
                          "queres",
                          "quero",
                          "quest�o",
                          "quieto",
                          "quinta",
                          "quinto",
                          "quinze",
                          "qu�is",
                          "qu�",
                          "rela��o",
                          "sabe",
                          "sabem",
                          "saber",
                          "se",
                          "segunda",
                          "segundo",
                          "sei",
                          "seis",
                          "seja",
                          "sejam",
                          "sejamos",
                          "sem",
                          "sempre",
                          "sendo",
                          "ser",
                          "serei",
                          "seremos",
                          "seria",
                          "seriam",
                          "ser�",
                          "ser�o",
                          "ser�amos",
                          "sete",
                          "seu",
                          "seus",
                          "sexta",
                          "sexto",
                          "sim",
                          "sistema",
                          "sob",
                          "sobre",
                          "sois",
                          "somente",
                          "somos",
                          "sou",
                          "sua",
                          "suas",
                          "s�o",
                          "s�tima",
                          "s�timo",
                          "s�",
                          "tal",
                          "talvez",
                          "tambem",
                          "tamb�m",
                          "tanta",
                          "tantas",
                          "tanto",
                          "tarde",
                          "te",
                          "tem",
                          "temos",
                          "tempo",
                          "tendes",
                          "tenha",
                          "tenham",
                          "tenhamos",
                          "tenho",
                          "tens",
                          "tentar",
                          "tentaram",
                          "tente",
                          "tentei",
                          "ter",
                          "terceira",
                          "terceiro",
                          "terei",
                          "teremos",
                          "teria",
                          "teriam",
                          "ter�",
                          "ter�o",
                          "ter�amos",
                          "teu",
                          "teus",
                          "teve",
                          "tinha",
                          "tinham",
                          "tipo",
                          "tive",
                          "tivemos",
                          "tiver",
                          "tivera",
                          "tiveram",
                          "tiverem",
                          "tivermos",
                          "tivesse",
                          "tivessem",
                          "tiveste",
                          "tivestes",
                          "tiv�ramos",
                          "tiv�ssemos",
                          "toda",
                          "todas",
                          "todo",
                          "todos",
                          "trabalhar",
                          "trabalho",
                          "treze",
                          "tr�s",
                          "tu",
                          "tua",
                          "tuas",
                          "tudo",
                          "t�o",
                          "t�m",
                          "t�m",
                          "t�nhamos",
                          "um",
                          "uma",
                          "umas",
                          "uns",
                          "usa",
                          "usar",
                          "vai",
                          "vais",
                          "valor",
                          "veja",
                          "vem",
                          "vens",
                          "ver",
                          "verdade",
                          "verdadeiro",
                          "vez",
                          "vezes",
                          "viagem",
                          "vindo",
                          "vinte",
                          "voc�",
                          "voc�s",
                          "vos",
                          "vossa",
                          "vossas",
                          "vosso",
                          "vossos",
                          "v�rios",
                          "v�o",
                          "v�m",
                          "v�s",
                          "zero",
                          "�",
                          "�s",
                          "�rea",
                          "�",
                          "�ramos",
                          "�s",
                          "�ltimo",
                          "n",
                          "\n",
                          "�",
                          "pra",
                          "produto",
                          "fog�o",
                          "forno",
                          "magazine",
                          "design",
                          "bocas",
                          "veio",
                          "fogao",
                          "t�",
                          "bocas",
                          "luiza",
                          "entrega",
                          "g�s",
                          "mim",
                          "dias",
                          "chegou",
                          "prazo",
                          "chamas",
                          "l�mpada",
                          "expectativas",
                          "cozinha",
                          "vidro",
                          "por�m",
                          "chama",
                          "limpar")

# Minera��o e transforma��o do texto (cria��o do corpus)

library(tm)

# Gerando corpus fog�o
corpus_fogao <- Corpus(VectorSource(tolower(fogao$comentario)))


corpus_fogao_FI <- tm_map(corpus_fogao, removePunctuation)


corpus_fogao_FI <- tm_map(corpus_fogao_FI, removeNumbers)


corpus_fogao_FI <- tm_map(corpus_fogao_FI, removeWords, stopwords_atualizada)



corpus_fogao_FI <- tm_map(corpus_fogao_FI, stripWhitespace)


inspect(corpus_fogao_FI)


corpus_fogao_tf <- TermDocumentMatrix(corpus_fogao_FI, 
                                      control = 
                                      list(minWordLength = 1,minDocFreq=1))

corpus_fogao_tf

corpus_fogao_tdm <- TermDocumentMatrix(corpus_fogao_FI)
corpus_fogao_tdm
corpus_fogao_tdm <- as.matrix(corpus_fogao_tdm)

# Bar Plot - Fog�o

w <- rowSums(corpus_fogao_tdm)
w <- subset(w, w>= 50)
barplot(w,
        las = 2,
        col = rainbow(25))

# corpus_eletrodomestico <- Corpus(VectorSource(tolower(eletrodomestico$comentario)))
# corpus_eletrodomestico_FI <- tm_map(corpus_eletrodomestico, removePunctuation)
# corpus_eletrodomestico_FI <- tm_map(corpus_eletrodomestico_FI, removeNumbers)
# corpus_eletrodomestico_FI <- tm_map(corpus_eletrodomestico_FI, removeWords, stopwords_atualizada)
# corpus_eletrodomestico_FI <- tm_map(corpus_eletrodomestico_FI, stripWhitespace)
# inspect(corpus_eletrodomestico_FI)
# corpus_eletrodomestico_tf <- TermDocumentMatrix(corpus_eletrodomestico_FI, control = list(minWordLength = 1,minDocFreq=1))

# Gerando nuvem de palavras

install.packages("wordcloud")
library("wordcloud")

#Wordcloud
wordcloud(corpus_fogao_tf)
m <- as.matrix(corpus_fogao_tf)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
wordcloud(words = d$word, freq = d$freq, min.freq = 5,
          max.words=1000, random.order=FALSE, rot.per=0.35,
          colors=brewer.pal(8, "Dark2"))


d
#Wordcloud 2
install.packages("wordcloud2")
library("wordcloud2")

m <- as.matrix(corpus_fogao_tf)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
colnames(d) <- c('word','freq')


d
wordcloud2(d,
           size = 0.7,
           shape = 'triangle',
           rotateRatio = 0.5,
           minSize = 1)

letterCloud(d,word = 'f',size = 0.7)

letterCloud(demoFreq, word='R')
letterCloud( demoFreq, word = "R", color='random-light' , backgroundColor="black")

#Criar dataframes para os cinco itens mais comercializados de cada categoria, eletrodomesticos e eletronicos - OK


# https://www.youtube.com/watch?v=otoXeVPhT7Q


# An�lise de sentimentos


install.packages("syuzhet")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("scales")
install.packages("reshape2")
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

get_nrc_sentiment("bonita", lang = "portuguese")

xLabel <- c("Raiva","Expectativa","Desgosto","Medo","Alegria","Tristeza","Surpresa","Confian�a","Negativo","Positivo")
analiseFogao <- get_nrc_sentiment(fogao$comentario, lang = "portuguese")
barplot(colSums(analiseFogao),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Fog�o',
        names.arg=xLabel,
        
        )

negative <- which(analiseFogao$negative > 0)
fogao$comentario[negative]

analiseMaquinalavar <- get_nrc_sentiment(maquina_lavar$comentario, lang = "portuguese")
barplot(colSums(analiseMaquinalavar),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: M�quina Lavar',
        names.arg=xLabel
)

analiseCooktop <- get_nrc_sentiment(cooktop$comentario, lang = "portuguese")
barplot(colSums(analiseCooktop),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Cooktop',
        names.arg=xLabel
)

analiseGeladeira <- get_nrc_sentiment(geladeira$comentario, lang = "portuguese")
barplot(colSums(analiseGeladeira),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Geladeira',
        names.arg=xLabel
)

analiseDepurador <- get_nrc_sentiment(depurador$comentario, lang = "portuguese")
barplot(colSums(analiseDepurador),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Depurador',
        names.arg=xLabel
)

analiseSmartTV <- get_nrc_sentiment(smart_tv$comentario, lang = "portuguese")
barplot(colSums(analiseSmartTV),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Smart TV',
        names.arg=xLabel
)

analiseSmartphone_samsung <- get_nrc_sentiment(smartphone_samsung$comentario, lang = "portuguese")
barplot(colSums(analiseSmartphone_samsung),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Smartphone Samsung',
        names.arg=xLabel
)

analiseSmartphone_lg <- get_nrc_sentiment(smartphone_lg$comentario, lang = "portuguese")
barplot(colSums(analiseSmartphone_lg),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Smartphone LG',
        names.arg=xLabel
)

analiseSmartphone_motorola <- get_nrc_sentiment(smartphone_motorola$comentario, lang = "portuguese")
barplot(colSums(analiseSmartphone_motorola),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Smartphone Motorola',
        names.arg=xLabel
)

analiseSmartphone_iphone <- get_nrc_sentiment(smartphone_iphone$comentario, lang = "portuguese")
barplot(colSums(analiseSmartphone_iphone),
        las = 2,
        col = rainbow(10),
        ylab = 'Qtde',
        main = 'An�lise de sentimentos: Smartphone Iphone',
        names.arg=xLabel
)

        