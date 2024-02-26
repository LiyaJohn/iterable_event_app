# IterableEventApp

IterableEventApp is a Ruby on Rails application that integrates with Iterable. It provides functionality to create events, send email notifications, and manage user interactions via the Iterable API.

## Prerequisites

Before getting started, ensure you have the following installed:

- Ruby (version 3.0.0)
- Postgresql

## Getting Started

Follow these steps to set up and run the IterableEventApp:

1. Clone the repository:

   ```bash
   git clone git@github.com:LiyaJohn/iterable_event_app.git
   cd IterableEventApp
   ```
2. Install dependencies:
  
    ```bash
    bundle
    ```
3. Set up the database:

    ```bash
    rails db:create
    rails db:migrate
    ```
4. Start the server:

    ```bash
    rails s
    ```

5. Visit http://localhost:3000 in your browser.

## Configuration

Configure the Iterable API key and base uri in env file

  ```bash
  ITERABLE_API_KEY = 'mock-api-key'
  ITERABLE_BASE_URI = 'https://api.iterable.com'
  ```

## Running Tests

To run the entire test suite, use the following command:

  ```bash
  bundle exec rspec
  ```