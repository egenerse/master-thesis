#import "/utils/todo.typ": TODO

= Apollon Reengineering

In this section, we explain the reengineering of the Apollon. We begin by describing the new system design and the monorepo structure, which brings together the library, the web application and the server. Then we detail reengineering of library and continue with standalone and lastly mobile application and mobile browsers.


== System Design


The Apollon project is restructured into a unified monorepo architecture that consolidates three core subsystems: the Apollon library, the web application, and the backend server. This redesign enhances modularity and simplifies development workflows. It also streamlines deployment processes across the entire system. By centralizing related components, the monorepo makes it easier to apply changes across packages and maintain consistency throughout the project.

To support a consistent and maintainable development workflow across all packages, the monorepo integrates several tooling and configuration standards:

*TypeScript*: is used throughout the project to enforce type safety across package boundaries. This reduces integration errors, improves code readability, and enhances developer experience with features like autocompletion and static analysis.

*npm Workspaces*: enable coordinated dependency management and script execution across packages. This allows common tasks such as building, testing, or linting to be run from the root, reducing manual overhead and ensuring synchronized behavior across the system.

*Prettier*: is configured to enforce consistent code formatting, ensuring that the codebase remains clean and readable regardless of which package is being modified.

*Husky*: is used to define Git hooks that enforce code quality at the commit level. Pre-commit hooks automatically run linters and formatters to catch issues early, while a commit-msg hook ensures that all commit messages follow the Conventional Commits standard. This improves the clarity of the project's history and supports automation in releases and changelogs.

These tools contribute to a modular, scalable, and developer-friendly system design and helping maintain high code quality and consistency across a growing, multi-package architecture.

=== Apollon Library
  This is the core module that encapsulates all modeling-related functionalities. It handles rendering and layout using React Flow, defines UML data structures, manages interaction logic such as selection and editing, and provides utilities like export and import diagrams 

  The library uses Zustand for centralized and scalable state management and integrates Yjs, a CRDT-based framework, for real-time collaboration. Yjs works through a shared Y.Doc object that synchronizes state across multiple clients. We will describe this mechanism in more detail in Section 5.5.

  To connect the application state with the Yjs document, the library also includes a Yjs sync component that links the store and collaborative state updates.

  The Apollon Library exposes its full functionality through the ApollonEditor interface. This allows external applications, like the webapp or Artemis, to easily embed and interact with the editor instance without needing to access internal logic directly.

=== Apollon Standalone Webapp

  This is the user-facing subsystem that builds upon the Apollon library. It provides the interface where students and instructors can create, edit, and manage UML diagrams using exposesd functionalities of the Apollon library. 
  The webapp uses the `ApollonEditor` interface to embed and control the editor. It also includes a `DiagramAPIManager` service responsible for fetching models from and saving them to the backend server.
  For collaboration, the webapp connects to the backend using a `WebSocketManager` service, which handles WebSocket connections and dispatches events. This keeps the editor state synchronized between clients during collaborative sessions.

  Global state management in the webapp is also handled using persistent Zustand same as library, which allows keeping the diagrams data in sync with the browser's local storage. This ensures that users can resume their work even after closing the browser through load diagram feature in the web application.


=== Apollon Standalone Server

  This is a backend service designed to support persistence diagrams and enable WebSocket-based real-time collaboration. Acting as a relay server, it forwards messages between clients without interpreting them.

  A key feature is the room-based message broadcasting system, implemented in the WebSocket server. Each collaborative session corresponds to a distinct "room" identified by a diagramId, and any message received from one client is automatically relayed to all other connected clients in the same room. This allows for efficient and low-latency collaboration without centralized state processing.

  Beyond real-time communication, the server provides model persistence via RESTful API endpoints exposed by the Diagram Router (PUT, POST, GET), enabling users to save diagrams to a persistent database and seamlessly resume work across sessions.

  Diagram data is stored in a MongoDB database, with Mongoose used to define schemas, validate data, and perform CRUD operations ensuring consistency and simplifying integration with the rest of the system.

  To maintain performance and storage efficiency, a scheduled cron job runs nightly at 00:00 to automatically delete diagrams not updated more than 60 days, keeping the database focused on recent and relevant models.

#figure(
  image("../figures/ApollonOverviewDetailed.jpg", width: 90%),
  caption: [System overview of the new Apollon architecture.]
)

== Library

In this section, we describe the redesigned architecture and key features of the new Apollon core library. This includes the updated node structure, enhanced edge logic, state management using Zustand, and real-time collaboration powered by Yjs. We also highlight several usability improvements made during the reengineering process.

=== Node Structure

The internal data model for UML elements in Apollon has been redesigned to align with React Flow’s architecture. Each UML element is now represented using a custom React Flow node component that encapsulates both rendering and interaction logic. This modular approach enables the creation of interactive and visually consistent UML diagrams while maintaining a clean separation of concerns.

To support intuitive diagramming, each node includes custom handler and resizer components. These allow users to resize UML elements and create connections by dragging from source to target handles, resulting in a more flexible modeling experience.

@oldNodeStructureDiagram shows the previous node structure: all elements were stored as separate top level objects. For example Class elements referenced their attributes and methods using ID arrays. Additionally, different class stereotypes like abstract classes, interfaces, and enumerations were modeled as entirely different node types (AbstractClass, Interface, Enumeration), each with its own structure and behavior.

Example of the class data structure is shown below:

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


#figure(
  image("../figures/OldNodeType.png", width: 90%),
  caption: [Class Element types in Old Apollon]
)<oldNodeStructureDiagram>

This structure proved incompatible with React Flow, which treats each node as a unified, self-contained component. In response, @newNodeStructureDiagram shows the new node structure which adopts a nested structure: attributes and methods are now embedded directly within the parent class node’s data field. Moreover, the previously separate types for abstract classes, interfaces, and enumerations have been unified under a single Class node type, distinguished by a stereotype field.

This stereotype field can be one of: null (plain class), abstract, interface, or enumeration. This approach simplifies the model, reduces redundancy, and allows for more flexible and expressive rendering in React Flow.


#figure(
  image("../figures/NewNodeType.png", width: 90%),
  caption: [New Class Node structure in Apollon Reengineering]
)<newNodeStructureDiagram>

This nested and stereotype-aware design simplifies the model, reduces redundancy, and enables more flexible node rendering within React Flow. Most UML elements such as Packages, Components, Subsystems, Interfaces, Use Cases, and Actors, fit naturally into this new structure as they do not contain nested elements. The Class element remains the main exception due to its need to internally encapsulate attributes, methods, and stereotype data.

=== Edge Structure

In the previous version of Apollon, edge rendering was stable and functional, but it had limitations in terms of visual clarity. For example, @oldDiagonalEdge shows the diagonal edge creation between two class components. The diagonal edges make UML diagrams harder to read and deviated from typical modeling standards. Additionally, the older system supported only four connection ports (top, bottom, left, right) on each node, which restricted flexibility in edge routing.

This hybrid method avoids the creation of awkward diagonal lines and improves the visual clarity of the diagrams.
#figure(
  image("../figures/DiagonalEdge.png", width: 50%),
  caption: [Diagonal Edge between two class nodes in Old Apollon version]
)<oldDiagonalEdge>

In the reengineered Apollon, we adopted a hybrid edge rendering approach that combines techniques from both the old system and modern features of React Flow. Specifically:

We use Step Edges from React Flow to generate clean, orthogonal paths between distant nodes.

When nodes are positioned closer than a defined threshold, we fall back to rendering a Straight Edge using logic adapted from the old Apollon implementation.


We also increased the number of ports per node to allow finer control over where edges connect. This gives users more layout flexibility and helps avoid overlapping edges in dense diagrams. @edgeHandlersOld displays the old edge handles and @edgehandlersNew shows the new edge handles, where we can easily see that user has more flexibility.

#figure(
  image("../figures/OldEdgePort.png", width: 50%),
  caption: [Edge handlers in Old Apollon version]
)<edgeHandlersOld>

#figure(
  image("../figures/NewEdgePort.png", width: 50%),
  caption: [Edge handlers in New Apollon version which is increased]
)<edgehandlersNew>

Another significant usability addition is the introduction of ghost edge previews. As users begin drawing an edge, the system displays a transparent preview of the potential connection. This helps users understand where the edge will connect before finalizing the action as seen in @newEdgeCreationGhostEdge.

#figure(
  image("../figures/newEdgeCreationGhostEdge.png", width: 70%),
  caption: [New Edge Creation with Ghost Edge Preview in New Apollon version]
) <newEdgeCreationGhostEdge>


=== Zustand State Management in Apollon Editor

State management is handled using Zustand in the new Apollon Editor. The application maintains three distinct Zustand stores: DiagramStore, MetadataStore, and PopoverStore. Each store encapsulates a specific subset of the editor's state and exposes dedicated methods to update and manipulate that state.

*The DiagramStore:* is the primary store and manages the core structural and collaborative data of a diagram. It maintains the following state variables:

```ts
export type DiagramStore = {
  nodes: Node[] // The graphical nodes representing elements in the UML diagram.
  edges: Edge[] // The connections between nodes, forming the relationships in the diagram.
    selectedElementIds: string[] //The identifier of the currently selected elements
  diagramId: string // A unique identifier for each diagram instance.
  assessments: Record<string, Assessment> // A mapping of element IDs to their corresponding assessment data, enabling evaluative feedback and grading.
  ... // update functions for diagram state
}
```

React Flow expects each parent node to appear before any of its children in the node array. To ensure this ordering, we use the sortNodesTopologically function, which arranges the nodes according to their hierarchical relationships. This is especially important in UML diagrams, where maintaining the correct visual and logical structure of parent-child relationships is essential.

*The MetadataStore:* holds metadata related to the current diagram and editor context:

```ts
export type MetadataStore = {
  diagramTitle: string
  diagramType: UMLDiagramType
  mode: ApollonMode
  readonly: boolean
  ... // update functions for metadata
}
```

The editor's behavior is determined by the combination of mode and readonly flags:

```
mode = "Editing" → EDIT mode: users can freely modify the diagram.
mode = "Assessment" and readonly = false → GIVE_FEEDBACK mode: instructors can provide feedback on student diagrams.
mode = "Assessment" and readonly = true → SEE_FEEDBACK mode: students can view feedback but cannot make changes.
```
This logic is particularly useful in assessment scenarios where control over editability and feedback visibility is essential.

*The PopoverStore:* manages UI popover elements that assist users in editing, providing feedback, or seeing functionalities:

```ts
export type PopoverStore = {
  popoverElementId: string | null
  popupEnabled: boolean
  ... // update functions for popover
}
```

This separation of popover-related state ensures a clear boundary between UI control logic and the structural data of the diagram.

*Zustand Integration with Yjs:* Each instance of ApollonEditor is backed by its own Yjs document, enabling real-time collaborative editing. To manage local state, a dedicated set of Zustand stores is created and bound directly to the Yjs document. This tight coupling ensures that all local and remote state changes remain consistent across multiple clients.

At the core of this integration is a bidirectional sync mechanism:

From Zustand to Yjs:
Many state-updating functions in the editor such as onNodesChange update the Zustand store first, and then explicitly perform a Yjs transaction via ydoc.transact(...). This ensures that changes such as adding, updating, or deleting nodes are propagated to the Yjs document in a controlled and observable way. For example, in onNodesChange, position or structural changes to nodes are wrapped in a Yjs transaction with the origin "store", ensuring both correctness and traceability across clients.

From Yjs to Zustand:
 Incoming updates from other collaborators are observed by YjsSyncClass, which listens for changes on the Yjs document. When a Yjs transaction originates from a remote source (i.e., not from the local store), the update is consumed and applied to the local Zustand state. To prevent infinite update cycles between users, these externally received changes bypass the sendBroadcast function. Instead, the state is updated using a dedicated method, updateNodesFromYjs, which specifically applies updates without triggering broadcasts. This approach ensures that the internal node state is synchronized, user selections are preserved, and stale data is correctly removed.

@ZustandSync Activity Diagram shows how Zustand and Ydoc communication is carefully managed to prevent infinite update cycles: the use of transaction origins (like "store" and "remote") allows each side to distinguish between local and remote changes and act accordingly.

#figure(
  image("../figures/ZustandandYsSyncSendBroadcast.png", width: 90%),
  caption: [Zustand and Yjs Synchronization Activity Diagram]
)<ZustandSync>

This design ensures: Real-time collaboration, safe updates, consistent state across all clients.

*Zustand Integration with ReactFlow*: ReactFlow the library responsible for diagram rendering, directly consumes the nodes and edges data from the DiagramStore. As a result, the Zustand store becomes the central hub for application state.

Selector middlewares and Subscribers are used to monitor and react to state changes. For example, a subscriber can be attached to DiagramStore using an onModelChange listener. This function is typically passed from the web application’s consumer layer and allows it to respond to updates in the underlying data model.

Such updates can duplicates library diagram data into webapp diagram data via scheduled HTTP PUT requests to persist the latest diagram state to a backend server. In local development, these subscriptions are also used to synchronize state with the browser's local storage, ensuring persistence across sessions. This enables users to resume work on previously edited diagrams even after closing and reopening the browser.

An unsubscribe callback function is also provided to detach listeners when subscriptions are no longer necessary, thus preventing memory leaks and reducing unnecessary computation.

Zustand devtools is also used to enhance the development experience. Zustand provides a built-in middleware for logging state changes, which is particularly useful during debugging and testing phases. This middleware captures all actions dispatched to the store and logs them in the console, allowing developers to trace how state evolves over time. 


=== New Collaboration Mode

The collaboration architecture has been significantly redesigned to be simpler, more maintainable, and better aligned with modern state management practices. In the previous system, client state synchronization was handled by dispatching Redux actions and propagating the resulting patches to peers. Although this followed CRDT principles, it was deeply tied to Redux’s action-reducer lifecycle and middleware, which introduced unnecessary complexity and made it difficult to transition to newer, more flexible tools.

In the new system, Redux and its patch-based synchronization have been fully replaced with a streamlined solution built on Yjs, a CRDT library, and Zustand for local state management. This architecture maintains a synchronized state between each client’s local Zustand store and a shared Yjs document. Each client holds its own Yjs document (ydoc), which is kept in sync with the local store in both directions. Changes to the store are immediately reflected in ydoc, and updates from ydoc are applied back to the local store. This bidirectional synchronization ensures consistency and supports offline editing.

The core of this system is the YjsSyncClass, which manages the synchronization between the Zustand store and the Yjs document. The class allows injection of a sendBroadcastMessage function, typically provided when the client establishes a WebSocket connection. This injected function is responsible for sending local updates originating from Zustand, marked as Yjs transactions with the "store" origin to other connected clients. This design ensures that local changes, including fast interactions like drag movements, are reliably broadcasted without throttling or data loss. Since React Flow’s snapToGrid feature discretizes movements and resizes, no additional throttling is required, resulting in a highly responsive synchronization process.

The system provides two key functions to manage state propagation:

  ```ts
  sendBroadcastMessage(data: string): sends serialized local updates to other clients. ```

  ```ts receiveBroadcastedMessage(data: string): processes incoming updates from other clients.  ```

These functions form the communication bridge between clients in a collaborative session.


*Synchronization Protocol*: When a new client joins an active session, the following process occurs:

+ The new client sends a synchronization request to the server.

+ Existing clients respond by broadcasting their latest Yjs document state.

+ The new client receives and merges these updates into its local Yjs document.

This bootstrapping ensures that the new client receives the most recent state from all participants.

After initial synchronization, collaboration continues:

+ When a client makes a local change, it updates its Yjs document.

+ If sendBroadcastMessage is configured, the update is serialized and broadcasted to other clients over the WebSocket connection.

+ Other clients receive the message, decode it, and apply the update to their local Yjs document using syncManager.handleReceivedData.


*Message Format and Handling*: All broadcast messages are transmitted as Base64-encoded strings, making them easily serializable in JSON. Upon receiving a message:

+The Base64 string is decoded into a Uint8Array.

+The first byte of the array indicates the message type: either SYNC or UPDATE.

+*SYNC* messages trigger the creation and broadcast of an UPDATE message containing the full Yjs document state.

+*UPDATE* messages apply received full ydoc states to the local ydoc state.

To prevent infinite update loops, every Yjs transaction is tagged with its origin. Clients listen for changes in their Yjs document and apply updates to the Zustand store only when the change originates from a remote source. This ensures that locally generated changes are not redundantly re-applied and keeps internal and external update flows separated.


=== Usability Improvements

The new system introduces key enhancements aimed at improving the overall modeling experience, with a strong focus on flexibility, spatial freedom, and user control.

The most significant addition is the infinite canvas, which removes the spatial limitations of the previous finite design. Users can now freely add and move elements anywhere on the canvas without restriction, enabling more natural and scalable diagram building. This change dramatically improves usability, especially for large and complex models.

A minimap is available to assist with navigation in expansive diagrams

We also introduced a zoom control panel in the bottom-left corner, providing users with quick access to zoom in, zoom out, center the canvas, and reset to 100% zoom. The zoom levels currently range between 40% and 250%, with flexible configuration if adjustments are needed in the future.

The snap-to-grid feature, which existed in the previous version, has been retained and is now set to a 10px grid size for more precise alignment and consistent element positioning.

Edge creation has also been improved. As users begin drawing an edge, a ghost connection preview now appears, clearly indicating where the edge will connect. This reduces confusion and improves accuracy during the modeling process. We also expanded the number of edge handles (ports) available on diagram nodes, giving users more flexibility in where to attach edges.

To avoid layout issues, we removed support for diagonal edge paths, which were previously difficult to place and visually inconsistent. The new edge system ensures cleaner, more predictable connections, reducing user frustration and improving the overall visual quality of diagrams.

== Standalone

The standalone application provides a complete modeling environment built on top of the Apollon core library. It allows users to create and edit diagrams directly in the browser without requiring authentication or a user account. This lightweight interface makes it ideal for quick prototyping, experimentation, or educational use outside of larger systems like Artemis.

The standalone version provides local storage for saving diagrams, allowing users to resume work on their models even after closing the browser. This feature is useful to quickly sketch out ideas or create simple diagrams. Also we provide load diagram feature that allows users to load their previously saved diagrams from the browser's local storage.

The standalone web application also has a dedicated playground url for testing and experimenting Apollon features as seen in the @apollonWebappPlayground .

#figure(
  image("../figures/ApollonWebappPlayground.png", width: 90%),
  caption: [Apollon Standalone Web Application Playground]
) <apollonWebappPlayground>


=== Apollon Standalone Deployment Setup

To ensure that the reengineered version of Apollon is available reliably in production environments, we deployed the system using a reverse proxy configuration centered around modular services. The application consists of three subsystems: the Apollon webapp, a backend server responsible for WebSocket-based collaboration and RESTful API endpoints, and a persistent database for storing models. These components are containerized and managed using Docker Compose.

At the core of the deployment infrastructure is Caddy #footnote[https://caddyserver.com], a modern web server and reverse proxy that simplifies configuration, particularly for projects that rely heavily on secure WebSocket connections. All incoming HTTP and HTTPS traffic is routed through Caddy, which acts as a single entry point into the system. When a request arrives, Caddy evaluates the path. If the path begins with /ws or /api, the request is proxied to the Apollon server, which handles WebSocket communication for real-time collaboration or API requests for loading and storing diagrams. All other requests, including the base path, are directed to the Apollon webapp, which serves the frontend application.

We selected Caddy over alternatives such as Nginx because of its simplified setup and built-in support for automatic HTTPS via Let’s Encrypt. Traeffic was also handling automatic encryption however Caddy provides easier configuration with Caddyfile especially for websocket connections. This eliminated the need for manual TLS certificate configuration and allowed us to maintain a clean and concise reverse proxy setup with native WebSocket support. The flexibility of Caddy made it especially well-suited for our use case, which requires consistent handling of real-time data streams across devices.


The entire system is hosted on a managed virtual machine. Docker Compose manages the containers and ensures that the services remain up through restart policies and built-in health checks. The firewall configuration on the server allows external traffic only through the Caddy ports: port 80 for HTTP and port 443 for HTTPS. Port 80 is used to support automatic redirection to HTTPS, ensuring secure connections for all users, while port 443 handles the encrypted HTTPS traffic. All internal services communicate over a private Docker network. Sensitive environment variables such as database credentials and API tokens are injected at runtime using .env files that are excluded from version control. This approach maintains both security and modularity, allowing for easier adaptation between staging and production environments.

=== Testing Session

We conducted testing sessions for the Apollon2 Web App and its new library integration to assess usability, uncover bugs, collect enhancement ideas, and validate key interactions. Test participants from various backgrounds interacted with the application in realistic scenarios and provided actionable feedback.

Testers found bugs during manual testing session and then we prioritized the found bugs and summarized them into @BugTableWeb with their status.


#figure(
  table(
    columns: 2,
    align: (left, center),
  [*Found Bug*], [*Status*],
  [Cursor changes to hand icon during resize instead of arrow], [✅ Fixed],
  [Cannot unselect relations after rotation], [✅ Fixed],
  [Import fails with invalid diagram type], [✅ Fixed],
  ["Create from Template" does not work], [✅ Fixed],
  [Icon next to lock is not informative or clickable], [✅ Fixed],
  [Attributes not rendering properly in collaboration mode], [✅ Fixed],
  [Double-click does not open editing mode], [✅ Fixed],
  [Input fields create new elements on unfocus], [✅ Fixed],
  [Local diagram disappears after reload], [✅ Fixed],
  [Hide selection highlights in PNG export], [✅ Fixed],
  [Class diagram height is not adjustable], [Not a Bug],
  [Canvas gestures unintuitive (should match Lucidchart)], [Not a Bug],
  [Lock mode does not disable node selection], [✅ Fixed],
  ),
  caption: [Bug feedbacks from Apollon2 Web App testing sessions.]
)<BugTableWeb>


User feedback played a crucial role in shaping the direction of improvements. Beyond identifying bugs, testers also proposed valuable enhancement ideas that could significantly improve the usability and intuitiveness of the application. We reviewed, evaluated, and prioritized these suggestions based on user impact and implementation feasibility. The @EnhancementWeb below highlights the most relevant enhancement ideas along with their current status.


#figure(
  table(
    columns: 2,
    align: (left, center),
  [*Enhancement Idea*], [*Status*],
  [Make minimap icon more intuitive], [✅ Improved],
  [Adjusting relations is hard due to offset UI], [⏳ In Backlog],
  [Too many connection dots on small rectangles], [⏳ In Backlog],
  [Allow deleting elements with Delete key], [✅ Improved],
  [Add tooltips and improve icon intuitiveness], [⏳ In Backlog],
  [Clarify "Edit" mode text in Share section], [⏳ In Backlog],
  [Improve minimap toggle interaction], [✅ Improved],
  ),
  caption: [Enhancement feedbacks from Apollon2 Web App testing sessions.]
)<EnhancementWeb>


== Mobile Browser and Application


In recent years, mobile devices have become essential tools for both formal education and self-directed learning. Students frequently use smartphones and tablets to complete tasks, review materials, and collaborate with peers, especially in remote or hybrid learning contexts. Studies have shown that mobile learning increases flexibility and accessibility, improving engagement and learning outcomes across diverse student groups @denoyelles2023evolving.

Ensuring that educational tools like Apollon work seamlessly across all platforms including desktops, tablets, and phones enhances their usability and relevance. Platform consistency allows students to switch between devices without facing different interfaces, behaviors, or limitations. This consistency improves productivity and reduces the cognitive load associated with context switching, especially when learning complex modeling tasks @mendel2009interface.

Furthermore, mobile support benefits instructors and developers by making the application available in a wider range of usage scenarios from classroom demonstrations to on the go corrections and feedback. Enabling cross-platform access is not just a matter of convenience but a requirement for inclusive and future proof educational software.

The earlier version of Apollon attempted to support mobile platforms by maintaining a separate iOS application in a different repository. However, this approach came with multiple limitations. @iosbug shows how the iOS app suffered from severe rendering issues when users moved nodes on the canvas, text such as class names, attributes, or methods often shifted away from their designated positions. This was caused by inconsistencies in how coordinate translations were handled during drag interactions on iOS devices, especially in combination with scaling and zooming.

#figure(
  image("../figures/classDiagramBug.jpeg", width: 90%),
  caption: [Node Translation Bug in current iOS Apollon Application]
) <iosbug>

Maintaining a separate codebase also became a burden. Every update made to the web version had to be mirrored manually in the iOS repository, leading to duplicated efforts and a growing risk of divergence between the two platforms. Additionally, this approach completely excluded Android users, leaving a significant portion of the student base unsupported.

Even mobile web browsers, which seemed like a fallback, posed major usability problems. Touch-based interactions, such as dragging nodes or creating edges, were unreliable. Often, attempts to create edges would result in accidental scrolling, breaking the modeling flow. The large sidebar occupying a substantial portion of the screen further reduced the usable diagram space, making it impractical to perform meaningful tasks on a phone or tablet. Collectively, these issues made the mobile experience inconsistent, buggy, and largely unusable for students and instructors who needed quick access to modeling tasks outside a desktop environment.


=== Capacitor-Based Mobile Integration

To resolve these issues, we introduced Capacitor #footnote[https://capacitorjs.com] as a solution for cross-platform mobile development. Capacitor is a runtime that allows modern web applications, including React apps, to be bundled and deployed as native applications for both iOS and Android. Unlike previous attempts at native apps, this approach allowed us to maintain a single shared codebase for the web, iOS, and Android platforms, drastically reducing the maintenance overhead.

Research on hybrid mobile applications supports these benefits, showing that developers are able to reduce both time-to-market and maintenance effort by reusing web technologies within native shells @Malavolta15. Industry practices also reflect this trend, as modern frameworks like Capacitor have emerged specifically to bridge the gap between web and native, allowing teams to focus on a single stack without sacrificing access to platform-specific capabilities @Wargo20. For projects like Apollon, where interface logic and collaborative modeling features are shared across devices, maintaining a single codebase was essential to delivering a consistent user experience without incurring the overhead of managing multiple codebases.

Using Capacitor, we wrapped the Apollon Standalone web app and deployed it to test users via both Apple TestFlight and an Android APK. Capacitor acts as a bridge between the web and native environments, enabling direct access to native APIs while preserving the core modeling functionalities implemented in React. This approach ensured consistent behavior across platforms and eliminated the need for fragmented implementations.

=== Mobile Usability Improvements

After introducing Capacitor, we focused on improving the mobile experience beyond simply making the application installable. Several refinements were made to enhance usability specifically for touch-based devices. The sidebar was redesigned to take up less screen space, giving users more room to interact with diagrams on smaller displays. Diagram elements within the sidebar were scaled appropriately so they remained usable even on compact phones.

Touch interaction was overhauled to ensure compatibility with both fingers and styluses such as the Apple Pencil. Drag-and-drop behavior was optimized to reduce accidental scrolling, and edge creation became more intuitive. We increased the size of connection ports on diagram nodes, which made it significantly easier to link elements using touch gestures.

These improvements make the mobile version of Apollon not only functional, but also practical for real-world usage. Students can now comfortably create, edit, and submit diagrams on their phones or tablets, whether during lab sessions, on the move, or during last-minute revisions.

=== Testing Session

We conducted a dedicated testing session for the Apollon2 Mobile App, focusing on tablet and phone interactions, including Apple Pencil usage and mobile-specific UI behavior. The goal was to evaluate touch and gesture usability, detect mobile-only bugs, and gather platform-specific enhancement ideas.

Participants explored a range of interactions such as node creation, edge manipulation, and UI navigation. Their feedback uncovered a number of platform-specific issues, which are listed below.

We categorized the bugs reported and included their current development status in the @bugTableIOS:

#figure(
table(
columns: 2,
align: (left, center),
[Found Bug], [Status],
[Edge popover icon renders in wrong position], [✅ Fixed],
[Node toolbar/popup not clickable with Apple Pencil], [⏳ In Backlog],
[Node outline gets bigger after stacking/moving], [⏳ In Backlog],
[Selection with Apple Pencil not possible], [⏳ In Backlog],
[Node outlier expands incorrectly when changing type], [⏳ In Backlog],
[Package resizing too small to interact], [✅ Fixed],
[Gaps between nodes and edges], [✅ Fixed],
[Package resizes in wrong direction when dragged], [⏳ In Backlog],
[Cannot unselect edges], [✅ Fixed],
[Cannot select edges], [✅ Fixed],
[Clicking edge multiple times distorts path], [✅ Fixed],
[Edge markers don’t update after type change], [✅ Fixed],
),
caption: [Bug feedbacks from Apollon2 Mobile App testing sessions.]
)<bugTableIOS>

In addition to the bugs, participants suggested mobile specific enhancements to improve the user experience on smaller screens. These ideas are listed in the @enhancementMobile below along with their current status:

#figure(
table(
columns: 2,
align: (left, center),
[Enhancement Idea], [Status],
[Keyboard should auto-focus when editing attribute], [⏳ In Backlog],
[Make minimap open/close behavior intuitive], [✅ Improved],
[Popover should close on "Done" or return key], [⏳ In Backlog],
[Make edge creation easier and more natural], [✅ Improved],
),
caption: [Enhancement feedbacks from Apollon2 Mobile App testing sessions.]
)<enhancementMobile>