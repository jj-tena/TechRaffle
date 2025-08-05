# TechRaffle
<div align="center">
  <img src="https://github.com/jj-tena/TechRaffle/blob/main/images/logo.png" alt="Logo" width="400"/>
</div>

## Concept
TechRaffle is a web application developed in Elixir and Phoenix to manage raffles for tech products such as smartphones, video game consoles, computers, and peripherals. The goal of these raffles is to raise funds for NGOs, which can also be managed from the website.

## Features
- User Registration and Authentication
  - Registration of new users with email and username validation.
  - Login and logout functionality.
- Raffle Management
  - View active raffles.
  - Participate in raffles by purchasing tickets and commenting.
  - Admin panel for creating, editing, and deleting raffles.
  - Admin panel for choosing random winner of the raffles.
- NGO Management
  - View and manage associated NGOs.
  - Admin panel to create and edit NGOs.
- User Dashboard
  - View and edit user profile.
  - View ticket history and past raffle participation.
- Admin Dashboard
  - Access restricted to admins.
  - Manage users, raffles, and NGOs.

## Technical Documentation

### Technologies and Languages Used
- Elixir: A concurrent functional language used for business logic and backend.
- Phoenix Framework: A web framework for Elixir, used to build the web application, APIs, and LiveView components.
- Ecto: An Elixir library for object-relational mapping (ORM) and database migrations.
- PostgreSQL: A relational database management system.
- Tailwind CSS: A utility-first CSS framework used for frontend styling.
- JavaScript: Used for interactive frontend functionality.
- Docker: Used for deployment and local development, simplifying dependency and service management.

### Project Structure
- techraffle/lib/techraffle_web/: Main web code, layouts, components, LiveViews, controllers.
- techraffle/lib/techraffle/accounts/user.ex: User model and logic.
- techraffle/assets/: Static files (JS, CSS, images).
- techraffle/config/: Environment configurations.
- techraffle/test/: Automated tests.
- docker-compose.yml: Service configuration for development and deployment.

### Main Modules and Components
- Techraffle.Accounts.User: Ecto model for users, including validations, registration, authentication, and roles.
- Layouts and Components: root.html.heex (main layout), app.html.heex (secondary layout).
- LiveViews and Controllers: Handle raffles, NGOs, users, and administration.

### Security
- User authentication using Bcrypt.
- Email validation and confirmation.
- User roles (admin, regular user).

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

## Screens
Home when user is not authenticated

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/home-not-authenticated.png" alt="Home when user is not authenticated" width="700"/>

Home when user is authenticated
  
<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/home-user-authenticated.png" alt="Home when user is authenticated" width="700"/>

Home when admin is authenticated
  
<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/home-admin-authenticated.png" alt="Home when admin is authenticated" width="700"/>

Raffle when user is not authenticated

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/raffle-not-authenticated.png" alt="Raffle when user is not authenticated" width="700"/>

Raffle when user is authenticated
  
<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/raffle-user-authenticated.png" alt="Raffle when user is authenticated" width="700"/>

Login

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/login.png" alt="Login" width="700"/>

Register

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/register.png" alt="Register" width="700"/>

User settings

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/user-settings.png" alt="User settings" width="700"/>

Admin raffles

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/admin-raffles.png" alt="Admin raffles" width="700"/>

New raffle

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/new-raffle.png" alt="New raffle" width="700"/>

Edit raffle

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/edit-raffle.png" alt="Edit raffle" width="700"/>

Admin ONGs

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/admin-ongs.png" alt="Admin ONGs" width="700"/>

New ONG

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/new-ong.png" alt="New ONG" width="700"/>

Edit ONG

<img src="https://github.com/jj-tena/TechRaffle/blob/main/images/edit-ong.png" alt="Edit ONG" width="700"/>





