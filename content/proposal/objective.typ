#import "/utils/todo.typ": TODO

= Objective

As outlined, this thesis focuses on reengineering the Apollon UML Diagram Editor with the following goals:


*1.Reengineer the codebase with modern React* to improve maintainability and scalability.

*2.Enhance accessibility for web and mobile users* for consistent usability.

*3.Improve user experience in usability and visibility* by simplifying workflows and enhancing feature accessibility.

== Reengineer the Codebase with Modern React

The first phase focuses on reengineering the codebase by switching to functional components and adopting the latest React standards. This approach makes the system easier to maintain, scale, and debug, creating a strong foundation for future updates. A function-based structure removes the limitations of the current class-based design and allows smoother development. The reengineering process will keep the existing JSON and API format the same to maintain compatibility with Artemis, ensuring no to minimal adaptions.

React Flow provides a base for managing diagram components and interactions. The project will customize and extend the library to meet specific needs, simplifying complex tasks and improving the user experience. The updated codebase follows modern React practices to ensure consistency and clarity.

== Enhance Accessibility for Web and Mobile Users

This goal improves accessibility by using Capacitor to create a unified codebase for both web and native applications. Capacitor converts the web app into native apps for iOS and Android, removing the need for separate codebases. This approach simplifies maintenance and provides a consistent experience across all devices.

The project adds touch gestures, such as drag-and-drop and hand gestures, to enhance usability for mobile users and web browsers. These features will make interactions smoother and create a better user experience, allowing users to work easily on mobile devices.

== Improve User Experience in Usability and Visibility

This phase makes the editor more intuitive by simplifying workflows and improving access to key features. The enhancements include shortcuts for common tasks, allowing users to perform actions quickly. Inline editing for diagram elements replaces unnecessary popups, reducing friction and improving efficiency. These changes provide a smoother, more user-friendly experience for both novice and advanced users.

To enhance visibility, the project adds customization options for path creation, enabling more expressive and flexible diagramming. The design prominently displays key features such as creating new diagrams, importing/exporting files, and accessing collaboration mode on the main screen. These adjustments help users easily discover essential functionalities, reduce the learning curve, and improve overall usability.