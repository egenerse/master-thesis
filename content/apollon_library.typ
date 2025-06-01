#import "/utils/todo.typ": TODO

= Apollon Reengineering

In this section, we explain the reengineering of the Apollon library. We begin by describing the new system design and the monorepo structure, which brings together the standalone version, library, and web application. Then, we detail the new node and edge structure that improves rendering and usability. Afterwards, we explain the newly introduced state management with Zustand and the updated collaboration mode powered by Yjs.

== System Design

#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]

We restructured the Apollon project into a monorepo that includes three main subsystems: the Apollon library, the web application (standalone), and a lightweight backend server for collaboration. This architecture improves modularity and makes development, testing, and deployment easier.

- *Apollon Library*:
  This is the core module that encapsulates all modeling-related functionalities. It handles rendering and layout using React Flow, defines UML data structures, manages interaction logic such as selection and editing, and provides utilities like export and import.
  The library uses *Zustand* for centralized and scalable state management and integrates *Yjs*, a CRDT-based framework, for real-time collaboration. Yjs works through a shared *Y.Doc* object that synchronizes state across multiple clients. We will describe this mechanism in more detail in Section 5.5.
  To connect the application state with the Yjs document, the library also includes a Yjs sync component that links the store and collaborative state updates.
  The Apollon Library exposes its full functionality through the `ApollonEditor` interface. This allows external applications, like the webapp or Artemis, to easily embed and interact with the editor instance without needing to access internal logic directly.

- *Apollon Webapp (Standalone)*:
  This is the user-facing subsystem that builds upon the Apollon library. It provides the interface where students and instructors can create, edit, and manage UML diagrams.
  The webapp uses the `ApollonEditor` interface to embed and control the editor. It also includes a *Model Provider* component responsible for fetching models from and saving them to the backend server.
  For collaboration, the webapp connects to the backend using a *Message Provider*, which handles WebSocket connections and dispatches events. This keeps the editor state synchronized between clients during collaborative sessions.

- *Apollon Server*:
  This is a minimal backend service built to support WebSocket-based collaboration. It acts as a *relay server*, meaning it does not interpret the data but simply forwards the binary CRDT messages between clients.
  It includes a *Message Broadcast* module to handle message forwarding between connected clients on the same document.
  In addition to real-time collaboration, the server also supports model persistence. The *Diagram Router* exposes REST endpoints (PUT, POST, GET) to read and write diagram models from a *persistent database*. This enables users to save and resume their work seamlessly across sessions.


#figure(
  image("../figures/ApollonOverview.png", width: 90%),
  caption: [System overview of the new Apollon architecture.]
)

== New Node Structure

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

== New Edge Structure

#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]



== New State Management

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

== New Collabopration Mode

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]
