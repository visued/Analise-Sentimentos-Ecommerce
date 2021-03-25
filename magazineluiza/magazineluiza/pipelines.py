# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import psycopg2


class MagazineluizaPipeline:
    def __init__(self):
        self.create_connection()
        self.create_table()

    def create_connection(self):
        # Connect to an existing database
        self.conn = psycopg2.connect("host='172.17.0.3' dbname='crawler' user='postgres' password='mysecretpassword'")

        # Open a cursor to perform database operations
        self.curr = self.conn.cursor()

    def create_table(self):
        # Execute a command: this creates a new table
        self.curr.execute("""DROP TABLE IF EXISTS MagazineLuiza""")
        self.curr.execute("""CREATE TABLE MagazineLuiza2 (
                        id serial PRIMARY KEY, 
                        codigo_produto varchar,
                        nome_consumidor varchar,                        
                        categoria varchar,
                        segmento varchar,
                        nome_produto varchar,
                        data timestamp, 
                        rating numeric,
                        likes   numeric,
                        dislikes numeric,
                        titulo varchar,
                        comentario varchar,
                        localizacao varchar);""")

    def process_item(self, item, spider):
        self.store_database(item);
        return item

    def store_database(self, item):
        self.curr.execute("insert into MagazineLuiza2 (codigo_produto, nome_consumidor, categoria, segmento, nome_produto, data, rating, likes, dislikes, titulo, comentario, localizacao) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
                            (item['codigo_produto'], 
                            item['nome_consumidor'],                             
                            item['categoria'], 
                            item['segmento'], 
                            item['nome_produto'], 
                            item['data'], 
                            item['rating'], 
                            item['likes'], 
                            item['dislikes'], 
                            item['titulo'], 
                            item['comentario'], 
                            item['localizacao']))
        self.conn.commit()

