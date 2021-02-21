import scrapy
import re
import requests

# Spider da Magazine Luiza
class MlSpider(scrapy.Spider):
    name = 'ml'
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0',
        'X-Requested-With': 'XMLHttpRequest'
    }

    def start_requests(self):
        urls = ['https://www.magazineluiza.com.br/eletrodomesticos/l/ed?page=1',
                'https://www.magazineluiza.com.br/smartphone/celulares-e-smartphones/s/te/tcsp?page=1',
                'https://www.magazineluiza.com.br/smart-tv/tv-e-video/s/et/elit?page=1']
        for url in urls:
            yield scrapy.Request(url=url, callback=self.extrair_links_produtos)

    def extrair_links_produtos(self, response, **kwargs):
        for i in response.xpath('//a[@name="linkToProduct"]'):
            link_produto = i.xpath('@href').get()

            yield scrapy.Request(url=link_produto, callback=self.extrair_dados)
                        

    
    def extrair_dados(self, response, **kwargs):

        codigo_produto = re.findall('[^Código](.*)', response.xpath('.//small[@class="header-product__code"]//text()').get())[0]
        url_busca_comentarios = 'https://www.magazineluiza.com.br/review/{}/?page=1'.format(codigo_produto.strip())        
        requisicao = requests.get(url_busca_comentarios, headers=self.headers)
        print(requisicao.json())     