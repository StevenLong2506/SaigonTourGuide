from app.api.endpoints import users, categories, auth, interest_tags, places, reviews
from app import app
from app.api.endpoints.admin import admin_places, admin_categories, admin_tags, admin_reviews, admin_stats, admin_users


app.include_router(router=admin_places.router, prefix='/places', tags=['Admin-Places'])
app.include_router(router=places.router, prefix='/places', tags=['Places'])
app.include_router(router=admin_categories.router, prefix='/categories', tags=['Admin-Categories'])
app.include_router(router=admin_tags.router, prefix='/tags', tags=['Admin-Tags'])
app.include_router(router=admin_reviews.router, prefix='/admin/reviews', tags=['Admin-Reviews'])
app.include_router(router=admin_stats.router, prefix='/admin/stats', tags=['Admin-Stats'])
app.include_router(router=admin_users.router, prefix='/admin/users', tags=['Admin-Users'])
app.include_router(router=reviews.router, prefix='/reviews', tags=['Review'])
app.include_router(router=users.router, prefix='/users', tags=['Users'])
app.include_router(router=categories.router, prefix='/categories', tags=['Categories'])
app.include_router(router=auth.router, prefix='/auth', tags=['Auth'])
app.include_router(router=interest_tags.router, prefix='/tags', tags=['Tags'])

@app.get('/health', tags=['System'])
def health():
    return {'status': 'ok'}


@app.get('/')
def root():
    return {'message': 'Hello world'}
