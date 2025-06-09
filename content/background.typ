#import "/utils/todo.typ": TODO

= Background
// Describe each proven technology / concept shortly that is important to understand your thesis.
// Point out why it is interesting for your thesis.


This chapter describes the technical context and early steps that led to the reengineering of Apollon. We explain initial efforts to update the current system and then detail how technology decisions were made through proof-of-concept experiments.

== Initial Attempts to Refactor the Existing Standalone and iOS Application

At the beginning of this work, we focused on improving the existing Apollon standalone web app and mobile iOS repository. We attempted to modernize the old codebase, which relied heavily on class-based React components, legacy Redux, and custom observable side-effect handling. These technologies made the system difficult to maintain and debug. Our initial approach involved gradually introducing functional React components and React Hooks while replacing outdated Redux logic with the more maintainable Redux Toolkit.

During this process, we resolved several persistent bugs in the standalone version. At the same time, we investigated the iOS application, which existed in a separate repository. That mobile version had critical rendering issues, such as misaligned text and unstable drag behavior, making it nearly unusable on iOS devices. Maintaining two separate repositories — one for web and one for mobile — led to significant duplication and friction in development. Despite our efforts to update and synchronize the platforms, the architectural limitations of the existing code made continued patching unsustainable.

== Evaluating Technologies through Proof-of-Concept Experiments

To determine a suitable long-term solution, we conducted a series of proof-of-concept (PoC) experiments. These prototypes compared different frontend frameworks, including Angular and modern React. The experiments explored various technical needs such as implementing a sidebar, enabling drag-and-drop elements, supporting infinite canvas behavior, and providing responsive design for mobile devices.

We also tested Capacitor as a way to create cross-platform native applications from a single codebase. The results confirmed that we could use a unified React codebase to generate native apps for both iOS and Android while preserving full functionality on the web.

Among the tested libraries, React Flow emerged as the most promising diagramming solution. Its modular architecture supports custom node and edge rendering, canvas zooming and panning, and intuitive user interaction through callbacks like `onNodesChange`, `onEdgesChange`, and `onNodeClick`. These features significantly reduced implementation complexity and enhanced flexibility for future development.

Based on these findings, we decided to reengineer Apollon using React Flow and modern React technologies. This decision enabled a clean redesign of core components including custom layout logic, improved edge routing, mobile touch gestures, and robust state management. It also allowed seamless integration with Capacitor for mobile deployment. The resulting architecture provides a solid foundation for long-term maintainability, extensibility, and multi-platform support.
