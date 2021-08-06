import os
from bs4 import BeautifulSoup

def lista_de_paginas():
    """Retorna o local onde estão os arquivos"""
    return os.listdir(get_caminho())

def get_caminho():
    """Define o local onde os espera que os arquivos estejam armazenados"""
    return 'C:\\Users\HCMDS\Documents\\artigo-abri\\notas-mre\\paginas_brutas'


def insere_infos_no_csv(nome, titulo, data, tipo):
    """Insere as informações parseadas no csv"""
    with open('tabela.csv', 'a', encoding='UTF-8') as file:
        file.write(f'{nome};{titulo};{data};{tipo}\n')


def parseia_documento(pagina):
    """Retira do documento HTML as informações relevantes"""
    with open(f'{get_caminho()}\\{pagina}', encoding='UTF-8') as file:
        soup = BeautifulSoup(file, "lxml")
        conteudo = soup.find('div', id="content-core" )
        noticias = conteudo.find_all('article', class_="tileItem visualIEFloatFix tile-collective-nitf-content")
        for noticia in noticias:
            nome = noticia.find('span', class_="subtitle").get_text().strip()
            titulo = noticia.find('h2').get_text().strip()
            infos = noticia.find_all('span', class_='summary-view-icon')
            print(type(infos))
            data = infos[0].get_text().strip()
            tipo = infos[2].get_text().strip()    
            print(nome, titulo, data, tipo)
            insere_infos_no_csv(nome,titulo, data, tipo)
            break

 
if __name__ == '__main__':
    paginas = lista_de_paginas()
    paginas.sort()
    for pagina in paginas:
        parseia_documento(pagina)
        