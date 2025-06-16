// Note:
  // 1. *paragraph:* What is the motivation of your thesis? Why is it interesting from a scientific point of view? Which main problem do you like to solve?
  // 2. *paragraph:* What is the purpose of the document? What is the main content, the main contribution?
  // 3. *paragraph:* What is your methodology? How do you proceed?
  
The original Apollon and Apollon Standalone projects became increasingly difficult to maintain and extend due to outdated technologies like React class components, Redux, and Redux-Saga. Managing three separate repositories for the library, standalone (webapp-server), and iOS app further complicated development. This motivated the need for a unified, modern architecture to improve both development efficiency and user experience.

This thesis presents a complete system reengineering. All repositories were merged into a single monorepo, with key improvements including the adoption of React Flow for diagram editing, Zustand for lightweight state management, and Yjs for real-time collaboration. The shared diagram library is now published as a standalone npm package and reused across multiple applications. Mobile support is achieved by wrapping the web app with Capacitor.

The migration followed an incremental approach, gradually replacing legacy components while ensuring system stability. The new architecture is modular, maintainable, and cross-platform, providing a scalable foundation for future development.