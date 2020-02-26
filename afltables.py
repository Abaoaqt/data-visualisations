import pandas as pd
import os
from selenium import webdriver

#   this file contains a basic script that will access afltables.com 
#   and retrieve and serialise data related to a teams year-by-year performances.

#Team Names
'''
adelaide
brisbaneb   (bears)(defunct)
brisbanel   (lions)
bullldogs   (sic) (western bulldogs)
carlton
collingwood
essendon
fitzroy     (defunct)
fremantle
geelong
goldcoast
gws         (greater western sydney)
hawthorn
kangaroos   (north melbourne)
melbourne
padelaide   (port adelaide)
stkilda
swans       (south melbourne / sydney)
university  (defunct)
westcoast
'''
#modify name using the above list
team = 'bullldogs'

website = 'https://afltables.com/afl/teams/{}/season.html'.format(team)

#**an up to date version of chromedriver is needs to be present in the Python language folder**
driver = webdriver.Chrome()

driver.get(website)
#find the number of rows there are (seasons played)
seasons = len(driver.find_elements_by_xpath('//*[@id="sortableTable0"]/tbody/tr'))

#df for storage
tbl = pd.DataFrame(columns = ['Year', 'Position', 'Total_Teams', 'Played', 'Won', 'Lost', 'Drawn', 'Points', 'Premiership'])

#parsing rows for the relevant data
for season in range(1, seasons +1):
    #get the value from the rank column for each season
    xpath = r'//*[@id="sortableTable0"]/tbody/tr[{}]'.format(season)
    rank_str = driver.find_element_by_xpath(xpath + '/td[15]').get_attribute("innerHTML")
    pos, total = rank_str.split('/')
    pos = int(pos)
    total = int(total)

    #getting the year as well (not necessary)
    year = int(driver.find_element_by_xpath(xpath + '/td[1]/a').get_attribute("innerHTML"))

    played = int(driver.find_element_by_xpath(xpath + '/td[2]').get_attribute("innerHTML"))

    won = driver.find_element_by_xpath(xpath + '/td[3]').get_attribute("innerHTML")
    if won  == '&nbsp;':
        won = 0
    else:
        won = int(won)

    drawn = driver.find_element_by_xpath(xpath + '/td[4]').get_attribute("innerHTML")
    if drawn  == '&nbsp;':
        drawn = 0
    else:
        drawn = int(drawn)

    lost = driver.find_element_by_xpath(xpath + '/td[5]').get_attribute("innerHTML")
    if lost  == '&nbsp;':
        lost = 0
    else:
        lost = int(lost)

    prem = driver.find_element_by_xpath(xpath + '/td[16]').get_attribute("innerHTML")
    if prem  == '&nbsp;':
        prem = False
    elif prem == 'X':
        prem = True

    points = 4 * won + 2 * drawn
    #print(year, pos, total, played, won, lost, drawn, prem, points)

    #storing the data
    row = pd.DataFrame([[year, pos, total, played, won, lost, drawn, prem, points]], columns = ['Year', 'Position', 'Total_Teams', 'Played', 'Won', 'Lost', 'Drawn', 'Premiership', 'Points'])
    tbl = tbl.append(row)

#save file to your location of choice
path = "enter-path-here"
tbl.to_csv(path + "/{}.csv".format(team), index = False)
driver.close()
