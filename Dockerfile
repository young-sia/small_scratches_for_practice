FROM python:3.10.0

COPY requirements.txt .

RUN pip install -r requirements.txt && rm requirements.txt

COPY mail_scrap.py .

CMD ["python", "mail_scrap.py"]
