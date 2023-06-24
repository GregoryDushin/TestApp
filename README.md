# TestApp - Custom interface implementation

### Функционал: ###

 Верхние промо акции и кнопки скроллятся вбок, кнопки имеют привязку к ячейкам таблицы: нажатие на соответствующую кнопку приводит к скроллингк к соответствующей ячейке, так же при скроллинге выбираются соответствующие кнопки. Данные в таблице с публичного API, изображения промо - по url из свободных источников. Данные сохраняются в Realm, при отсутствии сети отображаются последние записанные значения из базы данных.

### Реализована с помощью следующих технологий: ###

 * **Шаблон проектирования** - _выбран **MVP**_.
 * **Верхние элементы с промо и кнопками категорий** - _с помощью **UICollectionViewDiffableDataSource** в собственном вью._
 * **Таблица продуктов** - _классическая реализация **TableView**._
 * **Сохранение данных** - _реализовано с использованием **Realm**._
 * **Загрузка картинок** - _с помощью **AlamofireImage**._
 * **Загрузка данных** - _обычная реализацию с протоколом **Codable**._
 * **API** - _не было предложено, использовано публичное **API SpaceX**._
 
## Preview
<img src= "https://github.com/GregoryDushin/TestApp/blob/main/testAppScreen1.png" width="400">

## Interactive visuality
![Simulator Screen Recording](https://github.com/GregoryDushin/TestApp/blob/1726e4b8743b456fc63e594d82031cd2345fdb9f/Simulator%20Screen.gif)


## Технологии

* UIKit
* MVP design pattern
* Alamofire
* Realm
* Multithreading with GCD
* Networking with URLSession
* UITableView and UICollectionView
* UICompositionalLayout
* NSDiffableDataSource

## Installation
1. Fork and clone this project to your machine
2. Open the `.xcodeproj` file in Xcode
3. Change the Build identifier
4. Build and run
