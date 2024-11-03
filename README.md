Notes App Project

A simple project designed to enhance my understanding of The Composable Architecture (TCA) and Backend Development using Spring Boot. This project comprises both a mobile app and a backend API.

Currently made using The Composable Architecture (TCA). The app currently supports:

- Login and registration
- CRUD operations on notes

Known Issues

- API token isn't cleared when restarting the app, which means if a different user logs in, they'll see another user's notes.

Planned Improvements

- Add error state UI handling
- Implement logout functionality
- Maintain user login status on app restart
- Add support for uploading voice and video

Backend

Developed using Spring Boot for its quick setup and robust features. Key implementations include:

- JWT authentication with Spring Security
- Persistence layer using Postgres for notes
- User login functionality for user management

Planned Improvements

- Add filtering for notes
- Add support for audio and video upload (consider AWS or another provider, or implement custom storage)
