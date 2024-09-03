FROM python:3.12

WORKDIR /app

COPY . /app/

RUN pip install --no-cache-dir --upgrade .

EXPOSE 8000

CMD [ "fastapi", "run", "/app/fun7/main.py", "--port", "8000" ]