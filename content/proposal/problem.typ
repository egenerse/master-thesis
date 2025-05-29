#import "/utils/todo.typ": TODO

= Problem

The Apollon UML Diagram Editor faces several major issues that impact its usability and maintainability. The outdated class-based React codebase makes debugging difficult, reading harder, and causes frequent errors. This outdated architecture complicates development tasks and slows down progress. Modernizing the codebase with a function-based architecture is necessary to improve readability, reduce bugs, and enhance maintainability.

The unreliable behavior of core features like canvas resizing and collaboration frequently causes misplaced diagrams and inconsistent updates. For example, the current Apollon web application hides the diagram selection feature under the file tab, making it difficult to access basic functionality, as shown in @renameActivityDiagram. This unintuitive design frustrates users and reduces their efficiency, leading many to prefer alternative tools @Ferreira2024.

#figure(
  image("../../figures/RenameElementActivitiyDiagram.svg", width: 70%),
  caption: [Activity Diagram Demonstrating User Workflow in Apollon],
) <renameActivityDiagram>

The lack of multi-platform accessibility limits the tool’s effectiveness. A 2023 study highlights the importance of accessibility for better educational outcomes @mobileEduTech2023. Mobile users face challenges due to the absence of an Android app, while the iOS app suffers from inconsistent element movement, as shown in @ClassDiagramIos. Additionally, mobile browsers lack optimization for touch interactions, making it inconvenient to create UML diagrams. These limitations demand a better design to ensure seamless and efficient use across devices.

#figure(
  image("../../figures/classDiagramBug.png", width: 80%),
  caption: [Example of a Rendering Bug in the Apollon iOS Application],
) <ClassDiagramIos>