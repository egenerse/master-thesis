#import "/utils/todo.typ": TODO

= Artemis Integration
#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]

Apollon is developed as a reusable diagramming library, but its primary consumer is the Artemis platform. Within Artemis, Apollon is used in modeling exercises, exams, and quizzes, both for individual and team-based student participation. Because of its deep integration, one of the key objectives of this thesis was to ensure a smooth migration from the old version of Apollon to the newly reengineered version without breaking any existing Artemis functionalities.

== Artemis Integration Plan

We began by analyzing how Artemis uses Apollon and identifying the components that depend on the Apollon Editor interface and Apollon model types. As a result, we created a high-level integration diagram that illustrates the key modules within Artemis that consume Apollon.

#figure(
  image("../figures/ArtemisIntegrationColored.png", width: 90%),
  caption: [Top Level Architecture of Artemis Integration with Apollon Reengineering Library]
)

Due to the modular structure of Artemis, we identified three key components that are widely reused by other modules and those are highlighted as green in the Top Level architecture:

  - *Modeling Editor*: the editor used for creating and editing diagrams.
  - *Apollon Diagram Model*: shared interfaces for representing diagrams.
  - *Modeling Submission*: logic and endpoints related to saving and submitting models.


We focused on integrating these components first, as they form the backbone of Apollon's usage across Artemis features.

== Modeling Editor Integration

One of the most critical integration points was the *Modeling Editor* component. This component is invoked both in standard exercises and exams, meaning that any change here would impact a large part of Artemis.

We replaced the old editor instance with the new Apollon Editor implementation from the reengineered library. Then we updated the exercise creation and exam setup pages accordingly.

Since the exam flow also relies on the same modeling editor when instructors create modeling exercises within exams, this allowed us to streamline the migration. One special case was the *Solution Model* feature used in instructor workflows, which relied on the old SVG rendering logic. We replaced this with the updated SVG export method from the new Apollon library.

== Integration of Quiz Mode

Quiz creation in Artemis introduced a unique challenge. Instructors can define interactive modeling questions by selecting specific diagram elements beforehand. These selected elements are then cropped and shown in a sidebar. Students complete the quiz by dragging these pieces to the correct locations in the diagram.

To support this workflow, we implemented the *interactive mode* in the new Apollon. This required specialized handling of SVG rendering with an *exclude* functionality to remove selected elements from the main diagram view and render them in the sidebar.

In the reengineered system, we introduced this feature by tracking mouse `enter` events on the individual SVG elements of the node (method or attribute). While the previous version treated methods and attributes as standalone UML elements, our new node structure embeds them within the class node. As a result, we rely on SVG regions and `id` detection to distinguish and selectively render the appropriate elements.

This change allows for cleaner internal data models while still supporting the flexible interaction features needed for quiz workflows.

== Integration of Collaboration Mode

*To be completed later.*

== SVG Renderer

*To be completed later.*