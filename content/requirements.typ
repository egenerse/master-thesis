#import "/utils/todo.typ": TODO

= Requirements

This chapter follows the structure from the Requirements Analysis Document in @krusche2018artemis. We begin by describing how Apollon currently works and what problems exist. Then we present the proposed improvements and list the functional requirements and quality attributes for the new system.

== Current System

Apollon is an open-source UML diagram editor used within Artemis, a learning platform for software engineering courses. The existing version of Apollon provides a wide range of diagram types and allows users to visually model software systems. It is integrated into Artemis and used by students during exercises and exams.

However, the current version suffers from several issues. The codebase is written in outdated React class components, making it hard to maintain or extend. The core of the library relies heavily on class components that connect to global state using the legacy connect API from Redux. Side effects are handled using Redux-Saga, adding another layer of complexity. This architecture makes the system difficult to understand, debug, and modernize. There is no shared structure between the standalone editor, the Artemis integration, and the mobile version. Collaboration was implemented using a patcher-based data sharing mechanism. Only an iOS mobile version exists, and it is buggy and not suitable for general use. Android was never supported.

== Proposed System

This thesis proposes a reengineering of Apollon using modern functional React, React Flow, and Capacitor. The new system is structured as an npm workspace monorepo containing three main packages: the core diagramming library, a standalone web application, and a standalone server. The standalone web app is wrapped using Capacitor to produce mobile applications for both iOS and Android, enabling cross-platform deployment from a single codebase. Full compatibility with Artemis will be maintained throughout.

=== Functional Requirements

*FR1. Artemis Compatibility*
The new Apollon must support Artemis integration and minimize the changes needed in Artemis. Updates in the library should be reflected on the Artemis side if required, and feature loss should be minimal.

*FR2. Diagram Functionality*
The system must allow users to create, delete, move, and modify diagram elements and create connections between elements. All existing functionality in Apollon must be preserved in the new version.

*FR3. Full Diagram Type Support*
All UML and modeling diagram types currently supported by Apollon (e.g., Class Diagrams, Activity Diagrams, Use Case Diagrams, Component Diagrams, etc.) must be available in the new system without feature loss.

*FR4. Client-Side WebSocket Management for Collaborative Editing*
The web application layer must handle WebSocket connections for real-time collaborative editing. The library should remain agnostic to WebSocket logic and instead provide simple, abstracted functions such as sendBroadcastMessage and receiveBroadcastedMessage. These functions enable the application layer to manage collaborative updates while keeping the library decoupled from WebSocket implementation.

=== Quality Attributes

*QA1. Unified Monorepo Structure*
The system should use an npm workspace monorepo containing the core library, standalone web editor, and standalone server. This structure should improve maintainability, code sharing, and cross-platform development.

*QA2. Usability*
The application must follow established usability principles such as Nielsen’s heuristics @nielsen1995usability. Features must be easy to find and use, especially for students new to UML modeling.

*QA3. Maintainability*
The system should be easy to  add new features and easy to bugfix. The new codebase must improve developer experience, should use function-based components. It should reduce developer onboarding time.

*QA4. Performance*
The app must open diagrams and render elements quickly. Actions like dragging, zooming, and editing must feel responsive on both web and mobile platforms.

*QA5. Accessibility*
The mobile version must support gesture navigation, drag-and-drop interactions, and optimized layouts for smaller screens which would make tool Apollon available for both mobile and web users.

*QA6. Mobile Application Support*
The system should support deployment to both iOS and Android using Capacitor. Mobile interactions (touch-based drag-and-drop, double-tap-to-edit, resizing) must feel smooth and responsive, ensuring cross-platform usability.

*QA7. Collaboration Traffic Limit*
To maintain performance and avoid WebSocket overload, updates sent during collaborative sessions must not exceed 200 KB per transmission.

