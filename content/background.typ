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

Since Artemis is written in Angular, we first developed an Angular-based PoC to evaluate alignment with the existing codebase. We implemented basic node interactions such as dragging, resizing, and dynamic creation that you can see from the @angularpoc. This helped us understand the limitations of Angular in terms of performance and developer experience.

#figure(
  image("../figures/angularPoc.jpeg", width: 90%),
  caption: [Initial Angular PoC with basic node dragging and resizing functionalities]
) <angularpoc>

We then explored React as an alternative and created a PoC with React which can be seen from @reactpoc. During this process, we discovered React Flow which is a powerful and flexible diagramming library designed specifically for React applications. It provides a modular API that supports custom node and edge rendering, canvas zooming and panning, and seamless user interaction through callbacks like `onNodesChange`, `onEdgesChange`, and `onNodeClick`. These abstractions significantly simplified the development effort and increased flexibility.

#figure(
  image("../figures/reactPoc.jpeg", width: 90%),
  caption: [React PoC using React Flow with enhanced diagram interactions]
)<reactpoc>

We also tested *Capacitor* as a method to generate native mobile applications from a single shared React codebase. This trial assessed whether we could maintain feature parity across platforms while deploying the app to both iOS and Android stores. The results were promising, Capacitor successfully wrapped the React-based Apollon application, preserving its functionality on mobile devices. @reactPhone shows the first trial of Capacitor with React PoC.

#figure(
  image("../figures/reactphone.jpeg", width: 90%),
  caption: [React Flow PoC tested with Capacitor for mobile platform support]
)<reactPhone>

Based on these findings, we decided to reengineer Apollon using React Flow and modern React technologies. This decision enabled a clean redesign of core components including custom layout logic, improved edge routing, mobile touch gestures, and robust state management. It also allowed seamless integration with Capacitor for mobile deployment. The resulting architecture provides a solid foundation for long-term maintainability, extensibility, and multi-platform support.
