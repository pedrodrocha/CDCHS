library(rvest)
library(purrr)
library(stringr)
library(tibble)

# 1. Setup para coletar os links

# a) Criar links para cada uma das páginas

link_base <- "https://www.gov.br/mre/pt-br/canais_atendimento/imprensa/notas-a-imprensa"
q_complemento <- "?b_start:int="
n_pag <- seq(0, 3960,30)

links_para_paginas <- map_chr(n_pag,function(x){
  paste0(link_base,q_complemento,x)
})

# b) Coletar links para as notas

links_para_notas <- map(links_para_paginas, function(x){
  read_html(x) %>%
    html_nodes('.url') %>%
    html_attr('href')
}) %>%
  flatten_chr()


# 2. Coleta das infos e estruturação dos dados

dados <- imap_dfr(links_para_notas, function(x, .y){
  print(x)
  url_lido <- read_html(x)

  titulo <- url_lido %>%
    html_node('.documentFirstHeading') %>%
    html_text()

  data_publicacao <- url_lido %>%
    html_node('.value') %>%
    html_text()

  conteudo <- url_lido %>%
    html_nodes('#content-core') %>%
    html_text() %>%
    str_remove_all('\\n') %>%
    str_trim()

  tibble(
    titulo = titulo,
    data = data_publicacao,
    conteudo = conteudo
  )


})

readr::write_csv(dados, '2021-04-29_dados.csv')


