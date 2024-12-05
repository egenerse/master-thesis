#import "/utils/todo.typ": TODO

= Problem

The Apollon UML Diagram Editor has several major problems that limit its usability and maintainability. Firstly, the outdated class-based React codebase is hard to debug, difficult to read, and prone to mistakes. Secondly, features like canvas resizing and collaboration are unreliable, often leading to misplaced diagrams and inconsistent updates. Lastly, the mobile interface is not user-friendly, with oversized sidebars reducing workspace and touch interactions being poorly implemented. These issues make the tool less appealing to users and challenging to improve.

For instance, as shown in @renameActivityDiagram, the diagram selection feature is hidden under the file tab in the current Apollon web application, complicating access to basic functionality. This unintuitive design frustrates users, reducing their ability to efficiently complete tasks and leading them to prefer alternative tools @Ferreira2024.


#figure(
  image("../../figures/RenameElementActivitiyDiagram.svg", width: 70%),
  caption: [Activity Diagram Demonstrating User Workflow in Apollon],
) <renameActivityDiagram>

Another problem is the lack of multi-platform accessibility. A 2023 study highlights the importance of accessibility for better educational outcomes @mobileEduTech2023. Mobile users face challenges as there is no Android app, and the iOS app has issues such as inconsistent element movement, as shown in @ClassDiagramIos. Additionally, mobile browsers are not optimized for touch interactions, making them inconvenient for creating UML diagrams. These limitations highlight the need for better design to ensure seamless and efficient use across devices.
#figure(
  image("../../figures/classDiagramBug.png", width: 80%),
  caption: [Example of a Rendering Bug in the Apollon iOS Application],
) <ClassDiagramIos>
