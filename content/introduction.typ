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

The rendering logic is another major issue. For example, attempting to add elements such as a package lead to infinite render loops in development environment and freezes the application. These bugs create an unreliable experience, especially in the standalone web app, causing frustration for users.

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

Initial attempts to address these problems through refactoring showed limited results. Although improvements were made—such as replacing class components in the standalone web app with functional ones and introducing Redux Toolkit—many structural issues persisted, especially in the core diagramming library. The complexity, outdated design, and brittle codebase made meaningful improvements increasingly difficult.

This combination of rendering bugs, mobile limitations, structural complexity, and visual defects justified a full reengineering effort. Through prototyping and technology evaluation—including React Flow for diagramming and Capacitor for mobile deployment—we identified a modern stack that not only resolves current issues but also provides a sustainable foundation for future development.



== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]

Clear and reliable diagramming tools help students express their understanding of software systems in exercises, exams, and projects. When a tool works smoothly, students can focus on the actual content—like designing class structures or modeling system behavior—rather than struggling with the interface. By improving Apollon’s usability and responsiveness through a complete reengineering, students can complete their modeling tasks more quickly and with fewer mistakes.

This thesis was motivated not only by usability concerns, but also by the opportunity to adopt modern software engineering practices that align better with how students learn and how professional tools operate. We replaced class-based components and outdated Redux structures with functional React, Zustand for state management, and React Flow for rendering interactive diagrams. These choices reduced architectural complexity while increasing flexibility and maintainability—essential factors in an educational tool expected to evolve over time.

Better interaction design also supports learning. The introduction of features like a simplified sidebar, clean UML-compliant edge rendering, infinite canvas, and minimap improves navigation and layout clarity. Students can now find and use features with less confusion, build confidence, and create cleaner diagrams. Following usability principles, such as Nielsen’s heuristics which promote visibility, flexibility, and efficiency helps reduce the learning curve and improves how students perform during assessments @nielsen1995usability.

Improving mobile access brings additional advantages. Many students want to review or finish exercises on tablets or phones, especially before exams. Using Capacitor, we generated native iOS and Android applications from the same codebase, ensuring consistent behavior across platforms. A mobile-friendly version of Apollon allows students to sketch ideas or revise diagrams on the go. Studies show that mobile accessibility increases engagement and flexibility in education @tre2023mobile. This allows students to integrate Apollon into their daily learning routine, not just during scheduled lab sessions.

Finally, better support for collaboration helps students work together on group projects. Through real-time synchronization with Yjs, team members can co-create diagrams without conflicts, reducing miscommunication and helping them organize their ideas visually and interactively.

In short, the changes proposed in this thesis aim to support students in achieving better results in exercises, preparing more efficiently for exams, and collaborating more effectively on group projects—all through a modern, smoother, and more accessible diagramming experience.


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
  We redesign diagram nodes to separate rendering logic, metadata, and interaction behavior—making styling and extensibility significantly easier.

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
[Section 2.1: iOS Application and Standalone Issues], [Belemir Kürün],
[Section 2.2: Framework and Library Evaluation], [Ege Nerse],
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





