# Screen-Shop

[Screen-Shop](https://screen-shop.herokuapp.com/) is an e-shop initially built to sell phones and accessories.

## Configuration:

* Ruby 2.5.1

* Rails 5.2.2

## Front-End 
The Front-End is a [Sublime Theme](https://colorlib.com/wp/template/sublime/) from [ColorLib](https://colorlib.com/)

Some arrangements and creation for the website were built.

## Back-End

#### Admin User
The admin user can add new brand, new model related to this brand, and new accessory related to this model.

He can update price, quantities, name, description and many more through the admin board.

Each product has a status (hot, sales, or default). When the sales status is enabled, the admin user need to add a percentage of reduction.

Status and stock can be multi-updated in same time.

Different deliveries options can be added through this board.

#### Customer User

All products are displayed on multiple pages, with [Pagy Gem](https://github.com/ddnexus/pagy).

The customer can search for the desired product with a search bar built with the [Ransack Gem](https://github.com/activerecord-hackery/ransack).

He can add multiple products, with the selected quantities. Once added to the cart, he can update the product (delete it or update quantities).

Each customer has a delivery and billing adress, that he can edit anytime. 

The customer can pay with credit cart through [Stripe](https://stripe.com/fr).
Once paid, the customer receive a mail through [Mailjet](https://fr.mailjet.com/), with the details of his order, which can be read from his account board.

## Installation

Feel free to test it [online](https://screen-shop.herokuapp.com/) or locally.
So you'll need to run :

* ```bundle install```
* ```rails db:create```
* ```rails db:create```
* ```rails db:seeds``` to populate database with [Faker](https://github.com/faker-ruby/faker) and other



