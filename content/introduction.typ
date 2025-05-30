#import "/utils/todo.typ": TODO

= Introduction
#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]

In the realm of software engineering education, tools that support the creation and understanding of system designs play a pivotal role. One such tool is Apollon, an open-source UML diagram editor integrated into Artemis, a platform used for interactive learning and automatic assessment in software engineering courses. Apollon allows students to create, edit, and visualize UML diagrams, helping them better grasp complex object-oriented concepts and communicate their designs effectively.

While Apollon has been instrumental in academic environments, it faces significant usability and maintainability challenges. The current implementation relies on an outdated class-based React architecture, making the codebase difficult to extend and debug. Moreover, the user interface exhibits unintuitive workflows and inconsistencies across platforms, which hinder both novice and advanced users. The absence of a robust mobile experience further limits accessibility in increasingly mobile-centric learning contexts.

This thesis addresses these limitations through a comprehensive reengineering of Apollon’s frontend using modern functional React and React Flow, alongside Capacitor to unify the experience across web and native mobile platforms. The goal is to improve usability, accessibility, and developer experience, creating a tool that better supports students in learning UML and software modeling.

By simplifying interactions, enhancing the visibility of key features, and ensuring consistent functionality across devices, this thesis aims to redefine the user experience of Apollon. The redesigned tool will not only streamline the learning process for students but also serve as a maintainable and scalable foundation for future development within educational software ecosystems.

== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]

Apollon has several technical and usability problems that affect both students and developers. The tool still uses old React class components, which makes the code hard to read, update, and maintain. Developers struggle to add new features or fix bugs because the structure is outdated and complex. This slows down progress and causes more errors over time.

The user interface also creates confusion. For example, the diagram selection feature stays hidden under the file tab, which makes it hard to find. Many students cannot locate basic actions quickly, and this reduces efficiency. Apollon does not offer a smooth or modern user experience, which leads some students to choose other tools.

The collaboration mode shows serious problems. When users try to add certain elements, such as a package, the app sometimes freezes or gets stuck in an infinite render loop. This makes collaboration unreliable, especially during real-time group work.

On mobile devices, the problems become worse. The app does not support drag-and-drop properly, making it hard to create or move elements. The sidebar takes up too much space, which limits the working area on smaller screens. These issues make it uncomfortable for students to use Apollon on phones or tablets.

Finally, Apollon sometimes displays edges between elements with strange diagonal shapes that look unprofessional. These shapes break the clean structure expected in UML diagrams and make the diagrams harder to read. This weakens the quality of the visual output and makes the tool feel less polished.

Together, these problems reduce Apollon’s usability, break core features, and limit accessibility. Students cannot use it comfortably, and developers face many roadblocks while trying to fix or improve the tool. Without major changes, Apollon cannot meet the needs of modern educational environments.

== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]

Clear and reliable diagramming tools help students express their understanding of software systems in exercises, exams, and projects. When a tool works smoothly, students can focus on the actual content—like designing class structures or modeling system behavior—rather than struggling with the interface. By improving Apollon’s usability and making it easier to navigate, students will complete their modeling tasks more quickly and with fewer mistakes.

Better interaction design also supports learning. When students can find and use features without confusion, they build confidence in using modeling tools. This experience prepares them for future academic work and industry tools. Following usability principles, such as Nielsen’s heuristics—which promote visibility, flexibility, and efficiency—helps reduce the learning curve and improves how students perform during assessments [@nielsen1995usability].

Improving mobile access brings additional advantages. Many students want to review or finish exercises on tablets or phones, especially before exams or while working in teams. A mobile-friendly version of Apollon allows them to sketch ideas or revise diagrams on the go. Studies show that mobile accessibility increases engagement and flexibility in education [@tre2023mobile]. This allows students to integrate Apollon into their daily learning routine, not just during scheduled lab sessions.

Finally, better support for collaboration helps students work together on group projects. A stable and responsive collaboration mode allows team members to co-create diagrams in real time, reducing miscommunication and helping them organize their ideas visually. These improvements make group assignments easier to manage and more productive.

In short, the changes proposed in this thesis aim to support students in achieving better results in exercises, preparing more efficiently for exams, and working more effectively on group projects—all through a smoother, more accessible diagramming experience.

== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]

The goal of this thesis is to modernize and improve the Apollon UML Diagram Editor by reengineering its codebase, enhancing accessibility across platforms, and simplifying the user experience. These improvements aim to help students create UML diagrams more effectively during programming exercises, exams, and software design projects.

To achieve this, we define the following three main objectives:

1. *Reengineer the Apollon codebase using modern React technologies*
2. *Enhance accessibility for both web and mobile users*
3. *Improve the overall usability and visibility of the application*

We explain each objective in detail below and state the responsibilities of each author.

=== Reengineer the Apollon Codebase Using Modern React

The first objective is to replace the outdated class-based React architecture with modern *functional components* using *React Flow* as the core rendering and layout library. This change improves maintainability, simplifies development, and creates a more flexible foundation for future improvements.

- **Collaboration Mode with Yjs**
  We implement real-time collaborative editing using Yjs. This includes fixing issues such as freezing and infinite render loops when adding certain elements (e.g., packages).
  → _Implemented by Ege Nerse_

- **State Management with Zustand**
  We introduce Zustand to manage global application state in a cleaner and more scalable way.
  → _Implemented by Ege Nerse_

- **New Node Structure**
  We redesign the internal structure of diagram nodes to better separate logic, rendering, and data. This structure simplifies editing, styling, and future extensibility.
  → _Implemented by Ege Nerse_

- **New Edge Structure**
  We restructure how edges are handled and rendered to avoid diagonal connectors and ensure clean, UML-compliant lines.
  → _Implemented by Belemir Kürün_

- **Artemis Integration**
  We ensure full compatibility with Artemis by keeping the existing JSON format and API endpoints unchanged. This allows Apollon to function as a drop-in replacement without requiring changes to Artemis itself.
  → _Implemented by both Ege Nerse and Belemir Kürün_

=== Enhance Accessibility for Web and Mobile Users

The second objective is to ensure Apollon works seamlessly on all major platforms by building native mobile apps using *Capacitor* and optimizing the interface for smaller touch-based screens.

- **Capacitor Integration and Distribution**
  We wrap the web-based React app into native iOS and Android applications using Capacitor, maintaining a shared codebase.
  → _Implemented by Belemir Kürün_

- **Mobile Touch and Drag Support**
  We improve drag-and-drop interaction on mobile devices and optimize the layout to provide a better touch experience, including gesture handling and layout adjustments.
  → _Implemented by Ege Nerse_

- **Deployment**
  We prepare production builds for both web and mobile platforms, including Docker-based deployment for the web and packaging for the App Store and Google Play.
  → _Implemented by Belemir Kürün_

=== Improve the Usability and Visibility of the Application

The third objective focuses on making Apollon easier to use, especially for students who are new to UML diagramming. This includes improving layout, reducing clutter, and introducing features that make common actions quicker and more intuitive.

- **Sidebar Simplification and Shortcuts**
  We simplify the sidebar layout to improve focus and space usage, especially on mobile devices. We also add keyboard shortcuts for frequent actions to speed up the editing process.
  → _Implemented by Belemir Kürün_

- **Infinite Canvas and User Map**
  We add an infinite canvas and minimap that help users navigate large diagrams more easily, especially in project settings or exams with complex models.
  → _Implemented by Ege Nerse_
