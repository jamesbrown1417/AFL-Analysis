# Import webdriver from selenium
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By

# Get login credentials
username = "james_brown1417@hotmail.com"
password = "Plasma^0836"

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

# Navigate to draft overview page
driver.find_element(By.XPATH, '//*[@id="root"]/div[2]/div[2]/div[1]/div/div[2]/div[3]/div/a').click()

# Navigate to full fixtures page
driver.find_element(By.XPATH, '//*[@id="root"]/div[4]/div/div[1]/h2[1]/a').click()

