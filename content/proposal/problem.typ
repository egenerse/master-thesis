#import "/utils/todo.typ": TODO

= Problem

A significant issue with the current state of the Apollon UML Diagram Editor is that many students are either unaware of its existence or choose not to use it for their theses. As a result, students frequently opt for other tools and websites to create their UML diagrams, leading to inconsistencies in the tools and diagram formats used across projects. This lack of usage suggests that Apollon may not be adequately promoted or user-friendly enough to attract widespread usage among students.

Several factors contribute to this problem. First, Apollon’s user interface is not intuitive or accessible enough, which can cause confusion and frustration for new users @Intechnic2023. As shown in @DiagramSelectionWeb, the diagram selection is hidden under the file tab, making it difficult for students to locate and navigate essential features. This challenge is more pronounced when compared to alternative tools with which students are more familiar @Ferreira2024.

Similarly, the iOS application, while available for mobile devices and tablets, also presents several usability challenges. The current design requires users to click multiple times to perform basic actions, such as moving and editing elements, which limits the flexibility and efficiency of the tool. Additionally, as shown in the given figure, subcomponents are not clickable because they are blocked by their parent component, further complicating interactions @ComponentDiagramIos. Compared to other UML diagramming applications, Apollon is less adaptable and not open to easy customization.


#figure(
  image("../../figures/DiagramWebApollon.png", width: 80%),
  caption: [Diagram Selection Apollon Web Application],
) <DiagramSelectionWeb>

#figure(
  image("../../figures/ComponentDiagramIOS.png", width: 80%),
  caption: [Component Diagram Drag Example Ios Application],
) <ComponentDiagramIos>
