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

We replaced the old editor instance with the new Apollon Editor implementation from the reengineered library. Then we updated the exercise creation and exam setup pages accordingly. Since the exam flow also relies on the same modeling editor when instructors create modeling exercises within exams, this allowed us to streamline the migration.

== Integration of Quiz Mode

Quiz creation in Artemis introduced a unique challenge. Instructors can define interactive modeling questions by selecting specific diagram elements beforehand. These selected elements are then cropped and shown in a sidebar. Students complete the quiz by dragging these pieces to the correct locations in the diagram.

To support this workflow, we implemented the *interactive mode* in the new Apollon. This required specialized handling of SVG rendering with an *exclude* functionality to remove selected elements from the main diagram view and render them in the sidebar.

In the reengineered system, we introduced a new feature that tracks a separate list, ExportingSelectedItems, instead of using selectedElementsList. This change enables users to select child elements of custom nodes—such as attributes and methods within a class node. While the previous version treated methods and attributes as standalone UML elements, the updated node structure embeds them directly within their parent class node. Consequently, we now use SVG regions and id detection to accurately identify and selectively render the appropriate elements.

This change allows for cleaner internal data models while still supporting the flexible interaction features needed for quiz workflows.

== Integration of Collaboration Mode

In team exercises, collaboration is essential, and the underlying system must ensure that all team members can work on the same diagram in real-time.

Previously, collaborative editing in Artemis was implemented using a patch-based mechanism. Each change in the Apollon diagram was captured as a "patch," which was then broadcast to other clients for incremental updates. 

In the updated system, we adopted a simplified collaboration mechanism that leverages Apollon's new capability to serialize the entire diagram model. Instead of sending incremental patch messages, the updated system transmits the complete diagram as a Base64-encoded string. This change significantly reduces the complexity of synchronization logic while preserving the core collaboration flow.

The TeamSubmissionSyncComponent remains the central piece for handling real-time synchronization. It listens for updates in the Apollon model and ensures the UI reflects the latest state. When a client modifies the diagram, it sends the full model (as a Base64 string) to the broadcast server. The server, in turn, relays this message to other connected clients, who then deserialize and apply the updated model.

To maintain compatibility with existing collaboration infrastructure, the communication flow remains unchanged: clients send messages to a broadcast server, and the server distributes these to other participants. Newly connected clients initiate a synchronization request, prompting peers to send them the current model — a mechanism aligned with the standalone web app's collaboration flow.

From an implementation perspective, the patch message structure was updated by replacing the patches field with a model field containing the Base64-encoded diagram string. Keeping structure similar to the previous implementation allows us to maintain compatibility with existing Artemis features that expect a certain message format. The TeamSubmissionSyncComponent was also updated to handle this new model field, ensuring that it can process incoming messages correctly.

This transition to model-based synchronization ensures consistency across clients.
