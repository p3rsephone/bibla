Overview
--------
Jeykyll-powered reading list. Inspired by http://bibla.ru/

Usage
-----
If you have an account on bibla.ru, create folder 'books' and run parse_bibla.rb there. It will create a books.yaml file and images folder with book cover images.
```
./parse_bibla.rb -u dyachkoff
```
Otherwise just create a 'books' folder, add a books.yaml file and put book cover images in books/images. Then symlink the folder in this project and run jekyll
```
ln -s path/to/books ./
gem install jekyll
jekyll serve
```

books.yaml format
-----------------
It's pretty simple:
```
- title: More Money Than God
  author: Sebastian Mallaby
  status: want
  link: http://www.amazon.com/More-Money-Than-Sebastian-Mallaby-ebook/dp/B003ZSHUD4
  image: 51tq9UtLmJL.jpg
- title: ! 'Guns, Germs, and Steel: The Fates of Human Societies'
  author: Jared M. Diamond
  status: read
  image: 62345.jpg
  started: '2013-09-01'
  read: '2014-01-01'
```

