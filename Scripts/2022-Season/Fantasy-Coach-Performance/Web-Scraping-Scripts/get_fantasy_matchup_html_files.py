# Import webdriver from selenium
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import os

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

# Navigate to draft overview page
driver.find_element(By.XPATH, '//*[@id="root"]/div[2]/div[2]/div[1]/div/div[2]/div[3]/div/a').click()

# Navigate to full fixtures page
driver.find_element(By.XPATH, '//*[@id="root"]/div[4]/div/div[1]/h2[1]/a').click()

# Get select element
select = Select(driver.find_element(By.XPATH, '//*[@id="root"]/div[4]/div/div/div[1]/div/select'))

##%######################################################%##
#                                                          #
####    Change to desired round and get HTML of page    ####
#                                                          #
##%######################################################%##

# Round 1
select.select_by_value('1')
round_1 = driver.page_source
output_1 = open("Data/HTML-files/matchups/round_01_matchups.html", "w")
output_1.write(round_1)
output_1.close()

# Round 2
select.select_by_value('2')
round_2 = driver.page_source
output_2 = open("Data/HTML-files/matchups/round_02_matchups.html", "w")
output_2.write(round_2)
output_2.close()

# Round 3
select.select_by_value('3')
round_3 = driver.page_source
output_3 = open("Data/HTML-files/matchups/round_03_matchups.html", "w")
output_3.write(round_3)
output_3.close()

# Round 4
select.select_by_value('4')
round_4 = driver.page_source
output_4 = open("Data/HTML-files/matchups/round_04_matchups.html", "w")
output_4.write(round_4)
output_4.close()

# Round 5
select.select_by_value('5')
round_5 = driver.page_source
output_5 = open("Data/HTML-files/matchups/round_05_matchups.html", "w")
output_5.write(round_5)
output_5.close()

# Round 6
select.select_by_value('6')
round_6 = driver.page_source
output_6 = open("Data/HTML-files/matchups/round_06_matchups.html", "w")
output_6.write(round_6)
output_6.close()

# Round 7
select.select_by_value('7')
round_7 = driver.page_source
output_7 = open("Data/HTML-files/matchups/round_07_matchups.html", "w")
output_7.write(round_7)
output_7.close()

# Round 8
select.select_by_value('8')
round_8 = driver.page_source
output_8 = open("Data/HTML-files/matchups/round_08_matchups.html", "w")
output_8.write(round_8)
output_8.close()

# Round 9
select.select_by_value('9')
round_9 = driver.page_source
output_9 = open("Data/HTML-files/matchups/round_09_matchups.html", "w")
output_9.write(round_9)
output_9.close()

# Round 10
select.select_by_value('10')
round_10 = driver.page_source
output_10 = open("Data/HTML-files/matchups/round_10_matchups.html", "w")
output_10.write(round_10)
output_10.close()

# Round 11
select.select_by_value('11')
round_11 = driver.page_source
output_11 = open("Data/HTML-files/matchups/round_11_matchups.html", "w")
output_11.write(round_11)
output_11.close()

# Round 15
select.select_by_value('15')
round_15 = driver.page_source
output_15 = open("Data/HTML-files/matchups/round_15_matchups.html", "w")
output_15.write(round_15)
output_15.close()

# Round 16
select.select_by_value('16')
round_16 = driver.page_source
output_16 = open("Data/HTML-files/matchups/round_16_matchups.html", "w")
output_16.write(round_16)
output_16.close()

# Round 17
select.select_by_value('17')
round_17 = driver.page_source
output_17 = open("Data/HTML-files/matchups/round_17_matchups.html", "w")
output_17.write(round_17)
output_17.close()
