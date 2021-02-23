import scrapy
import re
import requests

# Spider da Magazine Luiza
# Responsavel por extrair os comentarios no site da Magazine Luiza.
class MlSpider(scrapy.Spider):
    name = 'ml'
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0',
        'X-Requested-With': 'XMLHttpRequest'
    }
    page = 1

    def start_requests(self):
        urls = ['https://www.magazineluiza.com.br/eletrodomesticos/l/ed?page={}'.format(1),
                'https://www.magazineluiza.com.br/smartphone/celulares-e-smartphones/s/te/tcsp?page={}'.format(1),
                'https://www.magazineluiza.com.br/smart-tv/tv-e-video/s/et/elit?page={}'.format(1)]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.pega_qtd_paginas)
                

    def pega_qtd_paginas(self, response, **kwargs):
        qtd_paginas = response.xpath('//ul[@class="css-9j990n"]//li[9]//a//text()').get()

        for pagina in range(int(qtd_paginas)): 
            yield scrapy.Request(url=response.url[:-1]+str(pagina+1), callback=self.extrair_links)


    def extrair_links(self, response, **kwargs):
        for i in response.xpath('//a[@name="linkToProduct"]'):
            link_produto = i.xpath('@href').get()

            yield scrapy.Request(url=link_produto, callback=self.extrair_dados)
                        

    def extrair_dados(self, response, **kwargs):
        codigo_produto = re.findall('[^Código](.*)', response.xpath('.//small[@class="header-product__code"]//text()').get())[0]
        url_comentarios = 'https://www.magazineluiza.com.br/review/{}/?page=1'.format(codigo_produto.strip()) 

        requisicao = requests.get(url_comentarios, headers=self.headers)
        if(requisicao.status_code == requests.codes.ok and requisicao.headers['content-type'] == 'application/json; charset=utf-8'):
            print(150 * '=')
            for i in range(requisicao.json()['data']['pages']):                
                requisicao = requests.get(url_comentarios[:-1]+str(i+1))
                if(requisicao.status_code == requests.codes.ok and requisicao.headers['content-type'] == 'application/json; charset=utf-8'):
                    print(requisicao.json())