#import "/utils/todo.typ": TODO


= Introduction

 The Apollon UML Diagram Editor is an open-source tool developed with React, TypeScript, and Redux, facilitates the efficient creation and manipulation of UML diagrams on the web. Unified Modeling Language (UML) diagrams are vital in software development for representing system architectures and workflows, providing a standard for visualizing complex designs in both academic and professional settings @waykar2013. Apollon also offers an iOS application built with Swift, allowing diagram management on mobile devices. This thesis aims to enhance Apollon's UI, fix bugs, and introduce features that improve usability across platforms.

@apollonUsageUseCaseDiagram shows how both the Student and Collaborator can interact with the Apollon UML Diagram Editor, emphasizing its collaborative features. Multiple users can work together on the same canvas, allowing for real-time contributions to the same UML diagram.

#figure(
  image("../../figures/ApollonUsageUseCaseDiagram.svg", width: 70%),
  caption: [Collaborative Apollon Usage],
) <apollonUsageUseCaseDiagram>
