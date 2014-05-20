import web 
from web.contrib.template import render_jinja
#from models import session, Post
from sqlalchemy.orm import scoped_session, sessionmaker
from models import *

urls = (
    '/','index',
    '/search','search',
    '/pic','pic',
    '/form','form',
    '/post','post',
    '/post/(\d+)', 'post_detail',
)

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

app = web.application(urls, globals())
render = render_jinja('templates')
app.add_processor(load_sqla)



class index:
    def GET(self):
        #return "hello, webpy world"
        return render.index( title = 'Index', test = False)
        
class search:
    def GET(self):
        data = web.input() 
        return render.search( title = 'search', data = data.s)
        
class pic:
    def GET(self):
        return render.pic( title = 'pictures')

class form:
    def GET(self):
        return render.form( title = 'form')

class post:
    def GET(self):
        # posts = session.query(Post).all()
        posts = web.ctx.orm.query(Post).all()  
        return render.post( posts = posts, title = 'posts')
        
class post_detail:

    def GET(self,id):
        pd = web.ctx.orm.query(Post).get(id)
        return render.detail( post = pd, title = 'details')
    
        
if __name__ == "__main__":
    app.run()
