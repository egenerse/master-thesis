#import "/utils/todo.typ": TODO


= Introduction

Unified Modeling Language (UML) diagrams play a critical role in software development, serving as a standard for representing system architectures, workflows, and various other technical processes. These diagrams are essential in both academic and professional environments, as they provide a visual means to understand and communicate complex software designs  @waykar2013.

The Apollon UML Diagram Editor is an open-source, web-based tool that allows users to create and manipulate UML diagrams.  Built using React, TypeScript, and Redux for state management, Apollon offers a robust environment for modeling. Its core functionality allows users to drag and drop UML elements, resize and edit them, and connect them with appropriate relationships. It is also used in the Artemis platform, an online education tool designed to support interactive learning and provide automated assessments @krusche2018artemis. Students can make modeling exercises and practice what they have learned in the lecture.

Despite its robust functionality, Apollon has areas needing enhancement, especially in terms of user interface (UI) usability and consistency. This thesis proposes to improve these aspects by refining the UI, addressing known bugs, and introducing new features to make the tool more user-friendly and efficient. Additionally, the project will extend Apollon’s capabilities beyond the web platform by developing a dedicated iOS application for both iPad and iOS mobile phones. This extension aims to mirror the functionality of the web tool, ensuring that the improved features and usability enhancements are accessible on mobile devices, providing users with the flexibility to interact with UML diagrams on-the-go, and enhancing the tool’s accessibility and encouraging wider usage.

@apollonUsageUseCaseDiagram shows how both the Student and Collaborator can interact with the Apollon UML Diagram Editor, emphasizing its collaborative features. Multiple users can work together on the same canvas, allowing for real-time contributions to the same UML diagram.

#figure(
  image("../../figures/ApollonUsageUseCaseDiagram.svg", width: 70%),
  caption: [Collaborative Apollon Usage],
) <apollonUsageUseCaseDiagram>
