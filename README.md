# Task Sharing App

A Flutter application for creating and sharing tasks with real-time updates.

## Features

- Create, edit, and delete tasks
- Share tasks with other users via email
- Share tasks through external apps
- Real-time updates when tasks are modified
- User authentication
- Responsive design for different screen sizes

## Project Structure

This project follows MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures representing the application state
- **Views**: UI components for user interaction
- **ViewModels**: Business logic and state management
- **Services**: Handle data operations and external APIs

## Dependencies

- provider: State management
- firebase_core, firebase_auth, cloud_firestore: Firebase integration
- uuid: Generate unique IDs
- share_plus: Share content with other apps
- flutter_slidable: Swipeable list items
- intl: Date formatting