import web 
from web.contrib.template import render_jinja
from sqlalchemy.orm import scoped_session, sessionmaker
from models import *

urls = (
        '/todo/del/(\d+)', 'Delete',
        '/todo/done/(\d+)', 'Done',
        '/todo/retrieve/(\d+)', 'Retrieve',
        '/todo/new','New',
        '/', 'Index',
)

app = web.application(urls, globals())
def load_sqla(handler):
    web.ctx.orm = scoped_session(sessionmaker(bind=engine))
    try:
        return handler()
    except web.HTTPError:
       web.ctx.orm.commit()
       raise
    except:
        web.ctx.orm.rollback()
        raise
    finally:
        web.ctx.orm.commit()

render = render_jinja('templates', encoding='utf-8')
app.add_processor(load_sqla)

class Index:
    
    def GET(self):
        todos = web.ctx.orm.query(Todo).all()
        return render.index(todos = todos, title = 'todo')

class New:
    
    def POST(self):
        data = web.input()
        td = Todo(data.content)
        todos = web.ctx.orm.add(td)
        raise web.seeother('/')

class Delete:
    
    def GET(self, id):
        td = web.ctx.orm.query(Todo).get(id)
        web.ctx.orm.delete(td)
        raise web.seeother('/')
        
class Done:
    
    def GET(self, id):
        td = web.ctx.orm.query(Todo).get(id)
        td.is_done = True
        web.ctx.orm.merge(td)
        raise web.seeother('/')
        
class Retrieve:
    
    def GET(self, id):
        td = web.ctx.orm.query(Todo).get(id)
        td.is_done = False
        web.ctx.orm.merge(td)
        raise web.seeother('/')
        
if __name__ == "__main__":
    app.run()
