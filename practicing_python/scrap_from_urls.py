from selenium import webdriver
from selenium.webdriver.common.by import By
import pyperclip
import time

import requests
from requests import post, get
import os
import prefect
from prefect import task, Flow
import mysql.connector


# log_in to naver
@task(log_stdout=True)
def nate_mail_scrap(nate_ids, nate_pws, url, url_specific):
    driver_login = webdriver.Chrome('D:\projects\some_small_scratches\practicing_python\chromedriver.exe')
    driver_login.get('http://home.mail.nate.com/')
    time.sleep(0.5)
    tag_id = driver_login.find_element(By.NAME, 'ID')
    tag_id.clear()
    tag_pw = driver_login.find_element(By.NAME, 'PASSWD')
    tag_pw.clear()
    time.sleep(1)
    tag_id.click()
    pyperclip.copy(nate_ids)
    tag_id.send_keys(nate_ids)
    time.sleep(0.5)
    tag_pw.click()
    pyperclip.copy(nate_pws)
    tag_pw.send_keys(nate_pws)
    time.sleep(0.5)
    login_btn = driver_login.find_element(By.CLASS_NAME, 'btn_login')
    login_btn.click()
    time.sleep(2)

    logger = prefect.context.get("logger")
    session = requests.Session()
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36',
    }
    _cookies = driver_login.get_cookies()
    cookie_dict = {}
    for cookie in _cookies:
        cookie_dict[cookie['name']] = cookie['value']
    logger.info('going in to naver_mail')
    driver_login.get('https://mail3.nate.com/')
    session.headers.update(headers)
    session.cookies.update(cookie_dict)

    mail_text_response = get(url='https://mail3.nate.com/', cookies=cookie_dict)
    logger.info(f'got mail info{mail_text_response.text}')
    mail_params = dict()
    for _ in url_specific.split('&'):
        mail_params[_.split('=')[0]] = _.split('=')[1]
    resp = post(url, data=mail_params, cookies=cookie_dict)
    response = resp.json()
    logger.info(resp.text)
    return response


@task(log_stdout=True)
def naver_mail_scrap(naver_ids, naver_pws, url, url_specific):
    driver_login = webdriver.Chrome('D:\projects\some_small_scratches\practicing_python\chromedriver.exe')
    driver_login.get('https://nid.naver.com/nidlogin.login')
    time.sleep(0.5)
    tag_id = driver_login.find_element(By.NAME, 'id')
    tag_id.clear()
    tag_pw = driver_login.find_element(By.NAME, 'pw')
    tag_pw.clear()
    time.sleep(1)
    tag_id.click()
    pyperclip.copy(naver_ids)
    tag_id.send_keys(naver_ids)
    time.sleep(0.5)
    tag_pw.click()
    pyperclip.copy(naver_pws)
    tag_pw.send_keys(naver_pws)
    time.sleep(0.5)
    login_btn = driver_login.find_element(By.ID, 'log.login')
    login_btn.click()
    time.sleep(2)

    logger = prefect.context.get("logger")
    session = requests.Session()
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36',
    }
    _cookies = driver_login.get_cookies()
    cookie_dict = {}
    for cookie in _cookies:
        cookie_dict[cookie['name']] = cookie['value']
    logger.info('going in to naver_mail')
    driver_login.get('https://mail.naver.com/')
    session.headers.update(headers)
    session.cookies.update(cookie_dict)

    mail_text_response = get(url='https://mail.naver.com', cookies=cookie_dict)
    logger.info(f'got mail info{mail_text_response.text}')
    mail_params = dict()
    for _ in url_specific.split('&'):
        mail_params[_.split('=')[0]] = _.split('=')[1]
    resp = post(url, data=mail_params, cookies=cookie_dict)
    response = resp.json()
    logger.info(resp.text)
    return response


@task(log_stdout=True)
def transform_naver_mail_data(response, index):
    logger = prefect.context.get("logger")
    logger.info('transforming mail data')
    formatted_mail_data = [[mail['from']['name'], mail['subject'], mail['receivedTime'], mail['spamType']]
                           for mail in response['mailData']]
    formatted_mail_data += [index]
    logger.info(f'reformatted {len(formatted_mail_data)} records')
    return formatted_mail_data


@task(log_stdout=True)
def transform_nate_mail_data(response, index):
    logger = prefect.context.get("logger")
    logger.info('transforming mail data')
    formatted_mail_data = [[mail['headerFrom'], mail['subject'], mail['receivedAt'], mail['mboxid']]
                           for mail in response['messages']]
    formatted_mail_data += [index]
    logger.info(f'reformatted {len(formatted_mail_data)} records')
    return formatted_mail_data


@task(log_stdout=True)
def store_naver_mail(records):
    logger = prefect.context.get('logger')
    logger.info('connecting to the database')
    connection = mysql.connector.connect(
        host=os.getenv('DATABASE_HOST', 'database'),
        user=os.getenv('DATABASE_USER', 'root'),
        password=os.getenv('DATABASE_PASSWORD', 'mariadb'),
        database=os.getenv('DATABASE_SCHEMA', 'practice'),
    )
    cursor = connection.cursor()
    sql = 'insert into scraping_mail_naver(mail_title, contents, received_date, classify) values(%s, %s, %d, %s)'
    logger.info('inserting mail scrap data')
    cursor.executemany(sql, records)
    connection.commit()


@task(log_stdout=True)
def store_nate_mail(records):
    logger = prefect.context.get('logger')
    logger.info('connecting to the database')
    connection = mysql.connector.connect(
        host=os.getenv('DATABASE_HOST', 'database'),
        user=os.getenv('DATABASE_USER', 'root'),
        password=os.getenv('DATABASE_PASSWORD', 'mariadb'),
        database=os.getenv('DATABASE_SCHEMA', 'practice'),
    )
    cursor = connection.cursor()
    sql = 'insert into scraping_mail_nate(mail_title, contents, received_date, classify) values(%s, %s, %d, %s)'
    logger.info('inserting mail scrap data')
    cursor.executemany(sql, records)
    connection.commit()


with Flow("Naver mail scraping") as flow:
    naver_id = os.getenv('NAVER_ID')
    naver_pw = os.getenv('NAVER_PW')
    url_naver = 'https://mail.naver.com/json/list/?'
    url_specific_naver = 'page=1&sortField=1&sortType=0&folderSN=0&type=&isUnread=false&u=~~~~'
    url_specific_naver_spam = 'page=1&sortField=1&sortType=0&folderSN=5&type=&isUnread=false&u=~~~'
    naver_mail = naver_mail_scrap(naver_id, naver_pw, url_naver, url_specific_naver)
    naver_mail_spam = naver_mail_scrap(naver_id, naver_pw, url_naver, url_specific_naver_spam)
    naver_mail_data = transform_naver_mail_data(naver_mail)
    naver_mail_spam_data = transform_naver_mail_data(naver_mail_spam)
    store_naver_mail(naver_mail_data)
    store_naver_mail(naver_mail_spam_data)

    nate_id = os.getenv('NATE_ID')
    nate_pw = os.getenv('NATE_PW')
    url_nate = 'https://mail3.nate.com/app/newmail/msg/maillist/?'
    url_specific_nate = 'ts=~~~~~'
    nate_mail = nate_mail_scrap.run(nate_id, nate_pw, url_nate, url_specific_nate)
    nate_mail_data = transform_nate_mail_data(nate_mail)
    store_nate_mail(nate_mail_data)


flow.run()
