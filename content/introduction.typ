#import "/utils/todo.typ": TODO

= Introduction

#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]


Designing and understanding software systems supports both education and the development of real-world solutions. UML tools help students and developers structure, explain, and refine complex systems. Apollon offers an open-source UML diagram editor that enables users to model systems clearly and effectively. Students and instructors actively use Apollon within Artemis—a learning platform that delivers interactive education on programming exercises, quizzes, modeling tasks, and more.

Apollon, however, includes several limitations. Its codebase relies on outdated React class components, which complicates maintenance and feature development. The interface hides key functionalities and creates a steep learning curve for new users. Mobile support remains limited. The old iOS app contained rendering bugs and lacked proper touch handling. No native Android app existed, and the mobile browser version failed to support intuitive interactions.

We initially tried to improve the current iOS repository and standalone application through incremental updates and bug fixes. However, these patches exposed deeper architectural issues that made sustainable improvements difficult. Instead of continuing with bugfixes and updates, we decided to reengineer Apollon entirely. To guide this process, we conducted a series of experiments to evaluate modern libraries and frameworks that could better support our goals.

This thesis documents that whole process of identifying limitations in the previous tool, designing the Apollon Reengineering library, developing, and integrating it with Artemis.


== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]

Apollon has several technical and usability problems that affect both students and developers. The tool still uses outdated React class components, Redux, and Saga for state and side-effect management, which makes the code hard to read, debug, and extend. Developers face difficulties when adding new features or fixing bugs because of the tightly coupled and complex architecture, slowing progress and introducing further errors.

The rendering logic is another major issue. For example, attempting to add elements such as a package lead to infinite render loops in development environment and freezes the application. These bugs create an unreliable experience, causing frustration for developers.

The situation worsens on mobile devices. The app does not support drag-and-drop interactions, in order to create new element user clicks the plus button and it is randomly put in the canvas. Afterwards user needs to click  left bottom icon for moving the element like it is shown in @componentDiagramiOS. Moving and Resizing elements are not very flexible.
#figure(
  image("../figures/ComponentDiagramIOS.png", width: 90%),
  caption: [Translation bug of moving the class element in Apollon iOS App]
) <componentDiagramiOS>

Also moving elements causes bugs that texts are completely go somewhere else as we can see from @translationBugInIOSApp. Mobile browsers have totally different issues, sidebar consumes a lot of space that it gives few space to work on.

#figure(
  image("../figures/classDiagramBug.jpeg", width: 90%),
  caption: [Translation bug of moving the class element in Apollon iOS App]
) <translationBugInIOSApp>

Additionally, diagram aesthetics suffer due to the way edges are rendered. Instead of clean lines, some connections appear with awkward diagonal shapes, distorting UML diagrams and reducing their readability and professionalism. These visual inconsistencies negatively affect the quality of diagrams submitted for exercises and assessments.

Initial attempts to address these problems through refactoring showed limited results. Although improvements were made—such as replacing class components in the standalone web app with functional ones and introducing Redux Toolkit—many structural issues persisted, especially in the core diagramming library. The growing complexity, legacy design, and fragile architecture of the codebase made it progressively harder to implement improvements.


== Motivation


Clear and reliable diagramming tools help students express their understanding of software systems in exercises, exams, and projects. When the tool works smoothly, students can focus on the actual content—like designing class structures or modeling system behavior—without getting distracted by usability issues. By improving Apollon’s responsiveness and user experience through complete reengineering, students can complete modeling tasks faster and with fewer errors.

We first attempted to fix bugs in the existing iOS application and update the standalone web app. However, we quickly realized that the legacy architecture—built with class-based React components, outdated state management, and tightly coupled logic—made even small improvements hard to maintain. Each update required duplicate work across repositories and often introduced new bugs. These limitations revealed the need for a more sustainable solution and led us to reengineer the entire system from scratch.

This thesis is motivated not only by usability issues but also by the opportunity to apply modern software engineering practices that better reflect how students learn and how real-world tools operate. We rebuilt the system using functional React components, Zustand for state management, and React Flow for rendering interactive diagrams. These technologies reduce architectural complexity, improve maintainability, and enable faster feature development.

Improved interaction design directly enhances learning. Features like a simplified sidebar, UML-compliant edge rendering, infinite canvas, and minimap improve clarity and navigation. Students can now access features more easily, build diagrams more confidently, and experience less frustration during assessments. Following usability principles—such as Nielsen’s heuristics on visibility, flexibility, and efficiency—makes the tool more intuitive and user-friendly [@nielsen1995usability].

We also prioritized mobile accessibility. Many students rely on tablets in their daily routines and often need to make quick updates to their diagrams while on the move. Instead of just improving the mobile browser experience, we adopted Capacitor to create native iOS and Android applications from a single codebase. This approach ensures consistent behavior across platforms. Studies confirm that mobile accessibility improves engagement and flexibility in education [@tre2023mobile].

We also enhanced developer experience by integrating Zustand’s devtool plugin, complementing existing tools like Redux DevTools. Developers can now observe state transitions, identify the functions triggering updates, and track resulting changes in real time—making the development process more transparent and efficient.

Finally, we improved real-time collaboration by integrating Yjs, a CRDT-based synchronization framework. CRDTs (Conflict-free Replicated Data Types) allow distributed systems to synchronize changes without conflicts, even in offline scenarios. Yjs enables students to collaboratively edit diagrams in real time, ensuring consistent state and low latency, which enhances teamwork and productivity.

In short, we reengineered Apollon to help students create better diagrams, collaborate effectively, and work seamlessly across devices—all within a modern, maintainable architecture.



== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]

To guide the implementation process, a series of proofs of concept (POCs) were conducted to evaluate the viability of various frameworks and libraries. These included experiments with Angular, React, React Flow, and Capacitor, focusing on rendering strategies, mobile support, and usability. The results indicated that a React-based architecture, using React Flow for diagramming and Capacitor for mobile packaging, offered the most flexible and scalable foundation.

Based on these findings, the project defines the following three main objectives:

1. *Reengineer the Apollon codebase using modern React technologies and create a reusable library interface*
2. *Enhance accessibility for both web and mobile users*
3. *Improve the overall usability and visibility of the application*

=== Reengineer the Apollon Codebase Using Modern React

The first objective is to replace the outdated class-based React architecture with modern *functional components*, using *React Flow* as the core rendering and layout engine. This transformation improves maintainability, supports modular development, and creates a solid foundation for future extensions. While modernizing the internals, we preserved a key architectural idea from the original Apollon: exposing the diagram editor through a central class interface that can be embedded into any host application.

- *Proofs of Concept and Technology Evaluation*  
  We explored alternative approaches with Angular and evaluated diagramming libraries. The final design is based on React Flow and functional React after testing custom node rendering, edge handling, and drag/drop behavior.

- *Creation of the `ApollonEditor` Interface Class*  
  Similar to the original Apollon, our implementation includes a core class—`ApollonEditor`—that serves as the main integration layer between the library and external consumers (e.g., the standalone web app or Artemis). It follows the same pattern of injecting the React application into a target HTML element. The class exposes a stable API for consuming applications, including methods such as `subscribeToModelChange`, `getModel`, `setModel`, `exportAsSVG`, and `sendBroadcastMessage`. While users can interact directly with the canvas to modify diagrams through touch or mouse events, the `ApollonEditor` class enables external systems to programmatically control, observe, or synchronize diagram state—providing a clean interface for embedding and extending the tool.

- *Collaboration Mode with Yjs*  
  We implement real-time collaborative editing using Yjs, synchronized with the local Zustand state. Zustand maintains the latest diagram state for rendering, while Yjs handles document synchronization across users through WebSocket-driven updates. Changes in the diagram trigger applyUpdate to propagate edits, ensuring consistency between local and shared states.

- *State Management with Zustand*  
  We replace Redux and Saga with Zustand for simpler, modular, and more performant global state handling.

- *New Node Structure*  
  We redesigned diagram nodes using React Flow’s custom node feature, enabling a clear separation of rendering logic, metadata, and interaction behavior. Each node is rendered with custom SVG elements for precise visual control. We also use React Flow’s custom handles to define and style connection points, along with built-in support for resizing.

- *New Edge Structure*  
  We replace legacy edge rendering with clean, straight, UML-compliant connectors that eliminate awkward diagonals and improve diagram readability.

- *Artemis Integration*  
  We aim to maintain a high level of compatibility with Artemis by preserving most API endpoints and aligning the new Apollon version closely with the original. While the JSON format has been updated, efforts were made to minimize integration friction and ensure a smooth transition within the LMS.

=== Enhance Accessibility for Web and Mobile Users

The second objective is to ensure Apollon works seamlessly across major platforms by using *Capacitor* to package the React app into native applications and optimizing the interface for touch-based interactions.

- *Capacitor Integration and Distribution*  
  We generate native iOS and Android apps from the web-based codebase using Capacitor, enabling unified development and consistent UX.

- *Mobile Touch and Drag Support*  
  We improve drag-and-drop interaction on mobile devices and optimize the layout to provide a better touch experience, including gesture handling and layout adjustments.  

- *Deployment*  
  We prepare production builds for both web and mobile platforms, including Docker-based deployment for the web and packaging for the App Store and Google Play.  

=== Improve the Usability and Visibility of the Application

The third objective focuses on creating a clean, intuitive interface that supports students with minimal prior experience in UML modeling. This involves simplifying layout, improving canvas interactions, and reducing friction during usage.

- *Flexible Edge Connections*  
In the new implementation, users can freely choose which handle on a node to connect from or to—without being constrained to the center of the edge. Handles appear as small circles on hover, allowing more intuitive and flexible edge creation. Unlike the previous approach, which required anchoring one end to the node’s center during creation (with extra steps needed to adjust it later).


- *Mobile Touch Support and Canvas Interactions*  
In the old system, mobile browser support was limited: once an element was dropped on the canvas, repositioning or editing it was difficult, especially on touch devices. The new implementation supports touch gestures, enabling users to drag elements after placing them and reposition them freely. Combined with an infinite canvas, this significantly improves interaction—users can now easily navigate and place elements anywhere on the canvas, making modeling more flexible and mobile-friendly.

- *Infinite Canvas*
The original Apollon used a finite canvas that only expanded when elements were dropped at the edges, which often led to frustrating layout limitations. In the new system, we use React Flow’s infinite canvas, allowing users to pan and zoom freely across a much larger working area. This gives users more freedom in how they lay out their diagrams and contributes to a smoother modeling experience.

- *Customizable Minimap*  
We enhanced navigation by integrating a minimap that reflects the full diagram layout. Unlike the original implementation, the new minimap uses simplified versions of the same SVG elements used on the canvas, maintaining visual consistency. This helps users understand the overall structure of their diagrams at a glance and navigate more efficiently.




== Outline
#TODO[
  Describe the outline of your thesis
]

This thesis begins with an overview of related modeling tools and collaboration approaches, followed by the identification of requirements based on the limitations of the previous Apollon system.

Chapter 2, *Related Work*, briefly discusses existing diagramming tools and previous research related to collaborative modeling.

Chapter 3, *Requirements*, outlines the core functional and non-functional requirements derived from our analysis.

Chapter 4, *Apollon Reengineering*, presents the restructuring of Apollon into a unified monorepo that includes the core library, standalone webapp, and collaboration server. It covers design updates such as a new node and edge structure, state management using Zustand, collaboration via Yjs, and improvements to mobile usability through Capacitor. Testing feedback and deployment aspects are also described.

Chapter 5, *Artemis Integration*, details the integration process of the reengineered Apollon library into Artemis. It includes how we preserved compatibility with existing workflows in exercises, exams, and quizzes, while migrating to the new system.

Chapter 6, *Summary and Future Work*, concludes the thesis by reflecting on the project outcomes and outlining possible directions for future development.

This is a team thesis by Belemir Kürün and Ege Nerse. Reengineering tasks in Chapter 4 were divided between the authors, while integration tasks in Chapter 5 were completed collaboratively. Author responsibilities are highlighted in each relevant section, with a summary shown below.

#table(
  columns: 2,
  align: (left, center),


[*Thesis Chapter*], [*Responsible*],
[Chapter 1: Introduction], [Belemir Kürün, Ege Nerse],
table.cell(colspan: 2)[Chapter 2: Background],
[Section 2.1: Refactoring the Standalone Web Application], [Ege Nerse],
[Section 2.2: Solving the iOS Application Issues], [Belemir Kürün],
[Section 2.3: Framework and Library Evaluation], [Ege Nerse],
[Chapter 3: Related Work], [Belemir Kürün, Ege Nerse],
[Chapter 4: Requirements], [Belemir Kürün, Ege Nerse],
table.cell(colspan: 2)[Chapter 5: Apollon Reengineering],
[5.1.1 System Design], [Ege Nerse],
[5.1.2 Node Structure in Library], [Ege Nerse],
[5.1.3 Edge Structure in Library], [Belemir Kürün],
[5.1.4 New State Management], [Ege Nerse],
[5.1.5 New Collaboration Mode], [Ege Nerse],
[5.1.6 Usability Improvements Canvas and Minimap], [Ege Nerse],
[5.1.6 Usability Improvements Shortcuts Implementation], [Belemir Kürün],
[5.2.1 Usability Improvements], [Belemir Kürün & Ege Nerse],
[5.2.2 Deployment of Apollon Standalone], [Belemir Kürün],
[5.2.3 Testing Session], [Belemir Kürün & Ege Nerse],
[Chapter 6: Artemis Integration], [Belemir Kürün & Ege Nerse],
[Chapter 7: Summary], [Belemir Kürün & Ege Nerse],

)





