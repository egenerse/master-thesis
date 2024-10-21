#import "/utils/todo.typ": TODO


= Motivation

A well-designed user experience (UX) and interface are essential in educational technology, as they encourage students to engage more with the platform @su15107923. With a more intuitive interface, students can focus on learning UML concepts without being hindered by technical difficulties. Fowler, emphasizes that UML serves not just as a design tool but also as a communication medium, facilitating clearer understanding among students and educators alike @fowler2003uml. That's why we need to enhance the Apollon User Interface and reach as many students as possible to make communication easier.

To improve the Apollon UML Diagram Editor and increase its usage among students, we will focus on making the platform more user-friendly by fixing bugs, gathering feedback, and introducing new features. These improvements will follow Nielsen's usability heuristics, particularly principles like visibility of system status, ensuring clear feedback during actions such as dragging and dropping elements; error prevention, reducing the likelihood of mistakes during diagramming by implementing features like snapping points; and flexibility and efficiency of use, allowing experienced users to utilize shortcuts for a faster workflow @nielsen1993usability. By adhering to these guidelines, the editor will become more intuitive, promoting a smoother diagramming experience for students.

Additionally, simplifying the interface by removing unnecessary elements from the feature bar or header and keeping only essential options visible will provide more space for students to design their diagrams. This approach is especially important at the early stages of the design process, where students need to easily view the bigger picture.

At the same time, it is vital that students can quickly access necessary features without searching through tabs and buttons. Implementing hover-based suggestions, such as recommended relationships or previewing potential placements for elements before they are added, would further enhance usability by helping students visualize their designs in real time.

An example of an area that needs improvement can be seen in the diagram @renameActivityDiagram. In the current version, users are required to take multiple unnecessary steps to complete simple tasks, such as renaming an element. This extra complexity can be streamlined, making it easier and quicker for users to interact with their diagrams.

#figure(
  image("../../figures/RenameElementActivitiyDiagram.svg", width: 80%),
  caption: [Rename Activity Diagram],
) <renameActivityDiagram>


To ensure a consistent user experience, both the iOS and web applications should align in terms of usability, features, and interface design. Creating this seamless experience across platforms will make the tool more familiar and comfortable for students, regardless of the device they are using. By enhancing both the web and iOS versions, students can benefit from an efficient and accessible UML diagramming tool across multiple environments.


