#import "/utils/todo.typ": TODO

= Background

This chapter describes the technical context and early steps that led to the reengineering of Apollon. We explain initial efforts to update the current system and then detail how technology decisions were made through proof of concept experiments.

== Refactoring the Standalone Web Application
At the start of this project, we focused on modernizing the standalone Apollon web application. The existing codebase was built using class-based React components, legacy Redux, and custom observable logic for managing side effects. These outdated technologies makes the architecture hard to maintain, extend, and debug. Our strategy involved incrementally refactoring components using functional React patterns and introducing React Hooks to simplify state and lifecycle management.

We also began replacing the legacy Redux logic with Redux Toolkit to reduce boilerplate and improve maintainability. These updates led to clearer code and helped resolve several persistent bugs, marking a meaningful improvement to the standalone application. However, as we progressed, it became clear that a significant portion of the deeper challenges comes from the shared library, where outdated state management patterns and tightly coupled logic were still in place. To build a more reliable and adaptable system, we recognized that improvements to the web app alone were insufficient.

== Investigating the iOS Application Issues
Parallel to our work on the web app, we investigated the separate iOS version of Apollon, which lived in its own repository. This version suffered from major rendering issues on Apple devices, including misaligned text elements and unstable drag-and-drop behavior. These problems significantly impaired usability on mobile platforms and made the app nearly unusable in real-world student workflows.

Additionally, maintaining the iOS app as a separate codebase introduced substantial development overhead. Features and fixes had to be implemented twice, once for web and once for mobile, leading to inconsistencies and duplicated effort. While we made attempts to patch specific issues, it became clear that the architecture was not designed for long-term maintainability or cross-platform development. These challenges strongly influenced our decision to unify the application under a single, modern codebase.

== Evaluating Technologies through Proof of Concept Experiments

To determine a suitable long-term solution, we conducted a series of proof of concept experiments. These prototypes compared different frontend frameworks, including Angular and modern React. The experiments explored various technical needs such as implementing a sidebar, enabling drag-and-drop elements, supporting infinite canvas behavior, and providing responsive design for mobile devices.

Since Artemis is written in Angular, we first developed an Angular-based PoC to evaluate alignment with the existing codebase. We implemented basic node interactions such as dragging, selecting, and dynamic creation from sidebar that you can see from the @angularpoc. This helped us understand the limitations of Angular in terms of performance and developer experience.

#figure(
  image("../figures/angularPoc.jpeg", width: 90%),
  caption: [Initial Angular PoC with basic node dragging and selecting functionalities]
) <angularpoc>

We then explored React as an alternative and created a PoC with React which can be seen from @reactpoc. During this process, we discovered React Flow which is a powerful and flexible diagramming library designed specifically for React applications. It provides a modular API that supports custom node and edge rendering, canvas zooming and panning, and seamless user interaction through callbacks like onNodesChange, onEdgesChange, and onNodeClick. These abstractions significantly simplified the development effort and increased flexibility.

#figure(
  image("../figures/reactFlowPoc.png", width: 90%),
  caption: [React PoC using React Flow with enhanced diagram interactions]
)<reactpoc>

We also tested Capacitor as a method to generate native mobile applications from a single shared React codebase. This trial assessed whether we could maintain feature parity across platforms while deploying the app to both iOS and Android stores. The results were promising, Capacitor successfully wrapped the React-based Apollon application, preserving its functionality on mobile devices. @reactPhone shows the first trial of Capacitor with plain React PoC.

#figure(
  image("../figures/reactphone.jpeg", width: 50%),
  caption: [Plain React PoC tested with Capacitor for mobile platform support]
)<reactPhone>

Based on these findings, we decided to reengineer Apollon using React Flow and modern React technologies. This decision enabled a clean redesign of core components including custom layout logic, improved edge routing, mobile touch gestures, and robust state management. It also allowed seamless integration with Capacitor for mobile deployment. The resulting architecture provides a solid foundation for long-term maintainability, extensibility, and multi-platform support.
