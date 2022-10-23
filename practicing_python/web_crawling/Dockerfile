FROM python:3.10.0

COPY ../../requirements.txt .

RUN pip install -r requirements.txt && rm requirements.txt

COPY scrape_from_urls.py .

CMD ["python", "scrape_from_urls.py"]
