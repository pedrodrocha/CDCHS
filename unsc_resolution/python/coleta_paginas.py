from selenium import webdriver
from time import sleep
import sh
import selenium
from bs4 import BeautifulSoup
from time import sleep


def coleta_links(driver):
    sleep(5)
    links = []
    html = driver.page_source
    soup = BeautifulSoup(html)
    lista_de_divs = soup.find_all('div', class_='result-title')
    for i in lista_de_divs:
        links.append(i.get_attribute(i))
    return links


def monta_url(n):
    return "https://digitallibrary.un.org/search?ln=en&cc=Security%20Council&p=&f=&rm=&ln=en&sf=&so=d&rg=200&c=Security%20Council&c=&of=hb&fti=0&fct__1=Resolutions%20and%20Decisions&fti=0&fct__1=Resolutions%20and%20Decisions&fct__3={}".format(n)

def main():
    file = 'C:\Users\HCMDS\Documents\artigo-abri\coleta-onu\links.txt'
    links = []
    driver = webdriver.Firefox()
    url_base = "https://digitallibrary.un.org/search?ln=en&cc=Security%20Council&p=&f=&rm=&ln=en&sf=&so=d&rg=200&c=Security%20Council&c=&of=hb&fti=0&fct__1=Resolutions%20and%20Decisions&fti=0&fct__1=Resolutions%20and%20Decisions&fct__3=1946" 
    driver.get(url_base)
    coleta_links(driver)
    for i in range(1947, 2021):
        driver.get(monta_url(i))
        links.append(coleta_links(driver))
        with open(file, 'w'):
            file.write(links)






if __name__ == '__main__':
    main()
