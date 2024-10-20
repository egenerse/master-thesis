#import "/utils/todo.typ": TODO

= Problem

A significant issue with the current state of the Apollon UML Diagram Editor is that many students are either unaware of its existence or choose not to use it. As a result, students frequently opt for other tools and websites to create their UML diagrams, leading to inconsistencies in the tools and diagram formats used across projects. This lack of usage suggests that Apollon may not be adequately promoted or user-friendly enough to attract widespread usage among students.

Several factors contribute to this problem. First, Apollon’s user interface is not intuitive or accessible enough, which can cause confusion and frustration for new users @Intechnic2023. As shown in @DiagramSelectionWeb, the diagram selection is hidden under the file tab, making it difficult for students to locate and navigate essential features. This challenge is more pronounced when compared to alternative tools with which students are more familiar @Ferreira2024.

#figure(
  image("../../figures/DiagramWebApollon.png", width: 80%),
  caption: [Diagram Selection Apollon Web Application],
) <DiagramSelectionWeb>


The 2023 study in the Journal of Educational Technology & Society emphasizes the importance of multi-platform accessibility for enhancing educational outcomes [mobileEduTech2023]. This need for accessibility extends beyond the web tool to the iOS application, which is critical for ensuring a seamless user experience across all devices. However, the iOS application presents its own set of usability challenges. For instance, the current design requires users to engage in multiple interactions for basic tasks such as moving and editing elements, which significantly hampers the tool's flexibility and efficiency. Additionally, as highlighted in the component diagram, subcomponents are not clickable because they are obscured by their parent components, complicating user interactions further [@ComponentDiagramIos]. Unlike other UML diagramming applications, Apollon lacks adaptability and is not easily customizable, underscoring a pressing need for improvements to the iOS interface to match the intuitive access provided on other platforms.
#figure(
  image("../../figures/ComponentDiagramIOS.png", width: 80%),
  caption: [Component Diagram Drag Example Ios Application],
) <ComponentDiagramIos>
