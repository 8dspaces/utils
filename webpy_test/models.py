from datetime import datetime
from sqlalchemy import create_engine, Table, ForeignKey 
from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import sessionmaker


engine = create_engine('sqlite:///db.sqlite', echo=False)

# Create a configured Session class
Session = sessionmaker(bind = engine)
session = Session() 

Base = declarative_base()
metadata = Base.metadata



class Post(Base):
    __tablename__ = 'post'
    
    id = Column(Integer, primary_key = True)
    title = Column(String(50))
    content = Column(Text)
    created_time = Column(DateTime, default=datetime.now())
    
    def __init__(self, title, content):
        
        self.title = title
        self.content = content 
        self.created_time = datetime.now()
        
    def __repr__(self):
        return "post('%s','%s')" % \
        (self.title, self.created_time)   
        
if __name__ == "__main__":
    metadata.create_all(engine)
    
    # if no data, create one for testing 
    if not session.query(Post).all():
        test = Post("abc","test text")
        session.add(test)
        session.commit()
    
    posts =  session.query(Post).all()
    for post in posts:
        print post.title
