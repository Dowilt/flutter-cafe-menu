import os
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.orm import declarative_base, sessionmaker, Session

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://cafe_user:cafe_pass@db:5432/cafe_db",
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
Base = declarative_base()


class CartItem(Base):
    __tablename__ = "cart_items"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String, nullable=False)
    price = Column(Float, nullable=False)
    quantity = Column(Integer, nullable=False)
    emoji = Column(String, nullable=False)


Base.metadata.create_all(bind=engine)

app = FastAPI(title="Cafe Cart API")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class CartItemCreate(BaseModel):
    name: str
    price: float
    quantity: int
    emoji: str


class CartItemResponse(BaseModel):
    id: int
    name: str
    price: float
    quantity: int
    emoji: str

    class Config:
        from_attributes = True


@app.get("/api/cart", response_model=list[CartItemResponse])
def get_cart(db: Session = Depends(get_db)):
    return db.query(CartItem).all()


@app.post("/api/cart", response_model=CartItemResponse)
def add_to_cart(item: CartItemCreate, db: Session = Depends(get_db)):
    db_item = CartItem(**item.model_dump())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item


@app.delete("/api/cart")
def clear_cart(db: Session = Depends(get_db)):
    db.query(CartItem).delete()
    db.commit()
    return {"message": "Корзина очищена"}


@app.delete("/api/cart/{item_id}")
def remove_from_cart(item_id: int, db: Session = Depends(get_db)):
    item = db.query(CartItem).filter(CartItem.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Элемент не найден")
    db.delete(item)
    db.commit()
    return {"message": "Элемент удалён"}


@app.get("/api/health")
def health_check():
    return {"status": "ok"}
