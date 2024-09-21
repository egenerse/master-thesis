#import "/utils/todo.typ": TODO


= Introduction

Unified Modeling Language (UML) diagrams play a critical role in software development, serving as a standard for representing system architectures, workflows, and various other technical processes. These diagrams are essential in both academic and professional environments, as they provide a visual means to understand and communicate complex software designs  @waykar2013.

The Apollon UML Diagram Editor is an open-source, web-based tool that allows users to create and manipulate UML diagrams.  Built using React, TypeScript, and Redux for state management, Apollon offers a robust environment for modeling. Its core functionality allows users to drag and drop UML elements, resize and edit them, and connect them with appropriate relationships. It is also used in the Artemis platform, an online education tool designed to support interactive learning and provide automated assessments @krusche2018artemis. Students can make modeling exercises and practice what they have learned in the lecture.

However, as with many open-source projects, Apollon has room for improvement, particularly in the areas of usability and UI consistency. This thesis will focus on addressing these issues by enhancing the user interface, fixing known bugs, and adding new features to ensure the tool provides a more easy to use user experience.

@apollonUsageUseCaseDiagram shows how both the Student and Collaborator can interact with the Apollon UML Diagram Editor, emphasizing its collaborative features. Multiple users can work together on the same canvas, allowing for real-time contributions to the same UML diagram.

#figure(
  image("../../figures/ApollonUsageUseCaseDiagram.svg", width: 70%),
  caption: [Collaborative Apollon Usage],
) <apollonUsageUseCaseDiagram>
