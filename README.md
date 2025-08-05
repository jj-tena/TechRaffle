# TechRaffle
![Logo](https://github.com/jj-tena/TechRaffle/blob/main/images/logo.png)

## Concepts
TechRaffle is a web application developed in Elixir and Phoenix to manage raffles for tech products such as smartphones, video game consoles, computers, and peripherals. The goal of these raffles is to raise funds for NGOs, which can also be managed from the website.

## Installation Guide (Linux):

### Prerequisites
Make sure you have the following installed:
- Docker & Docker Compose
- Elixir
- Mix (comes with Elixir)
- Erlang (required by Elixir)

### Installation Steps
- Update your package list: sudo apt-get update
- Install file watching tools (required for live reload in some setups): sudo apt-get install inotify-tools
- Start Docker containers in the background:docker compose up -d
- Navigate to the project directory: cd techraffle
- Create the database: mix ecto.create
- Start the Phoenix server: mix phx.server
- The application should now be running at: http://localhost:4000
- To stop and remove the Docker containers: docker compose down
