#import "/utils/todo.typ": TODO

= Apollon Reengineering

In this section, we explain the reengineering of the Apollon library. We begin by describing the new system design and the monorepo structure, which brings together the standalone version, library, and web application. Then, we detail the new node and edge structure that improves rendering and usability. Afterwards, we explain the newly introduced state management with Zustand and the updated collaboration mode powered by Yjs.

== Library
=== System Design

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

=== Node Structure

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]


The internal data model for UML elements in Apollon has been redesigned to make it simpler, faster, and easier to maintain. This change affects how classes, methods, and attributes are stored and rendered in the application.



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


In the redesigned version, Apollon uses a flat node structure inspired by React Flow. Each class node stores its attributes and methods inside its own data field. Stereotypes are also introduced in another field:

#figure(
  image("../figures/NewNodeType.png", width: 90%),
  caption: [New Node structure in Apollon Reengineering]
)

=== Edge Structure

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


=== New State Management

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

=== New Collaboration Mode

#align(left)[
  #text(size: 10pt)[Ege Nerse]
]

=== Usability Improvements

#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]

*Mention canvas, shortcuts, new sidebar, and maybe lines for checking the allignment however it is a future work.*

== Standalone

=== Usability Improvements

=== Apollon Standalone Deployment Setup
#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]

To ensure that the reengineered version of Apollon is available reliably in production environments, we deployed the system using a reverse proxy configuration centered around modular services. The application consists of three subsystems: the Apollon webapp, a backend server responsible for WebSocket-based collaboration and RESTful API endpoints, and a persistent database for storing models. These components are containerized and managed using Docker Compose.


At the core of the deployment infrastructure is *Caddy*, a modern web server and reverse proxy that simplifies configuration, particularly for projects that rely heavily on secure WebSocket connections. All incoming HTTP and HTTPS traffic is routed through Caddy#footnote[https://caddyserver.com], which acts as a single entry point into the system. When a request arrives, Caddy evaluates the path. If the path begins with `/ws` or `/api`, the request is proxied to the Apollon server, which handles WebSocket communication for real-time collaboration or API requests for loading and storing diagrams. All other requests, including the base path, are directed to the Apollon webapp, which serves the frontend application.

We selected Caddy over alternatives such as Nginx because of its simplified setup and built-in support for automatic HTTPS via Let’s Encrypt. This eliminated the need for manual TLS certificate configuration and allowed us to maintain a clean and concise reverse proxy setup with native WebSocket support. The flexibility of Caddy made it especially well-suited for our use case, which requires consistent handling of real-time data streams across devices, including mobile clients.


The entire system is hosted on a managed virtual machine. Docker Compose manages the containers and ensures that the services remain up through restart policies and built-in health checks. The firewall configuration on the server ensures that only the Caddy port (typically 443 for HTTPS traffic) is exposed to the outside world, while all internal services communicate over a private Docker network. Sensitive environment variables such as database credentials and API tokens are injected at runtime using `.env` files that are excluded from version control. This approach maintains both security and modularity, allowing for easier adaptation between staging and production environments.

=== Testing Session

== Mobile Application


In recent years, mobile devices have become essential tools for both formal education and self-directed learning. Students frequently use smartphones and tablets to complete tasks, review materials, and collaborate with peers, especially in remote or hybrid learning contexts. Studies have shown that mobile learning increases flexibility and accessibility, improving engagement and learning outcomes across diverse student groups [@denoyelles2023evolving].

Ensuring that educational tools like Apollon work seamlessly across all platforms — including desktops, tablets, and phones — enhances their usability and relevance. Platform consistency allows students to switch between devices without facing different interfaces, behaviors, or limitations. This consistency improves productivity and reduces the cognitive load associated with context switching, especially when learning complex modeling tasks [@mendel2009interface].

Furthermore, mobile support benefits instructors and developers by making the application available in a wider range of usage scenarios — from classroom demonstrations to on-the-go corrections and feedback. Enabling cross-platform access is not just a matter of convenience but a requirement for inclusive and future-proof educational software.

The earlier version of Apollon attempted to support mobile platforms by maintaining a separate iOS application in a different repository. However, this approach came with multiple limitations. The iOS app suffered from severe rendering issues — when users moved nodes on the canvas, text such as class names, attributes, or methods often shifted away from their designated positions. This was caused by inconsistencies in how coordinate translations were handled during drag interactions on iOS devices, especially in combination with scaling and zooming.

#figure(
  image("../figures/classDiagramBug.jpeg", width: 90%),
  caption: [Node Translation Bug in current iOS Apollon Application]
)

Maintaining a separate codebase also became a burden. Every update made to the web version had to be mirrored manually in the iOS repository, leading to duplicated efforts and a growing risk of divergence between the two platforms. Additionally, this approach completely excluded Android users, leaving a significant portion of the student base unsupported.

Even mobile web browsers, which seemed like a fallback, posed major usability problems. Touch-based interactions, such as dragging nodes or creating edges, were unreliable. Often, attempts to create edges would result in accidental scrolling, breaking the modeling flow. The large sidebar occupying a substantial portion of the screen further reduced the usable diagram space, making it impractical to perform meaningful tasks on a phone or tablet. Collectively, these issues made the mobile experience inconsistent, buggy, and largely unusable for students and instructors who needed quick access to modeling tasks outside a desktop environment.


=== Capacitor-Based Mobile Integration

#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]


To resolve these issues, we introduced *Capacitor* #footnote[https://capacitorjs.com] as a solution for cross-platform mobile development. Capacitor is a runtime that allows modern web applications, including React apps, to be bundled and deployed as native applications for both iOS and Android. Unlike previous attempts at native apps, this approach allowed us to maintain a single shared codebase for the web, iOS, and Android platforms, drastically reducing the maintenance overhead.

Using Capacitor, we wrapped the Apollon Standalone Webapp and deployed it to both the Apple App Store and Google Play Store. Capacitor acts as a bridge between the web and native environments, enabling direct access to native APIs while preserving the core modeling functionalities implemented in React. This approach ensured consistent behavior across platforms and eliminated the need for fragmented implementations.

Moreover, the mobile web experience was also improved in the process. By embedding the application in a native container, we were able to better control gestures, scrolling, and touch input. This allowed for smoother interaction and addressed many of the previous shortcomings in browser-based mobile usage.

=== Mobile Usability Improvements

#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]
After introducing Capacitor, we focused on improving the mobile experience beyond simply making the application installable. Several refinements were made to enhance usability specifically for touch-based devices. The sidebar was redesigned to take up less screen space, giving users more room to interact with diagrams on smaller displays. Diagram elements within the sidebar were scaled appropriately so they remained usable even on compact phones.

Touch interaction was overhauled to ensure compatibility with both fingers and styluses such as the Apple Pencil. Drag-and-drop behavior was optimized to reduce accidental scrolling, and edge creation became more intuitive. We increased the size of connection ports on diagram nodes, which made it significantly easier to link elements using touch gestures.

These improvements make the mobile version of Apollon not only functional, but also practical for real-world usage. Students can now comfortably create, edit, and submit diagrams on their phones or tablets, whether during lab sessions, on the move, or during last-minute revisions.

=== Testing Session