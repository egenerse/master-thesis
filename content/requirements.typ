#import "/utils/todo.typ": TODO

= Requirements

This chapter follows the structure from the Requirements Analysis Document in @krusche2018artemis. We begin by describing how Apollon currently works and what problems exist. Then we present the proposed improvements and list the functional and non-functional requirements for the new system.

== Current System

Apollon is an open-source UML diagram editor used within Artemis, a learning platform for software engineering courses. The existing version of Apollon provides a wide range of diagram types and allows users to visually model software systems. It is integrated into Artemis and used by students during exercises and exams.

However, the current version suffers from several issues. The codebase is written in outdated React class components, making it hard to maintain or extend. There is no shared structure between the standalone editor, the Artemis integration, and the mobile version. Collaboration is based on an earlier implementation using Yjs, but the update handling logic is deeply embedded in the library, limiting flexibility. Only an iOS mobile version exists, and it is buggy and not suitable for general use. Android was never supported.

== Proposed System

This thesis proposes a reengineering of Apollon using modern functional React, React Flow, and Capacitor. The new system will be organized as a monorepo that includes the core diagramming library, a standalone editor, and mobile applications for both iOS and Android. Collaboration mode will be refactored to move WebSocket logic out of the library, allowing different platforms to handle connections independently. Full compatibility with Artemis will be maintained throughout.

=== Functional Requirements

*FR1. Artemis Compatibility*
The new Apollon must fully support Artemis integration. This includes keeping the current diagram JSON format and all API interactions unchanged to ensure it works as a drop-in replacement.

*FR2. Unified Monorepo Structure*
Apollon will be restructured into a monorepo containing the core library, the standalone web editor, and the mobile distribution. Each part must share code and follow consistent design principles.

*FR3. Mobile Application Support*
Apollon must support deployment to both iOS and Android devices using Capacitor. Mobile interactions such as touch-based drag-and-drop, tap-to-edit, and resizing must be smooth and responsive.

*FR4. WebSocket Refactoring*
WebSocket connections for collaborative editing must be managed from the web application layer instead of the shared library. This enables better control and modular integration into host systems like Artemis.

*FR5. Collaboration Traffic Limit*
To maintain performance and avoid WebSocket overload, updates sent during collaborative sessions must not exceed 200KB per transmission.

*FR6. Diagram Functionality*
The system must allow users to create, delete, move, connect, and modify diagram elements. All existing functionality in Apollon must be preserved in the new version.

*FR7. Full Diagram Type Support*
All UML and modeling diagram types currently supported by Apollon (e.g., Class Diagrams, Activity Diagrams, Use Case Diagrams, Component Diagrams, etc.) must be available in the new system without loss of features.

*FR8. Consistent Feature Set Across Platforms*
The standalone web app, the mobile version, and the Artemis integration must expose the same diagramming features to provide a uniform experience.

=== Quality Attributes

*QA1. Usability*
The application must follow established usability principles such as Nielsen’s heuristics @nielsen1995usability. Features must be easy to find and use, especially for students new to UML modeling.

*QA2. Maintainability*
The system should be easy to extend and refactor. The new codebase must use modular, function-based components with clearly separated logic to reduce developer onboarding time.

*QA3. Scalability*
The system must support multiple large diagrams in collaboration mode without noticeable slowdowns. Diagram rendering and update propagation must remain responsive even in group settings.

*QA4. Performance*
The app must open diagrams and render elements quickly. Actions like dragging, zooming, and editing must feel responsive on both web and mobile platforms.

*QA5. Accessibility*
The mobile version must support gesture navigation, drag-and-drop interactions, and optimized layouts for smaller screens. Keyboard navigation and screen reader support are recommended for inclusivity.
