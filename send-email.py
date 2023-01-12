# dataframe
import pandas as pd

dataframe = pd.read_excel('test.xlsx')

# environment variables
import os

EMAIL_USER = os.environ.get('EMAIL_USER')
EMAIL_PASSWORD = os.environ.get('EMAIL_PASSWORD')

# simple mail transfer protocol
import smtplib, ssl
from email.message import EmailMessage

smtp_server = 'smtp.gmail.com'
port = 465

# script
with smtplib.SMTP_SSL(smtp_server,port) as smtp:
    smtp.login(EMAIL_USER,EMAIL_PASSWORD)

    for index, row in dataframe.iterrows():
        body = 'Sending to {}'.format(row['Name'])

        msg = EmailMessage() 

        msg['From'] = EMAIL_USER
        msg['To'] = row['Email']
        msg['Subject'] = 'test'
        msg.set_content(body)

        smtp.send_message(msg)
        print('Sent to {}'.format(row['Name']))