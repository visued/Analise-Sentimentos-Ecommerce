# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class MagazineluizaItem(scrapy.Item):
    
    codigo_produto = scrapy.Field()
    nome_consumidor = scrapy.Field()
    categoria = scrapy.Field()
    segmento = scrapy.Field()
    nome_produto = scrapy.Field()
    data = scrapy.Field()
    rating = scrapy.Field()
    likes = scrapy.Field()
    dislikes = scrapy.Field()
    titulo = scrapy.Field()
    comentario = scrapy.Field()
    localizacao = scrapy.Field()
    
