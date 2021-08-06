import requests

def cria_link(ponto_de_inicio):
    """Função responsável por criar os links das páginas baseado em um número passado na função (ponto de início)"""
    prefixo_link = "https://www.gov.br/mre/pt-br/canais_atendimento/imprensa/notas-a-imprensa"
    sufixo_link = "?b_start:int="
    return f"{prefixo_link}{sufixo_link}{ponto_de_inicio}"


def coleta_paginas():
    """"Função que passa por todas as paginas salvando o conteúdo em arquivos na pasta paginas_brutas"""
    for i in range(0,3991, 30):
        response = requests.get(cria_link(i))
        with open(f'C:\\Users\\HCMDS\\Documents\\artigo-abri\\notas-mre\\paginas_brutas\\pagina{i}.html', 'w', encoding="utf-8") as file:
            file.write(response.text)    
        



if __name__ == '__main__':
    coleta_paginas()