#import "/utils/todo.typ": TODO

= Apollon Reengineering

In this section, we explain the reengineering of the Apollon library. We begin by describing the new system design and the monorepo structure, which brings together the standalone version, library, and web application. Then, we detail the new node and edge structure that improves rendering and usability. Afterwards, we explain the newly introduced state management with Zustand and the updated collaboration mode powered by Yjs.

== Library

=== System Design

#align(left)[
  #text(size: 10pt)[Ege Nerse]
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





=== Zustand State Management in Apollon Editor
In the current implementation of Apollon Editor, state management is handled using *Zustand*, a lightweight and scalable state-management library for React. The application maintains three distinct Zustand stores: `DiagramStore`, `MetadataStore`, and `PopoverStore`. Each store encapsulates a specific subset of the editor's state and provides manipulation functions (setters and updaters) accordingly.

*The DiagramStore* is the primary store and manages the core structural and collaborative data of a diagram. It maintains the following state variables:

```
export type DiagramStore = {
  nodes: Node[] // The graphical nodes representing elements in the UML diagram.
  edges: Edge[] // The connections between nodes, forming the relationships in the diagram.
    selectedElementIds: string[] //The identifier of the currently selected elements
  diagramId: string // A unique identifier for each diagram instance.
  assessments: Record<string, Assessment> // A mapping of element IDs to their corresponding assessment data, enabling evaluative feedback and grading.
  ... // update functions for diagram state
}
```

*The MetadataStore* holds metadata related to the current diagram and editor context:

```
export type MetadataStore = {
  diagramTitle: string
  diagramType: UMLDiagramType
  mode: ApollonMode
  readonly: boolean
  ... // update functions for metadata
}
```

These fields facilitate dynamic configuration and rendering of the editor based on the diagram type, title, and interaction mode 

For example mode = Assessment and readonly = true, the editor will act in a SEE_FEEDBACK mode, where students can view their diagrams but cannot make changes. This is particularly useful for assessment scenarios where instructors provide feedback without allowing further modifications.

*The PopoverStore* manages UI popover elements that assist users in editing, providing feedback, or accessing auxiliary functionalities:

```
export type PopoverStore = {
  popoverElementId: string | null
  popupEnabled: boolean
  ... // update functions for popover
}
```

This separation of popover-related state ensures a clear boundary between UI control logic and the structural data of the diagram.

*Integration with Yjs and ReactFlow*

Each instance of `ApollonEditor` is associated with its own *Yjs document*, which enables real-time collaborative editing. A new set of Zustand stores is instantiated and bound to each Yjs document. This coupling ensures that collaborative state changes are synchronized across clients.

Furthermore, *ReactFlow*, the library responsible for diagram rendering, directly consumes the `nodes` and `edges` data from the `DiagramStore`. As a result, the Zustand store becomes the central hub for application state, bridging the rendering engine and collaborative infrastructure.

 *Selector middlewares* and *Subscribers* are used to monitor and react to state changes. For example, a subscriber can be attached to `DiagramStore` using an `onModelChange` listener. This function is typically passed from the web application’s consumer layer and allows it to respond to updates in the underlying data model.
Such updates can duplicates library diagram data into webapp diagram data via scheduled HTTP PUT requests to persist the latest diagram state to a backend server. In local development, these subscriptions are also used to synchronize state with the browser's local storage, ensuring persistence across sessions. This enables users to resume work on previously edited diagrams even after closing and reopening the browser.

An *unsubscribe* callback function is also provided to detach listeners when subscriptions are no longer necessary, thus preventing memory leaks and reducing unnecessary computation.

*Zustand devtools* is also used to enhance the development experience. Zustand provides a built-in middleware for logging state changes, which is particularly useful during debugging and testing phases. This middleware captures all actions dispatched to the store and logs them in the console, allowing developers to trace how state evolves over time. 


=== New Collaboration Mode

The collaboration architecture has undergone a significant transformation in the new system. Previously, state synchronization across clients was achieved by dispatching Redux actions and propagating the resulting patches to peers. Although this approach followed CRDT(Conflict-free Replicated Data Type) principles, it was tightly coupled with Redux’s action-reducer lifecycle and middleware. This design depended heavily on discrete and continuous action types, making it difficult to adapt to newer, more flexible state management tools like Zustand, and challenging to maintain as application complexity increased. 

In the new design, we replaced old Redux and its patch-based propagation mechanism with a more cohesive and robust solution based on Yjs, a CRDT library, and Zustand for local state management. The key idea is to maintain a fully synchronized state between the local client’s Zustand store and a shared Yjs document (ydoc), even in the absence of a network connection or other active collaborators. If a user reconnects after being offline, the local state is automatically reconciled with the Yjs document, ensuring that all changes are captured and propagated correctly.

Each client maintains its own instance of ydoc, which mirrors the Zustand store. Any changes to the local store are immediately reflected in ydoc, and vice versa. This bidirectional sync ensures consistency and enables offline editing capabilities. The library powering this system exposes two main functions for collaboration:
sendBroadcastMessage(data: string)
receiveBroadcastedMessage(data: string)

These functions are used to propagate state changes to other clients and handle incoming updates, respectively.

Initially, the internal synchronization class (YjsSyncClass) does not have a sendBroadcastMessage function set. Once provided, this function is invoked whenever ydoc is updated via the local store. If an update originates from a local state change (as opposed to a remote one), it is serialized and sent to other connected clients. This design ensures that every state change, even rapid ones like drag movements, is reliably broadcasted, unlike the old system where frequent updates could be throttled or dropped. Since we are using ReactFlow and snaptoGrid features for movements and resizes, all updates are discrete and do not require throttling, making the system more responsive and accurate.

Synchronization Protocol
When a new client joins (e.g., client C3 joins a session with existing clients C1 and C2), the following sequence occurs:
- C3 sends a synchronization request to the server, which is broadcasted to C1 and C2.
- C1 and C2 respond by broadcasting their latest ydoc state.
- C3 receives these updates and merges them into its local ydoc.

This bootstrapping ensures that the new client receives the most recent state from all participants.

Once all clients are in sync, collaboration proceeds as follows:

When a client (e.g., C1) makes a local change, the update is reflected in its ydoc.

If sendBroadcastMessage is set, the serialized update is sent via an open WebSocket connection to other clients.

Recipients (e.g., C2 and C3) decode the message using syncManager.handleReceivedData and apply the update to their local ydoc.

Message Format and Handling
All broadcasted data is transmitted in Base64-encoded format, making it easily serializable within JSON objects. Upon reception:

The Base64 string is decoded into a Uint8Array.
The first byte of the array indicates the message type: either a SYNC or an UPDATE.
SYNC messages trigger the creation and broadcast of an UPDATE message containing the full state of the client's ydoc.
UPDATE messages apply partial changes to the client's ydoc.

To avoid infinite update loops, all incoming changes are tagged with their origin (local or remote). Clients subscribe to changes in their ydoc and propagate updates to the Zustand store only when necessary, ensuring a clear separation between internally generated and externally received updates.


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