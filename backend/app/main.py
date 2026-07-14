from api.endpoints import users, categories
from app import app


app.include_router(router=users.router, prefix='/users',tags=['Users'])
app.include_router(router=categories.router, prefix='/categories',tags=['Categories'])

@app.get('/')
def root():
    return {'message': 'Hello world'}