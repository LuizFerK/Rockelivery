<br />

<p align="center">
  <img alt="Logo" src="./.github/logo.png" width="200px" />
</p>

<h1 align="center" style="text-align: center;">Rockelivery</h1>

<p align="center">
	<a href="https://github.com/LuizFerK">
		<img alt="Author" src="https://img.shields.io/badge/author-Luiz%20Fernando-FEBE53?style=flat" />
	</a>
	<a href="#">
		<img alt="Languages" src="https://img.shields.io/github/languages/count/LuizFerK/Rockelivery?color=FEBE53&style=flat" />
	</a>
	<a href="hhttps://github.com/LuizFerK/Rockelivery/stargazers">
		<img alt="Stars" src="https://img.shields.io/github/stars/LuizFerK/Rockelivery?color=FEBE53&style=flat" />
	</a>
	<a href="https://github.com/LuizFerK/Rockelivery/network/members">
		<img alt="Forks" src="https://img.shields.io/github/forks/LuizFerK/Rockelivery?color=FEBE53&style=flat" />
	</a>
	<a href="https://github.com/LuizFerK/Rockelivery/graphs/contributors">
		<img alt="Contributors" src="https://img.shields.io/github/contributors/LuizFerK/Rockelivery?color=FEBE53&style=flat" />
	</a>
  <a href="https://codecov.io/gh/LuizFerK/Rockelivery">
  <img src="https://codecov.io/gh/LuizFerK/Rockelivery/branch/main/graph/badge.svg?token=8XFXDOIH5R"/>
</a>
</p>

<p align="center">
	<b>Order your favorite dish in no time!</b><br />
	<span>Created with Elixir and Phoenix.</span><br />
	<sub>Made with ❤️</sub>
</p>

<br />

# :pushpin: Contents

- [Features](#rocket-features)
- [Installation](#wrench-installation)
- [Getting started](#bulb-getting-started)
- [Endpoints](#triangular_flag_on_post-endpoints)
- [Techs](#fire-techs)
- [Issues](#bug-issues)
- [License](#book-license)

# :rocket: Features

- Create, delete and updates users
- Sign-in with JWT authentication
- Create, delete and updates items
- Create orders from your favorite dishes
- Delete and update orders
- Generate an Orders Report for every hour to keep in track with your application

# :wrench: Installation

### Required :warning:
- Elixir
- Erlang
- Phoenix
- Postgres database

### SSH

SSH URLs provide access to a Git repository via SSH, a secure protocol. If you have an SSH key registered in your GitHub account, clone the project using this command:

```git clone git@github.com:LuizFerK/Rockelivery.git```

### HTTPS

In case you don't have an SSH key on your GitHub account, you can clone the project using the HTTPS URL, run this command:

```git clone https://github.com/LuizFerK/Rockelivery.git```

**Both of these commands will generate a folder called Rockelivery, with all the project**

# :bulb: Getting started

1. Run ```mix deps.get``` to install the dependencies
2. Create a postgres database named ```rockelivery```
3. On the ```config/dev.exs``` and ```config/test.exs``` files, change your postgres **user** and **password**
4. Run ```mix ecto.migrate``` to run the migrations to your database
5. Run ```mix phx.server``` to start the server on port 4000

# :triangular_flag_on_post: Endpoints

> All the endpoints except for the user's creation and sign-in are protected with JWT authentication. You'll need to pass a valid token from an existent user in every route as a Bearer Token authentication. You can get the token by signing in to the app on the users sign in route

> If you use Insomnia as your HTTP API requester, you can use the [Insomnia Rockelivery Collection](https://github.com/LuizFerK/Rockelivery/blob/main/.github/insomnia.json) to set up your requests as fast as possible!

### Users

* :green_circle: Create - POST `http://localhost:4000/api/users`

	* Request
	
		```json
		{
		  "address": "Random street, 10",
		  "age": 18,
		  "cep": "01001000",
		  "cpf": "12345678900",
		  "email": "johndoe@example.com",
		  "name": "John Doe",
		  "password": "123456"
		}
		```
	* Response - 201 Created
	
		```json
		{
		  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpX...",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  }
		}
		```
* :red_circle: Delete - DELETE `http://localhost:4000/api/users/<user_id>` Response - 204 No Content

* :purple_circle: Get - GET `http://localhost:4000/api/users/<user_id>`

	* Response - 200 Ok
	
		```json
		{
		  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpX...",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  }
		}
		```

* :yellow_circle: Update - PUT `http://localhost:4000/api/users/<user_id>`

	* Request:
	
		```json
		{
		  "address": "Random street, 10",
		  "age": 18,
		  "cep": "01001000",
		  "cpf": "12345678901",
		  "email": "johndoe2@example.com",
		  "name": "John Doe",
		  "password": "123456"
		}
		```
	* Response - 200 Ok
	
		```json
		{
		  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpX...",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678901",
		    "email": "johndoe2@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  }
		}
		```

* :white_circle: Sign In - POST `http://localhost:4000/api/users/signin`

	* Request:
	
		```json
		{
		  "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "password": "123456"
		}
		```
	* Response - 200 Ok
	
		```json
		{
		  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpX..."
		}
		```

* :black_circle: List - GET `http://localhost:4000/api/users/list`

	* Response - 200 Ok
	
		```json
		[
		  {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "dab3d875-13ad-4477-982a-1fcbdb57ef58"
		  },
		  {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678901",
		    "email": "johndoe2@example.com",
		    "name": "John Doe",
		    "id": "dab3d875-13ad-4477-982a-1fcbdb57ef58"
		  }
		]
		```

### Items

* :green_circle: Create - POST `http://localhost:4000/api/items`

	* Request
	
		```json5
		{
		  "category": "food", // "food", "drink" or "desert"
		  "description": "Chocolate Pizza",
		  "price": "50.20",
		  "photo": "/priv/chocolate_pizza.jpg"
		}
		```
	* Response - 201 Created
	
		```json
		{
		  "category": "food",
		  "description": "Chocolate Pizza",
		  "price": "50.20",
		  "photo": "/priv/chocolate_pizza.jpg",
		  "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		}
		```
* :red_circle: Delete - DELETE `http://localhost:4000/api/items/<item_id>` Response - 204 No Content

* :purple_circle: Get - GET `http://localhost:4000/api/items/<item_id>`

	* Response - 200 Ok
	
		```json
		{
		  "category": "food",
		  "description": "Chocolate Pizza",
		  "price": "50.20",
		  "photo": "/priv/chocolate_pizza.jpg",
		  "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		}
		```

* :yellow_circle: Update - PUT `http://localhost:4000/api/items/<item_id>`

	* Request
	
		```json
		{
		  "category": "drink",
		  "description": "Chocolate Milk",
		  "price": "8.90",
		  "photo": "/priv/chocolate_milk.jpg"
		}
		```
	* Response - 200 Ok
	
		```json
		{
		  "category": "drink",
		  "description": "Chocolate Milk",
		  "price": "8.90",
		  "photo": "/priv/chocolate_milk.jpg",
		  "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		}
		```

* :black_circle: List - GET `http://localhost:4000/api/items/list`

	* Response - 200 Ok
	
		```json
		[
		  {
		    "category": "food",
		    "description": "Chocolate Pizza",
		    "price": "52.20",
		    "photo": "/priv/chocolate_pizza.jpg",
		    "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		  },
		  {
		    "category": "drink",
		    "description": "Chocolate Milk",
		    "price": "8.90",
		    "photo": "/priv/chocolate_milk.jpg",
		    "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		  }
		]
		```

### Orders

* :green_circle: Create - POST `http://localhost:4000/api/orders`

	* Request
	
		```json5
		{
		  "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "items": [
		    {
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3",
		      "quantity": 2
		    },
		    {
		      "id": "f1029e90-e582-4820-ad3e-aba04add5427",
		       "quantity": 1
		    }
		  ],
	  	  "address": "Random Street, 10",
		  "comments": "Extra cheese",
		  "payment_method": "credit_card" // "credit_card", "debit_card" or "money"
		}
		```
	* Response - 201 Created
	
		```json
		{
		  "address": "Random Street, 10",
		  "comments": "Extra cheese",
		  "payment_method": "credit_card",
		  "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "id": "0b2e9884-c88b-4593-b374-ee6ae6ead48d",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  },
		  "items": [
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "drink",
		      "description": "Chocolate Milk",
		      "price": "8.90",
		      "photo": "/priv/chocolate_milk.jpg",
		      "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		    }
		  ]
		}
		```
* :red_circle: Delete - DELETE `http://localhost:4000/api/orders/<order_id>` Response - 204 No Content

* :purple_circle: Get - GET `http://localhost:4000/api/orders/<order_id>`

	* Response - 200 Ok
	
		```json
		{
		  "address": "Random Street, 10",
		  "comments": "Extra cheese",
		  "payment_method": "credit_card",
		  "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "id": "0b2e9884-c88b-4593-b374-ee6ae6ead48d",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  },
		  "items": [
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "drink",
		      "description": "Chocolate Milk",
		      "price": "8.90",
		      "photo": "/priv/chocolate_milk.jpg",
		      "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		    }
		  ]
		}
		```

* :yellow_circle: Update - PUT `http://localhost:4000/api/orders/<order_id>`

	* Request
	
		```json
		{
		  "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "items": [
		    {
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3",
		      "quantity": 2
		    },
		    {
		      "id": "f1029e90-e582-4820-ad3e-aba04add5427",
		       "quantity": 1
		    }
		  ],
	  	  "address": "Random Street, 10",
		  "comments": "Extra chocolate",
		  "payment_method": "money"
		}
		```
	* Response - 201 Created
	
		```json
		{
		  "address": "Random Street, 10",
		  "comments": "Extra chocolate",
		  "payment_method": "money",
		  "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		  "id": "0b2e9884-c88b-4593-b374-ee6ae6ead48d",
		  "user": {
		    "age": 18,
		    "address": "Random street, 10",
		    "cep": "01001000",
		    "cpf": "12345678900",
		    "email": "johndoe@example.com",
		    "name": "John Doe",
		    "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		  },
		  "items": [
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "food",
		      "description": "Chocolate Pizza",
		      "price": "52.20",
		      "photo": "/priv/chocolate_pizza.jpg",
		      "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		    },
		    {
		      "category": "drink",
		      "description": "Chocolate Milk",
		      "price": "8.90",
		      "photo": "/priv/chocolate_milk.jpg",
		      "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		    }
		  ]
		}
		```

* :black_circle: List - GET `http://localhost:4000/api/items/list`

	* Response - 200 Ok
	
		```json
		[
		  {
		    "address": "Random Street, 10",
		    "comments": "Extra cheese",
		    "payment_method": "credit_card",
		    "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		    "id": "0b2e9884-c88b-4593-b374-ee6ae6ead48d",
		    "user": {
		      "age": 18,
		      "address": "Random street, 10",
		      "cep": "01001000",
		      "cpf": "12345678900",
		      "email": "johndoe@example.com",
		      "name": "John Doe",
		      "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		    },
		    "items": [
		      {
		        "category": "food",
		        "description": "Chocolate Pizza",
		        "price": "52.20",
		        "photo": "/priv/chocolate_pizza.jpg",
		        "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		      },
		      {
		        "category": "food",
		        "description": "Chocolate Pizza",
		        "price": "52.20",
		        "photo": "/priv/chocolate_pizza.jpg",
		        "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		      },
		      {
		        "category": "drink",
		        "description": "Chocolate Milk",
		        "price": "8.90",
		        "photo": "/priv/chocolate_milk.jpg",
		        "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		      }
		    ]
		  },
		  {
		    "address": "Random Street, 10",
		    "comments": "Extra chocolate",
		    "payment_method": "money",
		    "user_id": "85703d30-c42f-43fb-b2df-3a7ffd70803e",
		    "id": "0b2e9884-c88b-4593-b374-ee6ae6ead48d",
		    "user": {
		      "age": 18,
		      "address": "Random street, 10",
		      "cep": "01001000",
		      "cpf": "12345678900",
		      "email": "johndoe@example.com",
		      "name": "John Doe",
		      "id": "85703d30-c42f-43fb-b2df-3a7ffd70803e"
		    },
		    "items": [
		      {
		        "category": "food",
		        "description": "Chocolate Pizza",
		        "price": "52.20",
		        "photo": "/priv/chocolate_pizza.jpg",
		        "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		      },
		      {
		        "category": "food",
		        "description": "Chocolate Pizza",
		        "price": "52.20",
		        "photo": "/priv/chocolate_pizza.jpg",
		        "id": "45a62ca7-0487-4f10-a481-52c48e0757f3"
		      },
		      {
		        "category": "drink",
		        "description": "Chocolate Milk",
		        "price": "8.90",
		        "photo": "/priv/chocolate_milk.jpg",
		        "id": "f1029e90-e582-4820-ad3e-aba04add5427"
		      }
		    ]
		  }
		]
		```

# :fire: Techs

### Elixir (language)

### Phoenix (web framework)
- Ecto
- Elixir GenServer (orders report)
- Guardian (authentication)
- PBKDF2 (password cryptography)
- Tesla (http client to external apis)

# :bug: Issues

Find a bug or error on the project? Please, feel free to send me the issue on the [Rockelivery issues area](https://github.com/LuizFerK/Rockelivery/issues), with a title and a description of your found!

If you know the origin of the error and know how to resolve it, please, send me a pull request, I will love to review it!

# :book: License

Released in 2020.

This project is under the [MIT license](https://github.com/LuizFerK/Rockelivery/blob/main/LICENSE).

<p align="center">
	< keep coding /> :rocket: :heart:
</p>
