#import "/utils/todo.typ": TODO

= Introduction

#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]

Designing and understanding software systems is essential for both effective education and addressing real-world technological challenges. UML diagram tools help developers and students plan, explain, and improve complex systems. One such tool is Apollon, an open-source UML editor integrated into Artemis, a platform used in programming courses for interactive learning and automatic assessment. Apollon allows students to create and edit diagrams, helping them understand software design and communicate their ideas more clearly.

Although Apollon is helpful, it has several technical and usability issues. The current code is based on an outdated React structure using class components, Redux, and Redux Saga, making the application hard to maintain and update. The user interface is sometimes confusing and hides important features, reducing its efficiency and making the learning curve steeper for students.

The mobile experience introduces further limitations. The only native mobile support was an iOS app, which suffered from rendering issues when moving elements. There was no native Android application, and the mobile browser version lacked proper support for touch interactions, making it impractical to use on phones and tablets—greatly limiting accessibility for many users.

These issues prompted a deep re-evaluation of Apollon’s architecture. Initially, small refactors were attempted to improve the existing codebase: fixing bugs, updating components, and replacing deprecated libraries. This began with converting the standalone web app from class-based React to modern functional components and React Hooks. Legacy Redux and side-effect handling patterns like Redux Observable were replaced with Redux Toolkit for clearer and more maintainable state logic. During this process, many persistent bugs were resolved.

However, the underlying structure—especially in the core diagram library—remained highly complex and reliant on outdated concepts. This raised a critical question: should we continue patching the system or rewrite it from scratch?

To answer this, we conducted several proof-of-concept (POC) experiments using both Angular and modern React. These explored interaction patterns like sidebar integration, draggable elements, and mobile responsiveness. Capacitor was also tested at this stage, confirming that we could generate native mobile apps from the new React codebase while maintaining a shared source. After evaluating the results, we chose to adopt React Flow, a flexible diagramming library that allows for custom nodes, edges, and infinite canvas features. It also provides a modern API with powerful event callbacks such as onNodesChange, onEdgesChange, and onNodeClick, which simplified development significantly.

Following these successful trials, we began reengineering Apollon around React Flow and modern React architecture. This included custom node and edge logic, better layout systems, improved drag-and-drop usability, and full support for web and mobile platforms using Capacitor. The result is a more robust, extensible, and maintainable application that is prepared to meet the evolving needs of both students and developers.

By improving Apollon’s design, interaction, and mobile support, this work helps students create diagrams more easily and prepares them to work on real-world software projects that require clear system design and collaboration.

This thesis documents that transformation—from identifying limitations in the original tool to designing, developing, and integrating a fully modernized version of Apollon for broader and more effective use.


== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]

Apollon has several technical and usability problems that affect both students and developers. The tool still uses outdated React class components, Redux, and Saga for state and side-effect management, which makes the code hard to read, debug, and extend. Developers face difficulties when adding new features or fixing bugs because of the tightly coupled and complex architecture, slowing progress and introducing further errors.

The rendering logic is another major issue. For example, attempting to add elements such as a package lead to infinite render loops in development environment and freezes the application. These bugs create an unreliable experience, especially in the standalone web app, causing frustration for users.

The situation worsens on mobile devices. The app does not support drag-and-drop interactions well, making it cumbersome to create or manipulate elements. The sidebar consumes too much space, restricting the canvas area, and the interface lacks touch optimizations. These factors make it impractical for students to use Apollon comfortably on phones or tablets.

Additionally, diagram aesthetics suffer due to the way edges are rendered. Instead of clean lines, some connections appear with awkward diagonal shapes, distorting UML diagrams and reducing their readability and professionalism. These visual inconsistencies negatively affect the quality of diagrams submitted for exercises and assessments.

Initial attempts to address these problems through refactoring showed limited results. Although improvements were made—such as replacing class components in the standalone web app with functional ones and introducing Redux Toolkit—many structural issues persisted, especially in the core diagramming library. The complexity, outdated design, and brittle codebase made meaningful improvements increasingly difficult.

This combination of rendering bugs, mobile limitations, structural complexity, and visual defects justified a full reengineering effort. Through prototyping and technology evaluation—including React Flow for diagramming and Capacitor for mobile deployment—we identified a modern stack that not only resolves current issues but also provides a sustainable foundation for future development.



== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]


Clear and reliable diagramming tools help students express their understanding of software systems in exercises, exams, and projects. When a tool works smoothly, students can focus on the actual content—like designing class structures or modeling system behavior—rather than struggling with the interface. By improving Apollon’s usability and responsiveness through a complete reengineering, students can complete their modeling tasks more quickly and with fewer mistakes.

This thesis was motivated not only by usability concerns, but also by the opportunity to adopt modern software engineering practices that align better with how students learn and how professional tools operate. We replaced class-based components and outdated Redux structures with functional React, Zustand for state management, and React Flow for rendering interactive diagrams. These choices reduced architectural complexity while increasing flexibility and maintainability—essential factors in an educational tool expected to evolve over time.

Better interaction design also supports learning. The introduction of features like a simplified sidebar, clean UML-compliant edge rendering, infinite canvas, and minimap improves navigation and layout clarity. Students can now find and use features with less confusion, build confidence, and create cleaner diagrams. Following usability principles, such as Nielsen’s heuristics—which promote visibility, flexibility, and efficiency—helps reduce the learning curve and improves how students perform during assessments @nielsen1995usability.

Improving mobile access brings additional advantages. Many students want to review or finish exercises on tablets or phones, especially before exams. Using Capacitor, we generated native iOS and Android applications from the same codebase, ensuring consistent behavior across platforms. A mobile-friendly version of Apollon allows students to sketch ideas or revise diagrams on the go. Studies show that mobile accessibility increases engagement and flexibility in education @tre2023mobile. This allows students to integrate Apollon into their daily learning routine, not just during scheduled lab sessions.

Finally, better support for collaboration helps students work together on group projects. Through real-time synchronization with Yjs, team members can co-create diagrams without conflicts, reducing miscommunication and helping them organize their ideas visually and interactively.

In short, the changes proposed in this thesis aim to support students in achieving better results in exercises, preparing more efficiently for exams, and collaborating more effectively on group projects—all through a modern, smoother, and more accessible diagramming experience.


== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]

== Objectives

The goal of this thesis is to modernize and improve the Apollon UML Diagram Editor by reengineering its codebase, enhancing accessibility across platforms, and simplifying the user experience. These improvements aim to help students create UML diagrams more effectively during programming exercises, exams, and software design projects.

Before implementation began, a series of proofs of concept (POCs) were conducted to evaluate the viability of various frameworks and libraries. These included experiments with Angular, React, React Flow, and Capacitor to assess core rendering strategies, mobile support, and usability. These POCs confirmed that a React-based architecture with React Flow for diagramming and Capacitor for mobile packaging offered the most flexible and scalable solution.

To achieve the goals of the project, we define the following three main objectives:

1. *Reengineer the Apollon codebase using modern React technologies and create a reusable library interface*
2. *Enhance accessibility for both web and mobile users*
3. *Improve the overall usability and visibility of the application*

We explain each objective in detail below and state the responsibilities of each author.

=== Reengineer the Apollon Codebase Using Modern React

The first objective is to replace the outdated class-based React architecture with modern *functional components*, using *React Flow* as the core rendering and layout engine. This transformation improves maintainability, supports modular development, and creates a solid foundation for future extensions. While modernizing the internals, we preserved a key architectural idea from the original Apollon: exposing the diagram editor through a central class interface that can be embedded into any host application.

- *Proofs of Concept and Technology Evaluation*  
  We explored alternative approaches with Angular and evaluated diagramming libraries. The final design is based on React Flow and functional React after testing custom node rendering, edge handling, and drag/drop behavior.

- *Creation of the `ApollonEditor` Interface Class*  
  Similar to the original Apollon, our implementation includes a core class—`ApollonEditor`—that serves as the main integration layer between the library and external consumers (e.g., the standalone web app or Artemis). It follows the same pattern of injecting the React application into a target HTML element. The class exposes a stable API for consuming applications, including methods such as `subscribeToModelChange`, `getModel`, `setModel`, `exportAsSVG`, and `sendBroadcastMessage`. While users can interact directly with the canvas to modify diagrams through touch or mouse events, the `ApollonEditor` class enables external systems to programmatically control, observe, or synchronize diagram state—providing a clean interface for embedding and extending the tool.



- *Collaboration Mode with Yjs*  
  We implement real-time collaborative editing using Yjs, including fixes for shared-state rendering consistency.

- *State Management with Zustand*  
  We replace Redux and Saga with Zustand for simpler, modular, and more performant global state handling.

- *New Node Structure*  
  We redesign diagram nodes to separate rendering logic, metadata, and interaction behavior—making styling and extensibility significantly easier.

- *New Edge Structure*  
  We replace legacy edge rendering with clean, straight, UML-compliant connectors that eliminate awkward diagonals and improve diagram readability.

- *Artemis Integration*  
  We maintain compatibility with Artemis by preserving the original JSON schema and API endpoints, ensuring the new Apollon version can be used without changes to the LMS.

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

- *Initial Sidebar and Interaction Features*  
  Allowing users to drag elements onto the canvas in both desktop and mobile contexts. This feature was first validated during the POCs and became central to the interaction model of the application.

- *Sidebar Simplification*  
  We redesign the sidebar for clarity and space efficiency, allowing users to focus on the canvas without unnecessary clutter. 

- *Keyboard Shortcuts and Interaction Speedups*  
  We add shortcut keys and micro-interaction optimizations to reduce the time needed to perform common modeling tasks.

- *Infinite Canvas and Customizable Minimap*  
  We leverage React Flow’s built-in support for an infinite canvas, which allows users to scroll and explore large diagrams more freely—an improvement over the fixed-size canvas in the original Apollon. For enhanced navigation, we also customize React Flow’s minimap feature by rendering simplified SVG versions of our custom nodes, making it more intuitive and visually aligned with the main canvas.


== Outline
#TODO[
  Describe the outline of your thesis
]

== Outline

This thesis begins with an overview of related modeling tools and collaboration approaches, followed by the identification of requirements based on the limitations of the previous Apollon system.

Chapter 2, *Related Work*, briefly discusses existing diagramming tools and previous research related to collaborative modeling.

Chapter 3, *Requirements*, outlines the core functional and non-functional requirements derived from our analysis.

Chapter 4, *Apollon Reengineering*, presents the restructuring of Apollon into a unified monorepo that includes the core library, standalone webapp, and collaboration server. It covers design updates such as a new node and edge structure, state management using Zustand, collaboration via Yjs, and improvements to mobile usability through Capacitor. Testing feedback and deployment aspects are also described.

Chapter 5, *Artemis Integration*, details the integration process of the reengineered Apollon library into Artemis. It includes how we preserved compatibility with existing workflows in exercises, exams, and quizzes, while migrating to the new system.

Chapter 6, *Summary and Future Work*, concludes the thesis by reflecting on the project outcomes and outlining possible directions for future development.

This is a team thesis by Belemir Kürün and Ege Nerse. Reengineering tasks in Chapter 4 were divided between the authors, while integration tasks in Chapter 5 were completed collaboratively. Author responsibilities are highlighted in each relevant section, with a summary shown below.






