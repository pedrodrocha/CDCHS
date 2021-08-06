from bs4 import BeautifulSoup


def insere_dados_no_csv(symbol, title, authors, date, notes, file):
    with open(file, 'a'):
        file.write(f"{symbol}, {title}, {authors}, {date}, {notes} \n")


def parseia_pagina(pagina):
    soup = BeautifulSoup(pagina)
    infos = soup.find('div', id="details-collapse")
    symbol = infos.find('span', class_='value col-xs-12 col-sm-9 col-md-10').get_text()
    title = infos.find('span', class_='value col-xs-12 col-sm-9 col-md-10').get_text()
    authors = infos.find('span', class_='value col-xs-12 col-sm-9 col-md-10').get_text()
    date = infos.find('span', class_='value col-xs-12 col-sm-9 col-md-10').get_text()
    notes = infos.find('span', class_='value col-xs-12 col-sm-9 col-md-10').get_text()
    return symbol, title, authors, date, notes

def main():
    file = 'C:\Users\HCMDS\Documents\artigo-abri\coleta-onu\links.txt'
    paginas = open(file, 'r').readlines()
    for pagina in paginas:
        symbol, title, authores, date, notes = parseia_pagina(pagina)
        insere_dados_no_csv(symbol, title, authores, date, notes, file)

if __name__== '__main__':
    main()