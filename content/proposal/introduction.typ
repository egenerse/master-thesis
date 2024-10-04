#import "/utils/todo.typ": TODO


= Introduction

Unified Modeling Language (UML) diagrams play a critical role in software development, serving as a standard for representing system architectures, workflows, and various other technical processes. These diagrams are essential in both academic and professional environments, as they provide a visual means to understand and communicate complex software designs  @waykar2013.

The Apollon UML Diagram Editor is an open-source, web-based tool that enables users to create and manipulate UML diagrams efficiently. Developed using React, TypeScript, and Redux for state management, Apollon offers a robust environment for visual modeling. In addition to its web-based platform, Apollon also provides an iOS application, built using Swift, which allows users to create and manage UML diagrams on both mobile devices and tablets, expanding its accessibility across multiple platforms.

Despite its robust functionality, Apollon has areas needing enhancement, especially in terms of user interface (UI) usability and consistency. This thesis proposes to improve these aspects by refining the UI, addressing known bugs, and introducing new features to make the tool more user-friendly and efficient for both web and iOS application.

@apollonUsageUseCaseDiagram shows how both the Student and Collaborator can interact with the Apollon UML Diagram Editor, emphasizing its collaborative features. Multiple users can work together on the same canvas, allowing for real-time contributions to the same UML diagram.

#figure(
  image("../../figures/ApollonUsageUseCaseDiagram.svg", width: 70%),
  caption: [Collaborative Apollon Usage],
) <apollonUsageUseCaseDiagram>
