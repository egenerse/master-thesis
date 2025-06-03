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
  image("../figures/ApollonOverviewDetailed.png", width: 90%),
  caption: [System overview of the new Apollon architecture.]
)

== Node Structure

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]


The internal data model for UML elements in Apollon has been redesigned to make it simpler, faster, and easier to maintain. This change affects how classes, methods, and attributes are stored and rendered in the application.

=== Previous Structure

In the older version of Apollon, every concept—like a class, an attribute, or a method—was treated as a separate UML element. These elements had a shared structure with a `type` field such as `"Class"`, `"ClassAttribute"`, or `"ClassMethod"`.

A class element stored its method and attribute IDs:
```json
{
  "id": "0e87...",
  "type": "Class",
  "attributes": ["e0c4..."],
  "methods": ["1804..."]
}```
Each method and attribute also existed as a separate object with a reference to its parent:
```json
{
  "id": "e0c4...",
  "type": "ClassAttribute",
  "owner": "0e87..."
}
```
This model gave developers flexibility but introduced complexity. Managing updates across multiple related nodes was difficult and error-prone.

#figure(
  image("../figures/OldNodeType.png", width: 90%),
  caption: [Node types in Old Apollon]
)
=== New Structure

In the redesigned version, Apollon uses a flat node structure inspired by React Flow. Each class node stores its attributes and methods inside its own data field. Stereotypes are also introduced in another field:

#figure(
  image("../figures/NewNodeType.png", width: 90%),
  caption: [New Node structure in Apollon Reengineering]
)

== Edge Structure

#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]


In the previous version of Apollon, edge rendering was stable and functional, but it had limitations in terms of visual clarity. The main issue was the presence of diagonal edges between elements, which made UML diagrams harder to read and deviated from typical modeling standards. Additionally, the older system supported only four connection ports (top, bottom, left, right) on each node, which restricted flexibility in edge routing.

In the reengineered Apollon, we adopted a hybrid edge rendering approach that combines techniques from both the old system and modern features of *React Flow*. Specifically:

- We use *Step Edges* from React Flow to generate clean, orthogonal paths between distant nodes.
- When nodes are positioned closer than a defined threshold, we fall back to rendering a *Straight Edge* using logic adapted from the old Apollon implementation.

This hybrid method avoids the creation of awkward diagonal lines and improves the visual clarity of the diagrams.
#figure(
  image("../figures/DiagonalEdge.png", width: 90%),
  caption: [Diagonal Edge between two class nodes in Old Apollon version]
)
We also increased the number of ports per node to allow finer control over where edges connect. This gives users more layout flexibility and helps avoid overlapping edges in dense diagrams.

#figure(
  image("../figures/OldEdgePort.png", width: 90%),
  caption: [Edge handlers in Old Apollon version]
)

#figure(
  image("../figures/NewEdgePort.png", width: 90%),
  caption: [Edge handlers in New Apollon version which is increased]
)


== New State Management

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

== New Collabopration Mode

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

== Usability Improvements

#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]

*Mention canvas, shortcuts, new sidebar, and maybe lines for checking the allignment however it is a future work.*