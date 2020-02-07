from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support.wait import WebDriverWait
import time
import os
from shutil import which


class wait_until_contains_css_class:
  def __init__(self, locator, class_name):
    self._locator = locator
    self._class_name = class_name

  def __call__(self, driver):
    element = driver.find_element_by_xpath(self._locator)
    if self._class_name in element.get_attribute('class'):
      return element.get_attribute('class')
    else:
      return False


def setup():
  from dotenv import load_dotenv
  load_dotenv()

def get_base_url():
  return os.getenv("WEB_HOST")
def get_browser_driver_path():
  return "node_modules/geckodriver/bin/geckodriver"

def accordion_test():
  setup()
  opts = Options()
  opts.binary = which("firefox")
  #opts.add_argument('--headless')
  opts.add_argument('--no-sandbox')
  opts.add_argument('--disable-dev-shm-usage')

  driver = webdriver.Firefox(executable_path=get_browser_driver_path(), options=opts)
  driver.maximize_window()
  driver.get(get_base_url())
  element = driver.find_element_by_id('accordionExample')
  assert element is not None
  collapse_one = driver.find_element_by_xpath('//*[@id="collapseOne"]')
  assert 'show' in collapse_one.get_attribute('class')
  collapse_button_two = driver.find_element_by_xpath('//*[@id="headingTwo"]/h2/button')
  collapse_button_two.click()
  collapse_one = driver.find_element_by_xpath('//*[@id="collapseOne"]')
  assert 'show' not in collapse_one.get_attribute('class')
  WebDriverWait(driver, 2).until(
    wait_until_contains_css_class('//*[@id="collapseTwo"]', "show")
  )
  driver.quit()
  print('Accordion OK')

accordion_test()


