from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware  # Import CORSMiddleware
from pydantic import BaseModel
from googletrans import Translator

app = FastAPI()

# Add CORSMiddleware to allow cross-origin requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins; change this if you need a specific origin
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

translator = Translator()

class TranslationRequest(BaseModel):
    text: str

@app.get("/")
def read_root():
    return {"message": "Welcome to the Eng2Indo Translation API"}

@app.post("/translate/ind-eng/")
def translate_ind_to_eng(request: TranslationRequest):
    translation = translator.translate(request.text, src='id', dest='en')
    return {"original": request.text, "translated": translation.text, "explanation": "This is an automatic translation from Indonesian to English."}

@app.post("/translate/eng-ind/")
def translate_eng_to_ind(request: TranslationRequest):
    translation = translator.translate(request.text, src='en', dest='id')
    return {"original": request.text, "translated": translation.text, "explanation": "This is an automatic translation from English to Indonesian."}

#Kode ini membuat API penerjemahan menggunakan FastAPI dan Google Translate. API ini memiliki dua endpoint:
#/translate/ind-eng/: Menerjemahkan teks dari bahasa Indonesia ke bahasa Inggris.
#/translate/eng-ind/: Menerjemahkan teks dari bahasa Inggris ke bahasa Indonesia...