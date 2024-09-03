from fastapi import FastAPI

app = FastAPI()

@app.get("/ping", status_code=200)
def get_ping():
    return 