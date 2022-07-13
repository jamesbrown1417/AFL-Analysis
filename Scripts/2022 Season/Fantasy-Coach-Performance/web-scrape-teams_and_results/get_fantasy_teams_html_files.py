# Import webdriver from selenium
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import os
import time

# Get login credentials
username = os.environ["AFL_LOGIN"]
password = os.environ["AFL_PASSWORD"]

# initialize the Chrome driver
driver = webdriver.Chrome("chromedriver")

# head to Fantasy login page
driver.get("https://fantasy.afl.com.au/")

# Find username field and send the username to the input field
driver.find_element(By.XPATH,'//*[@id="login-root"]/div/form/div/div[1]/div/div[1]/input').send_keys(username)

# Find password field and send the password to the input field
driver.find_element(By.XPATH, '//*[@id="login-root"]/div/form/div/div[2]/div/div[1]/input').send_keys(password)

# click login button
driver.find_element(By.XPATH, '//*[@id="login-root"]/div/form/button').click()

# Wait for page to load
driver.implicitly_wait(5)

# Navigate to full teams overview page
driver.get("https://fantasy.afl.com.au/draft/league/95483/team-breakdowns")

# Get select element
select = Select(driver.find_element(By.XPATH, '//*[@id="root"]/div[4]/div/div/div[1]/select'))

##%######################################################%##
#                                                          #
####    Change to desired round and get HTML of page    ####
#                                                          #
##%######################################################%##

# Round 1
time.sleep(1)
select.select_by_value('1')
time.sleep(2)
round_1 = driver.page_source
output_1 = open("Data/HTML-files/teams/round_01_teams.html", "w")
output_1.write(round_1)
output_1.close()
time.sleep(1)

# Round 2
select.select_by_value('2')
time.sleep(1)
round_2 = driver.page_source
output_2 = open("Data/HTML-files/teams/round_02_teams.html", "w")
output_2.write(round_2)
output_2.close()
time.sleep(1)

# Round 3
select.select_by_value('3')
time.sleep(1)
round_3 = driver.page_source
output_3 = open("Data/HTML-files/teams/round_03_teams.html", "w")
output_3.write(round_3)
output_3.close()
time.sleep(1)

# Round 4
select.select_by_value('4')
time.sleep(1)
round_4 = driver.page_source
output_4 = open("Data/HTML-files/teams/round_04_teams.html", "w")
output_4.write(round_4)
output_4.close()
time.sleep(1)

# Round 5
select.select_by_value('5')
time.sleep(1)
round_5 = driver.page_source
output_5 = open("Data/HTML-files/teams/round_05_teams.html", "w")
output_5.write(round_5)
output_5.close()
time.sleep(1)

# Round 6
select.select_by_value('6')
time.sleep(1)
round_6 = driver.page_source
output_6 = open("Data/HTML-files/teams/round_06_teams.html", "w")
output_6.write(round_6)
output_6.close()
time.sleep(1)

# Round 7
select.select_by_value('7')
time.sleep(1)
round_7 = driver.page_source
output_7 = open("Data/HTML-files/teams/round_07_teams.html", "w")
output_7.write(round_7)
output_7.close()
time.sleep(1)

# Round 8
select.select_by_value('8')
time.sleep(1)
round_8 = driver.page_source
output_8 = open("Data/HTML-files/teams/round_08_teams.html", "w")
output_8.write(round_8)
output_8.close()
time.sleep(1)

# Round 9
select.select_by_value('9')
time.sleep(1)
round_9 = driver.page_source
output_9 = open("Data/HTML-files/teams/round_09_teams.html", "w")
output_9.write(round_9)
output_9.close()
time.sleep(1)

# Round 10
select.select_by_value('10')
time.sleep(1)
round_10 = driver.page_source
output_10 = open("Data/HTML-files/teams/round_10_teams.html", "w")
output_10.write(round_10)
output_10.close()
time.sleep(1)

# Round 11
select.select_by_value('11')
time.sleep(1)
round_11 = driver.page_source
output_11 = open("Data/HTML-files/teams/round_11_teams.html", "w")
output_11.write(round_11)
output_11.close()
time.sleep(1)

# Round 15
select.select_by_value('15')
time.sleep(1)
round_15 = driver.page_source
output_15 = open("Data/HTML-files/teams/round_15_teams.html", "w")
output_15.write(round_15)
output_15.close()
time.sleep(1)

# Round 16
select.select_by_value('16')
time.sleep(1)
round_16 = driver.page_source
output_16 = open("Data/HTML-files/teams/round_16_teams.html", "w")
output_16.write(round_16)
output_16.close()
time.sleep(1)

# Round 17
select.select_by_value('17')
time.sleep(1)
round_17 = driver.page_source
output_17 = open("Data/HTML-files/teams/round_17_teams.html", "w")
output_17.write(round_17)
output_17.close()
time.sleep(1)
