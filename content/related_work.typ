= Related Work

Several modern diagramming tools have influenced the direction of this thesis, most notably Draw.io #footnote[https://www.diagrams.net/] and Bpmn.io #footnote[https://bpmn.io/]. Draw.io provides users with a wide range of tools and customization options, offering flexibility during modeling. As shown in @drawio, the left and right panels offer various styling, text, and drawing tools. The platform also supports component alignment through visual helper lines, which improves precision during diagram construction.

#figure(
  image("../figures/drawio.png", width: 90%),
  caption: [User interface of Draw.io, a widely used online diagramming tool]
) <drawio>

Bpmn.io features a clean layout and a compact sidebar, which maximizes the available canvas space, as illustrated in @bpmnio. Both platforms provide intuitive and responsive interfaces for diagram creation. However, they focus on general-purpose diagramming and do not support educational workflows, assessment systems, or mobile-first design targeted at student interaction. Despite these limitations, their design patterns and interaction mechanisms served as valuable references for improving Apollon’s usability and visual structure.

#figure(
  image("../figures/bpmnio.png", width: 90%),
  caption: [The modeling interface of bpmn.io with BPMN diagram capabilities]
) <bpmnio>

In the academic domain, Eugene Okafor’s thesis on *Collaboration and Conflict Resolution in a Web-based UML Modeling Editor* @okafor2022collaboration introduced real-time collaborative editing to Apollon. He integrated Yjs, a CRDT-based framework, to enable concurrent multi-user editing in the modeling interface.

This thesis also adopts Yjs for synchronization but extends the approach by integrating *React Flow*, a powerful library for building node-based editors in React. React Flow provides abstractions like nodes, edges, toolbars, and popovers, which simplify the development of interactive modeling features and reduce implementation complexity.

While Okafor’s work focused on embedding collaboration into the legacy Apollon structure, this thesis presents a complete reengineering of the frontend. It introduces functional React components, modern state management using Zustand, and mobile platform support through Capacitor. These improvements aim to deliver a maintainable, scalable, and accessible tool that better serves students across devices and use cases.
