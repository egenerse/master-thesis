#import "/utils/todo.typ": TODO

= Related Work
#TODO[
  Describe related work regarding your topic and emphasize your (scientific) contribution in contrast to existing approaches / concepts / workflows. Related work is usually current research by others and you defend yourself against the statement: “Why is your thesis relevant? The problem was already solved by XYZ.” If you have multiple related works, use subsections to separate them.
]

Several modern diagramming tools have inspired this thesis, most notably Draw.io[^drawio] and bpmn.io[^bpmn]. These platforms offer robust and intuitive interfaces for creating diagrams using drag-and-drop techniques. They feature clear layout tools, multiple diagram types, and real-time rendering. However, they are built for general use cases and do not support integration into educational platforms, assessment workflows, or mobile-first interfaces tailored to students. Despite this, their UI structure and interaction patterns served as a useful reference point for improving Apollon’s usability and visual layout.

In the academic context, Eugene Okafor’s thesis on *Collaboration and Conflict Resolution in a Web-based UML Modeling Editor*[@okafor2022collaboration] introduced collaboration support into Apollon. His work utilized Yjs, a CRDT-based framework, to implement real-time multi-user editing. This thesis also uses Yjs to maintain consistency across users but builds upon it by combining it with *React Flow*, a modern React library designed for building node-based editors. React Flow offers useful abstractions like nodes, edges, popovers, and toolbars, which make modeling interfaces easier to build and customize.

Unlike Okafor’s thesis, which primarily focused on adding collaborative editing to the existing Apollon infrastructure, this thesis proposes a complete reengineering of the frontend. It adopts functional React components, modern state management with Zustand, and prepares the application for mobile platforms using Capacitor. These changes aim to provide a more maintainable, scalable, and accessible version of Apollon that fits the needs of students working across devices and environments.

Draw.io #footnote[https://www.diagrams.net/]


#figure(
  image("../figures/drawio.png", width: 90%),
  caption: [User interface of Draw.io, a widely used online diagramming tool]
)

Bpmn.io #footnote[https://bpmn.io/]

#figure(
  image("../figures/bpmnio.png", width: 90%),
  caption: [The modeling interface of bpmn.io with BPMN diagram capabilities]
)