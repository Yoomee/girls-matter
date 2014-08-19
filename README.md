The Girls matter holding page is hosted on the [girlguiding](https://gitlab.yoomee.com/girlguiding/girlguiding) cluster
so all environment details there are applicable here.



### Deployment
Environment variables in production are set using [dotenv](https://github.com/bkeepers/dotenv).
Each App server requires a .env file to be present in `/var/www/girlguiding/shared`, Capistrano symlinks this in to the current deployment directory and then 
the dotenv-deployment gem loads them in to `ENV`.

Deploy without migrations:

```
cap production deploy
```